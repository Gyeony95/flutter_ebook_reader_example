import '../../domain/entities/book.dart';
import '../../domain/repositories/book_repository.dart';
import '../datasources/epub_datasource.dart';

class BookRepositoryImpl implements BookRepository {
  final EpubDatasource epubDatasource;

  BookRepositoryImpl(this.epubDatasource);

  @override
  Future<List<Book>> getBooks() async {
    final bookModels = await epubDatasource.loadEpubBooks();
    return bookModels;
  }

  @override
  Future<Book?> getBookById(String id) async {
    final books = await getBooks();
    try {
      return books.firstWhere((book) => book.id == id);
    } catch (e) {
      return null;
    }
  }
}