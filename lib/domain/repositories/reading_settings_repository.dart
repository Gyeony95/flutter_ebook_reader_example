import '../entities/reading_settings.dart';

abstract class ReadingSettingsRepository {
  Future<ReadingSettings> getReadingSettings();
  Future<void> saveReadingSettings(ReadingSettings settings);
}