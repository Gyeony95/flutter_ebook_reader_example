import '../repositories/favorites_repository.dart';

class ToggleFavorite {
  final FavoritesRepository repository;

  ToggleFavorite(this.repository);

  Future<void> call(String bookId) async {
    final isFavorite = await repository.isFavorite(bookId);
    if (isFavorite) {
      await repository.removeFavorite(bookId);
    } else {
      await repository.addFavorite(bookId);
    }
  }
}