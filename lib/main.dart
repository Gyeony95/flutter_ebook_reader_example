import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'router/app_router.dart';
import 'theme/app_theme.dart';

void main() {
  runApp(
    const ProviderScope(
      child: EBookReaderApp(),
    ),
  );
}

class EBookReaderApp extends StatelessWidget {
  const EBookReaderApp({super.key});

  @override
  Widget build(BuildContext context) {
    final router = AppRouter.createRouter();
    
    return MaterialApp.router(
      title: 'eBook Reader',
      theme: AppTheme.lightTheme,
      routerConfig: router,
      debugShowCheckedModeBanner: false,
    );
  }
}
