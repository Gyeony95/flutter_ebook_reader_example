import '../entities/reading_settings.dart';
import '../repositories/reading_settings_repository.dart';

class GetReadingSettings {
  final ReadingSettingsRepository repository;

  GetReadingSettings(this.repository);

  Future<ReadingSettings> call() {
    return repository.getReadingSettings();
  }
}