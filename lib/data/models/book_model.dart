import 'dart:typed_data';
import '../../domain/entities/book.dart';
import 'package:image/image.dart' as img;

class BookModel extends Book {
  const BookModel({
    required super.id,
    required super.title,
    required super.author,
    required super.coverImage,
    required super.publishYear,
    required super.content,
  });

  factory BookModel.fromJson(Map<String, dynamic> json) {
    return BookModel(
      id: json['id'] as String,
      title: json['title'] as String,
      author: json['author'] as String,
      coverImage: json['coverImage'] as img.Image,
      publishYear: json['publishYear'] as int,
      content: List<String>.from(json['content'] as List),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'author': author,
      'coverImage': coverImage,
      'publishYear': publishYear,
      'content': content,
    };
  }

  factory BookModel.fromEntity(Book book) {
    return BookModel(
      id: book.id,
      title: book.title,
      author: book.author,
      coverImage: book.coverImage,
      publishYear: book.publishYear,
      content: book.content,
    );
  }
}