import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:epubx/epubx.dart';
import '../models/book.dart';

class EpubService {
  static final Map<String, EpubBook> _cache = {};

  static Future<List<Book>> loadEpubBooks() async {
    final books = <Book>[];
    
    try {
      // Load EPUB Assets
      final epubFiles = [
        'assets/daedonggangeun sogsaginda - gimdongin.epub',
        'assets/noingwa bada - eoniseuteu hemingwei.epub',
      ];

      for (int i = 0; i < epubFiles.length; i++) {
        final epubPath = epubFiles[i];

        try {
          final book = await _loadEpubFromAssets(epubPath, (i + 1).toString());
          if (book != null) {
            books.add(book);
          } else {
          }
        } catch (e, _) {
          final fallbackBook = Book(
            id: (i + 1).toString(),
            title: _extractTitleFromPath(epubPath),
            author: '알 수 없는 작가',
            description: '파일을 읽는 중 오류가 발생했습니다: $e',
            coverImage: 'https://images.unsplash.com/photo-1481627834876-b7833e8f5570?w=300&h=400&fit=crop',
            content: ['이 책을 읽는 중 오류가 발생했습니다. 파일이 손상되었거나 지원되지 않는 형식일 수 있습니다.'],
            publishYear: DateTime.now().year,
            isEpub: true,
          );
          books.add(fallbackBook);
        }
      }
      
    } catch (e, s) {
      debugPrint('오류가 발생했습니다: $e\n$s');
    }

    return books;
  }

  static Future<Book?> _loadEpubFromAssets(String assetPath, String id) async {
    try {
      final ByteData data = await rootBundle.load(assetPath);
      final Uint8List bytes = data.buffer.asUint8List();
      
      final epubBook = await EpubReader.readBook(bytes);
      
      _cache[id] = epubBook;
      
      final title = epubBook.Title ?? _extractTitleFromPath(assetPath);
      final author = epubBook.Author ?? '알 수 없는 작가';
      final description = epubBook.Schema?.Package?.Metadata?.Description ?? '';
      
      final chapters = _extractChapters(epubBook);
      
      final coverImage = 'https://images.unsplash.com/photo-1481627834876-b7833e8f5570?w=300&h=400&fit=crop';
      
      int publishYear = DateTime.now().year;
      try {
        final dateString = epubBook.Schema?.Package?.Metadata?.Dates?.firstOrNull?.Date;
        if (dateString != null) {
          final parsedDate = DateTime.tryParse(dateString);
          if (parsedDate != null) {
            publishYear = parsedDate.year;
          }
        }
      } catch (e) {
        // Use default year if parsing fails
      }

      return Book(
        id: id,
        title: title,
        author: author,
        description: description,
        coverImage: coverImage,
        content: chapters,
        publishYear: publishYear,
        language: epubBook.Schema?.Package?.Metadata?.Languages?.firstOrNull,
        publisher: epubBook.Schema?.Package?.Metadata?.Publishers?.firstOrNull,
        isEpub: true,
      );
    } catch (e) {
      return null;
    }
  }

  static String _extractTitleFromPath(String path) {
    final fileName = path.split('/').last;
    final nameWithoutExtension = fileName.replaceAll('.epub', '');
    
    // Clean up the filename to make it more readable
    return nameWithoutExtension
        .replaceAll(' - ', ' - ')
        .split(' - ')
        .first
        .trim();
  }

  static List<String> _extractChapters(EpubBook epubBook) {
    final chapters = <String>[];
    
    try {
      // Method 1: Try reading order from spine
      final spine = epubBook.Schema?.Package?.Spine?.Items;

      if (spine != null && spine.isNotEmpty) {
        for (int i = 0; i < spine.length; i++) {
          final spineItem = spine[i];

          try {
            final htmlContent = epubBook.Content?.Html?[spineItem.IdRef];
            if (htmlContent != null) {
              final content = htmlContent.Content;

              if (content != null && content.isNotEmpty) {
                final text = _extractTextFromHtml(content);
                if (text.trim().isNotEmpty) {
                  final pages = _splitIntoPages(text);
                  chapters.addAll(pages);
                }
              }
            }
          } catch (e) {
            debugPrint('오류 발생: ${spineItem.IdRef}: $e');
          }
        }
      }
      
      if (chapters.isEmpty) {
        final htmlFiles = epubBook.Content?.Html;
        if (htmlFiles != null) {
          for (final entry in htmlFiles.entries) {
            final fileName = entry.key;
            final htmlContent = entry.value;

            try {
              final content = htmlContent.Content;
              if (content != null && content.isNotEmpty) {
                final text = _extractTextFromHtml(content);
                if (text.trim().isNotEmpty && text.length > 50) { // Skip very short content
                  final pages = _splitIntoPages(text);
                  chapters.addAll(pages);
                }
              }
            } catch (e,s) {
              debugPrint('오류 발생 $fileName: $e\n$s');
            }
          }
        }
      }
      
      if (chapters.isEmpty) {
        final cssFiles = epubBook.Content?.Css;
        if (cssFiles != null) {
          for (final entry in cssFiles.entries) {
            final cssContent = entry.value;
            final content = cssContent.Content;
            if (content != null && content.contains('content:')) {
              final text = content.replaceAll(RegExp(r'[{}]'), ' ').replaceAll(RegExp(r'\s+'), ' ');
              if (text.trim().isNotEmpty) {
                chapters.add(text);
              }
            }
          }
        }
      }
      
      if (chapters.isEmpty) {
        final images = epubBook.Content?.Images;
        if (images != null && images.isNotEmpty) {
          chapters.add('이 책은 주로 이미지로 구성되어 있습니다. ${images.length}개의 이미지가 포함되어 있습니다.');
        }
      }
      
    } catch (e, s) {
      debugPrint('Error extracting chapters: $e\n$s');
      chapters.add('책을 읽는 중 오류가 발생했습니다: $e');
    }

    if (chapters.isEmpty) {
      chapters.add('이 EPUB 파일에서 텍스트 내용을 추출할 수 없습니다. 파일 형식이 지원되지 않거나 파일이 손상되었을 수 있습니다.');
    }

    return chapters;
  }

  static String _extractTextFromHtml(String htmlContent) {
    if (htmlContent.isEmpty) return '';
    
    try {
      String text = htmlContent
          .replaceAll(RegExp(r'<script[^>]*>.*?</script>', dotAll: true, caseSensitive: false), '')
          .replaceAll(RegExp(r'<style[^>]*>.*?</style>', dotAll: true, caseSensitive: false), '')
          .replaceAll(RegExp(r'<!--.*?-->', dotAll: true), ''); // Remove comments
      
      text = text
          .replaceAll(RegExp(r'<br[^>]*>', caseSensitive: false), '\n')
          .replaceAll(RegExp(r'<p[^>]*>', caseSensitive: false), '\n\n')
          .replaceAll(RegExp(r'</p>', caseSensitive: false), '\n')
          .replaceAll(RegExp(r'<h[1-6][^>]*>', caseSensitive: false), '\n\n')
          .replaceAll(RegExp(r'</h[1-6]>', caseSensitive: false), '\n\n')
          .replaceAll(RegExp(r'<div[^>]*>', caseSensitive: false), '\n')
          .replaceAll(RegExp(r'</div>', caseSensitive: false), '\n');
      
      text = text.replaceAll(RegExp(r'<[^>]+>'), ' ');
      
      text = text
          .replaceAll('&nbsp;', ' ')
          .replaceAll('&amp;', '&')
          .replaceAll('&lt;', '<')
          .replaceAll('&gt;', '>')
          .replaceAll('&quot;', '"')
          .replaceAll('&#39;', "'")
          .replaceAll('&apos;', "'")
          .replaceAll('&mdash;', '—')
          .replaceAll('&ndash;', '–')
          .replaceAll('&hellip;', '…')
          .replaceAll('&lsquo;', ''')
          .replaceAll('&rsquo;', ''')
          .replaceAll('&ldquo;', '"')
          .replaceAll('&rdquo;', '"');
      
      text = text
          .replaceAll(RegExp(r'\n\s*\n\s*\n+'), '\n\n') // Multiple newlines to double
          .replaceAll(RegExp(r'[ \t]+'), ' ') // Multiple spaces to single
          .replaceAll(RegExp(r' *\n *'), '\n') // Clean space around newlines
          .trim();
      
      final lines = text.split('\n');
      final cleanLines = lines
          .where((line) => line.trim().length > 3 || line.trim().isEmpty)
          .toList();
      
      text = cleanLines.join('\n');
      
      text = text
          .replaceAll(RegExp(r'\n{3,}'), '\n\n') // Max 2 consecutive newlines
          .trim();
      
      return text;
    } catch (e) {
      return htmlContent
          .replaceAll(RegExp(r'<[^>]+>'), ' ')
          .replaceAll(RegExp(r'\s+'), ' ')
          .trim();
    }
  }

  static List<String> _splitIntoPages(String text, {int wordsPerPage = 300}) {
    if (text.trim().isEmpty) return [];
    
    try {
      final paragraphs = text.split(RegExp(r'\n\s*\n'));
      final pages = <String>[];
      
      String currentPage = '';
      int currentWordCount = 0;
      
      for (final paragraph in paragraphs) {
        final cleanParagraph = paragraph.trim();
        if (cleanParagraph.isEmpty) continue;
        
        final paragraphWords = cleanParagraph.split(RegExp(r'\s+'));
        final paragraphWordCount = paragraphWords.length;
        
        if (currentWordCount > 0 && currentWordCount + paragraphWordCount > wordsPerPage) {
          if (currentPage.trim().isNotEmpty) {
            pages.add(currentPage.trim());
          }
          currentPage = cleanParagraph;
          currentWordCount = paragraphWordCount;
        } else {
          if (currentPage.isNotEmpty) {
            currentPage += '\n\n' + cleanParagraph;
          } else {
            currentPage = cleanParagraph;
          }
          currentWordCount += paragraphWordCount;
        }
      }
      
      if (currentPage.trim().isNotEmpty) {
        pages.add(currentPage.trim());
      }
      
      if (pages.isEmpty) {
        final words = text.split(RegExp(r'\s+'));
        for (int i = 0; i < words.length; i += wordsPerPage) {
          final end = (i + wordsPerPage < words.length) ? i + wordsPerPage : words.length;
          final pageWords = words.sublist(i, end);
          final pageText = pageWords.join(' ').trim();
          
          if (pageText.isNotEmpty) {
            pages.add(pageText);
          }
        }
      }
      
      return pages.isEmpty ? [text] : pages;
      
    } catch (e) {
      return [text];
    }
  }

  static EpubBook? getCachedEpubBook(String bookId) {
    return _cache[bookId];
  }

  static void clearCache() {
    _cache.clear();
  }
}