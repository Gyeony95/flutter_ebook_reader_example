import 'package:epubx/epubx.dart';
import 'package:flutter/services.dart';
import '../models/book_model.dart';

abstract class EpubDatasource {
  Future<List<BookModel>> loadEpubBooks();
}

class EpubDatasourceImpl implements EpubDatasource {
  @override
  Future<List<BookModel>> loadEpubBooks() async {
    try {
      final epubPaths = [
        'assets/daedonggangeun sogsaginda - gimdongin.epub',
        'assets/noingwa bada - eoniseuteu hemingwei.epub',
      ];

      final List<BookModel> books = [];

      for (final assetPath in epubPaths) {
        try {
          final bytes = await rootBundle.load(assetPath);
          final epubBook = await EpubReader.readBook(bytes.buffer.asUint8List());

          String title = epubBook.Title ?? 'Unknown Title';
          String author = epubBook.Author ?? 'Unknown Author';
          
          final fileName = assetPath.split('/').last.replaceAll('.epub', '');
          final parts = fileName.split(' - ');
          if (parts.length >= 2) {
            title = parts[0].trim();
            author = parts[1].trim();
          }

          final List<String> content = [];
          for (final chapter in epubBook.Chapters ?? <EpubChapter>[]) {
            if (chapter.HtmlContent?.isNotEmpty == true) {
              final text = _extractTextFromHtml(chapter.HtmlContent!);
              if (text.isNotEmpty) {
                final pages = _splitIntoPages(text);
                content.addAll(pages);
              }
            }
          }

          if (content.isEmpty) {
            content.add('내용을 불러올 수 없습니다.');
          }

          final book = BookModel(
            id: fileName,
            title: title,
            author: author,
            coverImagePath: assetPath,
            publishYear: 2024,
            content: content,
          );

          books.add(book);
        } catch (e) {
          continue;
        }
      }

      return books;
    } catch (e) {
      return [];
    }
  }

  String _extractTextFromHtml(String html) {
    return html
        .replaceAll(RegExp(r'<[^>]*>'), '')
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim();
  }

  List<String> _splitIntoPages(String text) {
    const int charactersPerPage = 1000;
    final List<String> pages = [];
    
    for (int i = 0; i < text.length; i += charactersPerPage) {
      final end = (i + charactersPerPage < text.length) 
          ? i + charactersPerPage 
          : text.length;
      pages.add(text.substring(i, end));
    }
    
    return pages;
  }
}