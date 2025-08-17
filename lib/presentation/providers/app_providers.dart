import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/book.dart';
import '../../domain/entities/reading_settings.dart';
import 'app_state_notifier.dart';
import 'dependency_providers.dart';

final appStateProvider = StateNotifierProvider<AppStateNotifier, AppState>((ref) {
  return AppStateNotifier(
    ref.read(toggleFavoriteUseCaseProvider),
    ref.read(getFavoritesUseCaseProvider),
    ref.read(updateReadingSettingsUseCaseProvider),
  );
});

final appInitializationProvider = FutureProvider<void>((ref) async {
  final getBooks = ref.read(getBooksUseCaseProvider);
  final getFavorites = ref.read(getFavoritesUseCaseProvider);
  final getReadingSettings = ref.read(getReadingSettingsUseCaseProvider);

  final results = await Future.wait([
    getBooks(),
    getFavorites(),
    getReadingSettings(),
  ]);

  final books = results[0] as List<Book>;
  final favorites = results[1] as List<String>;
  final readingSettings = results[2] as ReadingSettings;
  ref.read(appStateProvider.notifier).updateBooks(books);
  ref.read(appStateProvider.notifier).updateFavorites(favorites);
  ref.read(appStateProvider.notifier).updateReadingSettings(readingSettings);
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

final readingSettingsProvider = Provider<ReadingSettings>((ref) {
  return ref.watch(appStateProvider).readingSettings;
});

final fontSizeProvider = Provider<double>((ref) {
  return ref.watch(appStateProvider).readingSettings.fontSize;
});

final fontFamilyProvider = Provider<String>((ref) {
  return ref.watch(appStateProvider).readingSettings.fontFamily;
});

final bookByIdProvider = Provider.family<Book?, String>((ref, id) {
  return ref.watch(appStateProvider.notifier).getBookById(id);
});

final isFavoriteProvider = Provider.family<bool, String>((ref, bookId) {
  return ref.watch(appStateProvider).isFavorite(bookId);
});

final toggleFavoriteProvider = Provider<Function(String)>((ref) {
  return (String bookId) async {
    final toggleFavorite = ref.read(toggleFavoriteUseCaseProvider);
    await toggleFavorite(bookId);
    
    final getFavorites = ref.read(getFavoritesUseCaseProvider);
    final newFavorites = await getFavorites();
    ref.read(appStateProvider.notifier).updateFavorites(newFavorites);
  };
});

final updateFontSizeProvider = Provider<Function(double)>((ref) {
  return (double fontSize) async {
    final currentSettings = ref.read(appStateProvider).readingSettings;
    final newSettings = currentSettings.copyWith(fontSize: fontSize);
    
    final updateReadingSettings = ref.read(updateReadingSettingsUseCaseProvider);
    await updateReadingSettings(newSettings);
    
    ref.read(appStateProvider.notifier).updateReadingSettings(newSettings);
  };
});

final updateFontFamilyProvider = Provider<Function(String)>((ref) {
  return (String fontFamily) async {
    final currentSettings = ref.read(appStateProvider).readingSettings;
    final newSettings = currentSettings.copyWith(fontFamily: fontFamily);
    
    final updateReadingSettings = ref.read(updateReadingSettingsUseCaseProvider);
    await updateReadingSettings(newSettings);
    
    ref.read(appStateProvider.notifier).updateReadingSettings(newSettings);
  };
});