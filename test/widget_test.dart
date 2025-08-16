// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:ebook_reader_example/main.dart';

void main() {
  testWidgets('eBook Reader app smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(
      const ProviderScope(
        child: EBookReaderApp(),
      ),
    );
    
    // Pump a few frames to let the initial layout complete
    await tester.pump();
    await tester.pump();

    // Verify that the app shows the library screen
    expect(find.text('내 서재'), findsOneWidget);
    
    // The tab texts include counts, so we use textContaining
    expect(find.textContaining('전체'), findsOneWidget);
    expect(find.textContaining('즐겨찾기'), findsOneWidget);
  });
}
