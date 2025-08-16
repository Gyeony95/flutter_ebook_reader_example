import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../presentation/screens/book_list_screen.dart';
import '../presentation/screens/book_reader_screen.dart';

class AppRouter {
  static const String home = '/';
  static const String bookReader = '/book/:id';

  static GoRouter createRouter() {
    return GoRouter(
      initialLocation: home,
      routes: [
        GoRoute(
          path: home,
          name: 'home',
          builder: (context, state) => const BookListScreen(),
        ),
        GoRoute(
          path: bookReader,
          name: 'book-reader',
          builder: (context, state) {
            final bookId = state.pathParameters['id']!;
            return BookReaderScreen(bookId: bookId);
          },
        ),
      ],
      errorBuilder: (context, state) => Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.error_outline,
                size: 64,
                color: Colors.red,
              ),
              const SizedBox(height: 16),
              Text(
                'Page not found: ${state.matchedLocation}',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => context.go(home),
                child: const Text('Go Home'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// GoRouter 확장 메서드들
extension AppRouterExtension on GoRouter {
  void goToBookReader(String bookId) {
    go('/book/$bookId');
  }

  void goToHome() {
    go('/');
  }
}