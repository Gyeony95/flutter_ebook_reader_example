import 'dart:typed_data';
import 'package:image/image.dart' as img;

class Book {
  final String id;
  final String title;
  final String author;
  final img.Image? coverImage;
  final int publishYear;
  final List<String> content;

  const Book({
    required this.id,
    required this.title,
    required this.author,
    required this.coverImage,
    required this.publishYear,
    required this.content,
  });

  Uint8List? get coverImageBytes => coverImage != null
      ? Uint8List.fromList(img.encodePng(coverImage!))
      : null;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Book && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
