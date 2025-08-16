import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'router/app_router.dart';
import 'theme/app_theme.dart';
import 'presentation/providers/app_providers.dart';

void main() {
  runApp(
    const ProviderScope(
      child: EBookReaderApp(),
    ),
  );
}

class EBookReaderApp extends ConsumerWidget {
  const EBookReaderApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = AppRouter.createRouter();
    
    return MaterialApp.router(
      title: 'eBook Reader',
      theme: AppTheme.lightTheme,
      routerConfig: router,
      debugShowCheckedModeBanner: false,
      builder: (context, child) {
        return FutureBuilder(
          future: ref.read(appInitializationProvider.future),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const MaterialApp(
                home: Scaffold(
                  body: Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
              );
            }
            return child ?? Container();
          },
        );
      },
    );
  }
}
