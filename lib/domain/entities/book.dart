class Book {
  final String id;
  final String title;
  final String author;
  final String coverImagePath;
  final int publishYear;
  final List<String> content;

  const Book({
    required this.id,
    required this.title,
    required this.author,
    required this.coverImagePath,
    required this.publishYear,
    required this.content,
  });

  String get coverImage => coverImagePath;
  bool get isEpub => coverImagePath.endsWith('.epub');

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Book && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}