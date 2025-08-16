import '../../domain/entities/reading_settings.dart';

class ReadingSettingsModel extends ReadingSettings {
  const ReadingSettingsModel({
    required super.fontSize,
    required super.fontFamily,
  });

  factory ReadingSettingsModel.fromJson(Map<String, dynamic> json) {
    return ReadingSettingsModel(
      fontSize: json['fontSize'] as double,
      fontFamily: json['fontFamily'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'fontSize': fontSize,
      'fontFamily': fontFamily,
    };
  }

  factory ReadingSettingsModel.fromEntity(ReadingSettings settings) {
    return ReadingSettingsModel(
      fontSize: settings.fontSize,
      fontFamily: settings.fontFamily,
    );
  }
}