import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/book.dart';
import '../../domain/entities/reading_settings.dart';
import '../../domain/usecases/toggle_favorite.dart';
import '../../domain/usecases/get_favorites.dart';
import '../../domain/usecases/update_reading_settings.dart';

class AppState {
  final List<Book> books;
  final List<String> favorites;
  final String searchQuery;
  final Book? selectedBook;
  final int currentPage;
  final ReadingSettings readingSettings;

  const AppState({
    required this.books,
    required this.favorites,
    this.searchQuery = '',
    this.selectedBook,
    this.currentPage = 0,
    required this.readingSettings,
  });

  AppState copyWith({
    List<Book>? books,
    List<String>? favorites,
    String? searchQuery,
    Book? selectedBook,
    int? currentPage,
    ReadingSettings? readingSettings,
  }) {
    return AppState(
      books: books ?? this.books,
      favorites: favorites ?? this.favorites,
      searchQuery: searchQuery ?? this.searchQuery,
      selectedBook: selectedBook ?? this.selectedBook,
      currentPage: currentPage ?? this.currentPage,
      readingSettings: readingSettings ?? this.readingSettings,
    );
  }

  AppState clearSelectedBook() {
    return AppState(
      books: books,
      favorites: favorites,
      searchQuery: searchQuery,
      selectedBook: null,
      currentPage: 0,
      readingSettings: readingSettings,
    );
  }

  List<Book> get filteredBooks {
    if (searchQuery.isEmpty) return books;
    final query = searchQuery.toLowerCase();
    return books.where((book) {
      return book.title.toLowerCase().contains(query) ||
          book.author.toLowerCase().contains(query);
    }).toList();
  }

  List<Book> get favoriteBooks {
    return filteredBooks.where((book) => favorites.contains(book.id)).toList();
  }

  bool isFavorite(String bookId) {
    return favorites.contains(bookId);
  }
}

class AppStateNotifier extends StateNotifier<AppState> {
  final ToggleFavorite _toggleFavorite;
  final GetFavorites _getFavorites;
  final UpdateReadingSettings _updateReadingSettings;

  AppStateNotifier(
    this._toggleFavorite,
    this._getFavorites,
    this._updateReadingSettings,
  ) : super(AppState(
    books: const [],
    favorites: const [],
    readingSettings: const ReadingSettings(fontSize: 16.0, fontFamily: 'default'),
  ));

  void updateBooks(List<Book> books) {
    state = state.copyWith(books: books);
  }

  void updateFavorites(List<String> favorites) {
    state = state.copyWith(favorites: favorites);
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

  void updateReadingSettings(ReadingSettings settings) {
    state = state.copyWith(readingSettings: settings);
  }

  Future<void> setFontSize(double fontSize) async {
    final newSettings = state.readingSettings.copyWith(fontSize: fontSize);
    state = state.copyWith(readingSettings: newSettings);
    await _updateReadingSettings(newSettings);
  }

  Future<void> setFontFamily(String fontFamily) async {
    final newSettings = state.readingSettings.copyWith(fontFamily: fontFamily);
    state = state.copyWith(readingSettings: newSettings);
    await _updateReadingSettings(newSettings);
  }

  Future<void> toggleFavorite(String bookId) async {
    await _toggleFavorite(bookId);
    final newFavorites = await _getFavorites();
    state = state.copyWith(favorites: newFavorites);
  }

  Book? getBookById(String id) {
    try {
      return state.books.firstWhere((book) => book.id == id);
    } catch (e) {
      return null;
    }
  }
}