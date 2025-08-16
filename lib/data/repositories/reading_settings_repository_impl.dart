import '../../domain/entities/reading_settings.dart';
import '../../domain/repositories/reading_settings_repository.dart';
import '../datasources/local_storage_datasource.dart';
import '../models/reading_settings_model.dart';

class ReadingSettingsRepositoryImpl implements ReadingSettingsRepository {
  final LocalStorageDatasource localStorageDatasource;

  ReadingSettingsRepositoryImpl(this.localStorageDatasource);

  @override
  Future<ReadingSettings> getReadingSettings() async {
    final settingsModel = await localStorageDatasource.getReadingSettings();
    return settingsModel;
  }

  @override
  Future<void> saveReadingSettings(ReadingSettings settings) async {
    final settingsModel = ReadingSettingsModel.fromEntity(settings);
    await localStorageDatasource.saveReadingSettings(settingsModel);
  }
}