class ReadingSettings {
  final double fontSize;
  final String fontFamily;

  const ReadingSettings({
    required this.fontSize,
    required this.fontFamily,
  });

  ReadingSettings copyWith({
    double? fontSize,
    String? fontFamily,
  }) {
    return ReadingSettings(
      fontSize: fontSize ?? this.fontSize,
      fontFamily: fontFamily ?? this.fontFamily,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ReadingSettings &&
        other.fontSize == fontSize &&
        other.fontFamily == fontFamily;
  }

  @override
  int get hashCode => Object.hash(fontSize, fontFamily);
}