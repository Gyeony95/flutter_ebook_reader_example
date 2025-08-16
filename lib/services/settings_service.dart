import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsService {
  static const String _fontSizeKey = 'font_size';
  static const String _fontFamilyKey = 'font_family';

  static Future<double> loadFontSize() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getDouble(_fontSizeKey) ?? 16.0;
    } catch (e) {
      return 16.0;
    }
  }

  static Future<String> loadFontFamily() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString(_fontFamilyKey) ?? 'default';
    } catch (e) {
      return 'default';
    }
  }

  static Future<void> saveFontSize(double fontSize) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setDouble(_fontSizeKey, fontSize);
    } catch (e, s) {
      debugPrint('폰트 저장 에러: $e, $s');
    }
  }

  static Future<void> saveFontFamily(String fontFamily) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_fontFamilyKey, fontFamily);
    } catch (e, s) {
      debugPrint('폰트 패밀리 저장 에러: $e, $s');
    }
  }
}
