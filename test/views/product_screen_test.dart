import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:union_shop/views/product_screen.dart';
import 'package:union_shop/models/cart_model.dart';

void main() {
  Future<void> pumpProductScreen(WidgetTester tester, {double width = 400}) async {
		// Provide a minimal GoRouter so ProductScreen can call GoRouter navigation
		final router = GoRouter(
			routes: [
				GoRoute(
					path: '/',
					builder: (context, state) => MediaQuery(
						data: MediaQueryData(size: Size(width, 800)),
						child: const ProductScreen(collectionId: 'SALES', productId: 'ZIP-HOODIE'),
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

	testWidgets('ProductScreen renders product details and controls', (WidgetTester tester) async {
		await pumpProductScreen(tester);

		// Product title and description
		expect(find.text('ZIP-HOODIE'), findsOneWidget);
		expect(find.textContaining('cozy zip-up hoodie', findRichText: false), findsOneWidget);

		// Price display: old price shown and new price appears both as price
		// and inside the 'ADD' button label, so expect two matches for £14.99
		expect(find.textContaining('£20.00'), findsOneWidget);
		expect(find.textContaining('£14.99'), findsNWidgets(2));

		// Colour and Size default selections (first entries)
		expect(find.text('Pink'), findsOneWidget);
		expect(find.text('S'), findsOneWidget);

		// Quantity default and increment/decrement
		expect(find.text('1'), findsWidgets);

		// Check add button label reflects total price for quantity 1
		expect(find.widgetWithText(ElevatedButton, 'ADD £14.99 TO CART'), findsOneWidget);

		// Tap the add icon to increase quantity
		await tester.tap(find.byIcon(Icons.add).first);
		await tester.pumpAndSettle();

		// Quantity should update to 2 and total on button should update
		expect(find.text('2'), findsWidgets);
		expect(find.widgetWithText(ElevatedButton, 'ADD £29.98 TO CART'), findsOneWidget);

		// Tap the remove icon to decrease quantity back to 1
		await tester.tap(find.byIcon(Icons.remove).first);
		await tester.pumpAndSettle();

		expect(find.text('1'), findsWidgets);
		expect(find.widgetWithText(ElevatedButton, 'ADD £14.99 TO CART'), findsOneWidget);
	});

	testWidgets('ProductScreen renders cart screen', (WidgetTester tester) async {
		await pumpProductScreen(tester);

    // Tap the add to cart button
    // Ensure the add button is visible (may be off-screen in tests) then tap
    final addButton = find.widgetWithText(ElevatedButton, 'ADD £14.99 TO CART');
    await tester.ensureVisible(addButton);
    await tester.pumpAndSettle();
    await tester.tap(addButton);
    await tester.pumpAndSettle();

    // Verify cart screen is shown with the added item
    expect(find.text('Your Cart'), findsOneWidget);
  });

	testWidgets('ProductScreen changes colour and size', (WidgetTester tester) async {
		// Ensure cart is clear before test
		CartModel.instance.clear();

		await pumpProductScreen(tester);

		// Defaults are first entries
		expect(find.text('Pink'), findsOneWidget);
		expect(find.text('S'), findsOneWidget);

		// Open colour dropdown and select 'Black'
		await tester.ensureVisible(find.text('Pink'));
		await tester.pumpAndSettle();
		await tester.tap(find.text('Pink'));
		await tester.pumpAndSettle();
		// Tap the menu item for Black (may appear as an overlay)
		await tester.tap(find.text('Black').last);
		await tester.pumpAndSettle();

		// Open size dropdown and select 'M'
		await tester.ensureVisible(find.text('S'));
		await tester.pumpAndSettle();
		await tester.tap(find.text('S'));
		await tester.pumpAndSettle();
		await tester.tap(find.text('M').last);
		await tester.pumpAndSettle();

		// Verify selections updated in the UI
		expect(find.text('Black'), findsWidgets);
		expect(find.text('M'), findsWidgets);
	});

  
}
