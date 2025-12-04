import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:union_shop/views/personalisation_screen.dart';

void main() {
  Future<void> pumpPersonalisationScreen(WidgetTester tester, {double width = 400}) async {
		final router = GoRouter(
			routes: [
				GoRoute(
					path: '/',
					builder: (context, state) => MediaQuery(
						data: MediaQueryData(size: Size(width, 800)),
						child: const PersonalisationScreen(),
					),
				),
				GoRoute(
					path: '/cart',
					builder: (context, state) => const Scaffold(body: Center(child: Text('Your Cart'))),
				),
			],
		);

		await tester.pumpWidget(
			MaterialApp.router(
				routerConfig: router,
			),
		);
    await tester.pumpAndSettle();
  }

  testWidgets('Personalisation default shows one line and correct add price', (tester) async {
    await pumpPersonalisationScreen(tester);

    expect(find.text('Number of lines: '), findsOneWidget);
    expect(find.text('Line 1'), findsOneWidget);
    expect(find.text('Line 2'), findsNothing);

    // Default price for one line, quantity 1 => (1 + 2*1) * 1 = 3.0
    expect(find.text('ADD £3.0 TO CART'), findsOneWidget);
  });

  testWidgets('Selecting Four lines shows four entry fields', (tester) async {
    await pumpPersonalisationScreen(tester);

    // Open the dropdown and select 'Four'
    await tester.ensureVisible(find.byType(DropdownButtonHideUnderline).first);
    await tester.pumpAndSettle();
    await tester.tap(find.byType(DropdownButtonHideUnderline).first);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Four').last);
    await tester.pumpAndSettle();

    expect(find.text('Line 1'), findsOneWidget);
    expect(find.text('Line 2'), findsOneWidget);
    expect(find.text('Line 3'), findsOneWidget);
    expect(find.text('Line 4'), findsOneWidget);

    // For four lines, quantity 1 => (1 + 2*4) * 1 = 9.0
    expect(find.text('ADD £9.0 TO CART'), findsOneWidget);
  });

  testWidgets('Quantity controls update the displayed total', (tester) async {
    await pumpPersonalisationScreen(tester);

    // Tap the add icon to increase quantity
    await tester.ensureVisible(find.byIcon(Icons.add).first);
    await tester.pumpAndSettle();
    await tester.tap(find.byIcon(Icons.add).first);
    await tester.pumpAndSettle();

    // Quantity should now show 2 and price double
    expect(find.text('2'), findsOneWidget);
    // For one line, quantity 2 => (1 + 2*1) * 2 = 6.0
    expect(find.text('ADD £6.0 TO CART'), findsOneWidget);
  });

	testWidgets('ProductScreen renders cart screen', (WidgetTester tester) async {
		await pumpPersonalisationScreen(tester);

    // Tap the add to cart button
    // Ensure the add button is visible (may be off-screen in tests) then tap
    final addButton = find.widgetWithText(ElevatedButton, 'ADD £3.0 TO CART');
    await tester.ensureVisible(addButton);
    await tester.pumpAndSettle();
    await tester.tap(addButton);
    await tester.pumpAndSettle();

    // Verify cart screen is shown with the added item
    expect(find.text('Your Cart'), findsOneWidget);
  });
}
