import '../repositories/favorites_repository.dart';

class GetFavorites {
  final FavoritesRepository repository;

  GetFavorites(this.repository);

  Future<List<String>> call() {
    return repository.getFavorites();
  }
}