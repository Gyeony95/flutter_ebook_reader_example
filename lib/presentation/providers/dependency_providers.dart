import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/datasources/epub_datasource.dart';
import '../../data/datasources/local_storage_datasource.dart';
import '../../data/repositories/book_repository_impl.dart';
import '../../data/repositories/favorites_repository_impl.dart';
import '../../data/repositories/reading_settings_repository_impl.dart';
import '../../domain/repositories/book_repository.dart';
import '../../domain/repositories/favorites_repository.dart';
import '../../domain/repositories/reading_settings_repository.dart';
import '../../domain/usecases/get_books.dart';
import '../../domain/usecases/get_book_by_id.dart';
import '../../domain/usecases/get_favorites.dart';
import '../../domain/usecases/toggle_favorite.dart';
import '../../domain/usecases/get_reading_settings.dart';
import '../../domain/usecases/update_reading_settings.dart';

final epubDatasourceProvider = Provider<EpubDatasource>((ref) {
  return EpubDatasourceImpl();
});

final localStorageDatasourceProvider = Provider<LocalStorageDatasource>((ref) {
  return LocalStorageDatasourceImpl();
});

final bookRepositoryProvider = Provider<BookRepository>((ref) {
  return BookRepositoryImpl(ref.read(epubDatasourceProvider));
});

final favoritesRepositoryProvider = Provider<FavoritesRepository>((ref) {
  return FavoritesRepositoryImpl(ref.read(localStorageDatasourceProvider));
});

final readingSettingsRepositoryProvider = Provider<ReadingSettingsRepository>((ref) {
  return ReadingSettingsRepositoryImpl(ref.read(localStorageDatasourceProvider));
});

final getBooksUseCaseProvider = Provider<GetBooks>((ref) {
  return GetBooks(ref.read(bookRepositoryProvider));
});

final getBookByIdUseCaseProvider = Provider<GetBookById>((ref) {
  return GetBookById(ref.read(bookRepositoryProvider));
});

final getFavoritesUseCaseProvider = Provider<GetFavorites>((ref) {
  return GetFavorites(ref.read(favoritesRepositoryProvider));
});

final toggleFavoriteUseCaseProvider = Provider<ToggleFavorite>((ref) {
  return ToggleFavorite(ref.read(favoritesRepositoryProvider));
});

final getReadingSettingsUseCaseProvider = Provider<GetReadingSettings>((ref) {
  return GetReadingSettings(ref.read(readingSettingsRepositoryProvider));
});

final updateReadingSettingsUseCaseProvider = Provider<UpdateReadingSettings>((ref) {
  return UpdateReadingSettings(ref.read(readingSettingsRepositoryProvider));
});