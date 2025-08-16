import '../entities/reading_settings.dart';
import '../repositories/reading_settings_repository.dart';

class UpdateReadingSettings {
  final ReadingSettingsRepository repository;

  UpdateReadingSettings(this.repository);

  Future<void> call(ReadingSettings settings) {
    return repository.saveReadingSettings(settings);
  }
}