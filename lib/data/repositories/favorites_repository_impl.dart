import '../../domain/repositories/favorites_repository.dart';
import '../datasources/local_storage_datasource.dart';

class FavoritesRepositoryImpl implements FavoritesRepository {
  final LocalStorageDatasource localStorageDatasource;

  FavoritesRepositoryImpl(this.localStorageDatasource);

  @override
  Future<List<String>> getFavorites() async {
    return await localStorageDatasource.getFavorites();
  }

  @override
  Future<void> addFavorite(String bookId) async {
    final favorites = await getFavorites();
    if (!favorites.contains(bookId)) {
      favorites.add(bookId);
      await localStorageDatasource.saveFavorites(favorites);
    }
  }

  @override
  Future<void> removeFavorite(String bookId) async {
    final favorites = await getFavorites();
    favorites.remove(bookId);
    await localStorageDatasource.saveFavorites(favorites);
  }

  @override
  Future<bool> isFavorite(String bookId) async {
    final favorites = await getFavorites();
    return favorites.contains(bookId);
  }
}