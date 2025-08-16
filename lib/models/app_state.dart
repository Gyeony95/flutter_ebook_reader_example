import 'package:freezed_annotation/freezed_annotation.dart';
import 'book.dart';

class AppState {
  final List<Book> books;
  final List<String> favorites;
  final String searchQuery;
  final Book? selectedBook;
  final int currentPage;
  final double fontSize;
  final String fontFamily;

  const AppState({
    required this.books,
    required this.favorites,
    this.searchQuery = '',
    this.selectedBook,
    this.currentPage = 0,
    this.fontSize = 16.0,
    this.fontFamily = 'default',
  });

  AppState copyWith({
    List<Book>? books,
    List<String>? favorites,
    String? searchQuery,
    Book? selectedBook,
    int? currentPage,
    double? fontSize,
    String? fontFamily,
  }) {
    return AppState(
      books: books ?? this.books,
      favorites: favorites ?? this.favorites,
      searchQuery: searchQuery ?? this.searchQuery,
      selectedBook: selectedBook ?? this.selectedBook,
      currentPage: currentPage ?? this.currentPage,
      fontSize: fontSize ?? this.fontSize,
      fontFamily: fontFamily ?? this.fontFamily,
    );
  }

  AppState clearSelectedBook() {
    return AppState(
      books: books,
      favorites: favorites,
      searchQuery: searchQuery,
      selectedBook: null,
      currentPage: 0,
      fontSize: fontSize,
      fontFamily: fontFamily,
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

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! AppState) return false;
    return _listEquals(books, other.books) &&
        _listEquals(favorites, other.favorites) &&
        searchQuery == other.searchQuery &&
        selectedBook == other.selectedBook &&
        currentPage == other.currentPage &&
        fontSize == other.fontSize &&
        fontFamily == other.fontFamily;
  }

  @override
  int get hashCode => Object.hash(
        Object.hashAll(books),
        Object.hashAll(favorites),
        searchQuery,
        selectedBook,
        currentPage,
        fontSize,
        fontFamily,
      );

  @override
  String toString() {
    return 'AppState(books: ${books.length}, favorites: ${favorites.length}, searchQuery: $searchQuery, selectedBook: ${selectedBook?.title}, currentPage: $currentPage, fontSize: $fontSize, fontFamily: $fontFamily)';
  }
}

bool _listEquals<T>(List<T>? a, List<T>? b) {
  if (a == null) return b == null;
  if (b == null || a.length != b.length) return false;
  for (int index = 0; index < a.length; index += 1) {
    if (a[index] != b[index]) return false;
  }
  return true;
}