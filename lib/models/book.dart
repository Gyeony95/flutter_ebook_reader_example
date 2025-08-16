class Book {
  final String id;
  final String title;
  final String author;
  final String description;
  final String coverImage;
  final List<String> content;
  final int publishYear;
  final String? language;
  final String? publisher;
  final bool isEpub;

  const Book({
    required this.id,
    required this.title,
    required this.author,
    required this.description,
    required this.coverImage,
    required this.content,
    required this.publishYear,
    this.language,
    this.publisher,
    this.isEpub = false,
  });

  Book copyWith({
    String? id,
    String? title,
    String? author,
    String? description,
    String? coverImage,
    List<String>? content,
    int? publishYear,
    String? language,
    String? publisher,
    bool? isEpub,
  }) {
    return Book(
      id: id ?? this.id,
      title: title ?? this.title,
      author: author ?? this.author,
      description: description ?? this.description,
      coverImage: coverImage ?? this.coverImage,
      content: content ?? this.content,
      publishYear: publishYear ?? this.publishYear,
      language: language ?? this.language,
      publisher: publisher ?? this.publisher,
      isEpub: isEpub ?? this.isEpub,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'author': author,
      'description': description,
      'coverImage': coverImage,
      'content': content,
      'publishYear': publishYear,
      'language': language,
      'publisher': publisher,
      'isEpub': isEpub,
    };
  }

  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(
      id: json['id'] as String,
      title: json['title'] as String,
      author: json['author'] as String,
      description: json['description'] as String,
      coverImage: json['coverImage'] as String,
      content: List<String>.from(json['content'] as List),
      publishYear: json['publishYear'] as int,
      language: json['language'] as String?,
      publisher: json['publisher'] as String?,
      isEpub: json['isEpub'] as bool? ?? false,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! Book) return false;
    return id == other.id &&
        title == other.title &&
        author == other.author &&
        description == other.description &&
        coverImage == other.coverImage &&
        _listEquals(content, other.content) &&
        publishYear == other.publishYear &&
        language == other.language &&
        publisher == other.publisher &&
        isEpub == other.isEpub;
  }

  @override
  int get hashCode => Object.hash(
        id,
        title,
        author,
        description,
        coverImage,
        Object.hashAll(content),
        publishYear,
        language,
        publisher,
        isEpub,
      );

  @override
  String toString() {
    return 'Book(id: $id, title: $title, author: $author, publishYear: $publishYear)';
  }
}

bool _listEquals<T>(List<T>? a, List<T>? b) {
  if (a == null) return b == null;
  if (b == null || a.length != b.length) return false;
  for (int index = 0; index < a.length; index += 1) {
    if (a[index] != b[index]) return false;
  }
  return true;
}