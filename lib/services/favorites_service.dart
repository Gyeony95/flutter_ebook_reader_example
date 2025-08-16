import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class FavoritesService {
  static const String _favoritesKey = 'ebook-favorites';

  static Future<List<String>> loadFavorites() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? favoritesJson = prefs.getString(_favoritesKey);
      
      if (favoritesJson != null) {
        final List<dynamic> favoritesList = json.decode(favoritesJson);
        return favoritesList.cast<String>();
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  static Future<void> saveFavorites(List<String> favorites) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String favoritesJson = json.encode(favorites);
      await prefs.setString(_favoritesKey, favoritesJson);
    } catch (e) {
      // Handle error silently
    }
  }

  static Future<void> addFavorite(String bookId) async {
    final favorites = await loadFavorites();
    if (!favorites.contains(bookId)) {
      favorites.add(bookId);
      await saveFavorites(favorites);
    }
  }

  static Future<void> removeFavorite(String bookId) async {
    final favorites = await loadFavorites();
    favorites.remove(bookId);
    await saveFavorites(favorites);
  }

  static Future<bool> isFavorite(String bookId) async {
    final favorites = await loadFavorites();
    return favorites.contains(bookId);
  }
}