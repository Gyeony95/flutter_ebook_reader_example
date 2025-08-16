import 'package:ebook_reader_example/services/epub_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/app_state.dart';
import '../models/book.dart';
import '../services/favorites_service.dart';
import '../services/settings_service.dart';

class AppStateNotifier extends StateNotifier<AppState> {
  AppStateNotifier() : super(const AppState(books: [], favorites: [])) {
    _initializeState();
  }

  Future<void> _initializeState() async {
    try {
      final futures = await Future.wait([
        FavoritesService.loadFavorites(),
        EpubService.loadEpubBooks(),
        SettingsService.loadFontSize(),
        SettingsService.loadFontFamily(),
      ]);
      
      final favorites = futures[0] as List<String>;
      final books = futures[1] as List<Book>;
      final fontSize = futures[2] as double;
      final fontFamily = futures[3] as String;
      
      state = AppState(
        books: books,
        favorites: favorites,
        fontSize: fontSize,
        fontFamily: fontFamily,
      );
    } catch (e) {
      state = const AppState(
        books: [],
        favorites: [],
      );
    }
  }

  void updateSearchQuery(String query) {
    state = state.copyWith(searchQuery: query);
  }

  void selectBook(Book book) {
    state = state.copyWith(selectedBook: book, currentPage: 0);
  }

  void clearSelectedBook() {
    state = state.clearSelectedBook();
  }

  void setCurrentPage(int page) {
    state = state.copyWith(currentPage: page);
  }

  Future<void> toggleFavorite(String bookId) async {
    final newFavorites = List<String>.from(state.favorites);
    
    if (newFavorites.contains(bookId)) {
      newFavorites.remove(bookId);
      await FavoritesService.removeFavorite(bookId);
    } else {
      newFavorites.add(bookId);
      await FavoritesService.addFavorite(bookId);
    }
    
    state = state.copyWith(favorites: newFavorites);
  }

  Future<void> setFontSize(double fontSize) async {
    state = state.copyWith(fontSize: fontSize);
    await SettingsService.saveFontSize(fontSize);
  }

  Future<void> setFontFamily(String fontFamily) async {
    state = state.copyWith(fontFamily: fontFamily);
    await SettingsService.saveFontFamily(fontFamily);
  }

  Book? getBookById(String id) {
    try {
      return state.books.firstWhere((book) => book.id == id);
    } catch (e) {
      return null;
    }
  }
}

final appStateProvider = StateNotifierProvider<AppStateNotifier, AppState>((ref) {
  return AppStateNotifier();
});

final booksProvider = Provider<List<Book>>((ref) {
  return ref.watch(appStateProvider).books;
});

final favoritesProvider = Provider<List<String>>((ref) {
  return ref.watch(appStateProvider).favorites;
});

final filteredBooksProvider = Provider<List<Book>>((ref) {
  return ref.watch(appStateProvider).filteredBooks;
});

final favoriteBooksProvider = Provider<List<Book>>((ref) {
  return ref.watch(appStateProvider).favoriteBooks;
});

final selectedBookProvider = Provider<Book?>((ref) {
  return ref.watch(appStateProvider).selectedBook;
});

final currentPageProvider = Provider<int>((ref) {
  return ref.watch(appStateProvider).currentPage;
});

final searchQueryProvider = Provider<String>((ref) {
  return ref.watch(appStateProvider).searchQuery;
});

// Provider for getting a book by ID
final bookByIdProvider = Provider.family<Book?, String>((ref, id) {
  return ref.watch(appStateProvider.notifier).getBookById(id);
});

// Provider for checking if a book is favorite
final isFavoriteProvider = Provider.family<bool, String>((ref, bookId) {
  return ref.watch(appStateProvider).isFavorite(bookId);
});

// Provider for font settings
final fontSizeProvider = Provider<double>((ref) {
  return ref.watch(appStateProvider).fontSize;
});

final fontFamilyProvider = Provider<String>((ref) {
  return ref.watch(appStateProvider).fontFamily;
});