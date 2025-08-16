abstract class FavoritesRepository {
  Future<List<String>> getFavorites();
  Future<void> addFavorite(String bookId);
  Future<void> removeFavorite(String bookId);
  Future<bool> isFavorite(String bookId);
}