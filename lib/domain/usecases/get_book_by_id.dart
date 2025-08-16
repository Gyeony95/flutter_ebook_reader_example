import '../entities/book.dart';
import '../repositories/book_repository.dart';

class GetBookById {
  final BookRepository repository;

  GetBookById(this.repository);

  Future<Book?> call(String id) {
    return repository.getBookById(id);
  }
}