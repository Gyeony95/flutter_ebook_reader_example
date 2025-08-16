import 'package:shared_preferences/shared_preferences.dart';
import '../models/reading_settings_model.dart';

abstract class LocalStorageDatasource {
  Future<List<String>> getFavorites();
  Future<void> saveFavorites(List<String> favorites);
  Future<ReadingSettingsModel> getReadingSettings();
  Future<void> saveReadingSettings(ReadingSettingsModel settings);
}

class LocalStorageDatasourceImpl implements LocalStorageDatasource {
  static const String _favoritesKey = 'favorites';
  static const String _fontSizeKey = 'font_size';
  static const String _fontFamilyKey = 'font_family';

  @override
  Future<List<String>> getFavorites() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getStringList(_favoritesKey) ?? [];
    } catch (e) {
      return [];
    }
  }

  @override
  Future<void> saveFavorites(List<String> favorites) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setStringList(_favoritesKey, favorites);
    } catch (e) {
      // Silently handle error
    }
  }

  @override
  Future<ReadingSettingsModel> getReadingSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final fontSize = prefs.getDouble(_fontSizeKey) ?? 16.0;
      final fontFamily = prefs.getString(_fontFamilyKey) ?? 'default';
      
      return ReadingSettingsModel(
        fontSize: fontSize,
        fontFamily: fontFamily,
      );
    } catch (e) {
      return const ReadingSettingsModel(
        fontSize: 16.0,
        fontFamily: 'default',
      );
    }
  }

  @override
  Future<void> saveReadingSettings(ReadingSettingsModel settings) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setDouble(_fontSizeKey, settings.fontSize);
      await prefs.setString(_fontFamilyKey, settings.fontFamily);
    } catch (e) {
      // Silently handle error
    }
  }
}