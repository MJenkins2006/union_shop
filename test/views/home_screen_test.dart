import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:union_shop/views/home_screen.dart';

void main() {
  Future<void> pumpHomeScreen(WidgetTester tester,
      {double width = 400}) async {
    const widget = MaterialApp(home: HomeScreen());

    await tester.pumpWidget(MediaQuery(
      data: MediaQueryData(size: Size(width, 400)),
      child: widget,
    ));
    await tester.pumpAndSettle();
  }
  
  testWidgets('Header shows', (WidgetTester tester) async {
    await pumpHomeScreen(tester, width: 400);

    // Header banner (mobile header expected in test environment)
    expect(
      find.text(
          'BIG SALE! OUR ESSENTIAL RANGE HAS DROPPED IN PRICE! OVER 20% OFF!'),
      findsOneWidget,
    );
  });

  testWidgets('Hero carousel shows slides and buttons', (WidgetTester tester) async {
    await pumpHomeScreen(tester, width: 400);

    // Initial slide
    expect(find.text('BROWSE COLLECTION'), findsOneWidget);

    // Swipe to slide 2 and verify 'LEARN MORE'
    await tester.fling(find.byType(PageView), const Offset(-400, 0), 1000);
    await tester.pumpAndSettle();
    expect(find.text('LEARN MORE'), findsOneWidget);

    // Swipe to slide 3 and verify 'BROWSE COLLECTIONS'
    await tester.fling(find.byType(PageView), const Offset(-400, 0), 1000);
    await tester.pumpAndSettle();
    expect(find.text('BROWSE COLLECTIONS'), findsOneWidget);
  });

  testWidgets('Product sections display expected titles', (WidgetTester tester) async {
    await pumpHomeScreen(tester, width: 400);

    expect(find.text('SALES'), findsOneWidget);
    expect(find.text('CLOTHES'), findsOneWidget);
    expect(find.text('CARDS'), findsOneWidget);
  });

  testWidgets('Product items show expected names', (WidgetTester tester) async {
    await pumpHomeScreen(tester, width: 400);

    expect(find.text('ZIP-HOODIE'), findsOneWidget);
    expect(find.text('T-SHIRT'), findsOneWidget);
    expect(find.text('POSTCARD'), findsOneWidget);
    expect(find.text('HOODIES'), findsOneWidget);
  });

  testWidgets('Footer shows', (WidgetTester tester) async {
    await pumpHomeScreen(tester, width: 400);

    expect(find.text('© 2025, upsu-store Powered by Shopify'), findsOneWidget);
  });
}
