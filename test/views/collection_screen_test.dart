import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:union_shop/views/collection_screen.dart';
import 'package:union_shop/database.dart';

void main() {
	// Snapshot original data so tests can restore state.
	late List<Map<String, String>> originalCollections;
	late List<Map<String, String>> originalProducts;

	setUp(() {
		originalCollections = collections.map((m) => Map<String, String>.from(m)).toList();
		originalProducts = products.map((m) => Map<String, String>.from(m)).toList();
	});

	tearDown(() {
		collections.clear();
		collections.addAll(originalCollections.map((m) => Map<String, String>.from(m)));
		products.clear();
		products.addAll(originalProducts.map((m) => Map<String, String>.from(m)));
	});

	Future<void> pumpCollectionScreen(WidgetTester tester,
			{required String collectionId, double width = 700, GoRouter? router}) async {
		final widget = router != null
				? MaterialApp.router(routerConfig: router)
				: MaterialApp(
						home: MediaQuery(
							data: MediaQueryData(size: Size(width, 900)),
							child: CollectionScreen(collectionId: collectionId),
						),
					);

		await tester.pumpWidget(MediaQuery(
			data: MediaQueryData(size: Size(width, 900)),
			child: widget,
		));
		await tester.pumpAndSettle();
	}

	testWidgets('renders header, title, description and controls', (tester) async {
		await pumpCollectionScreen(tester, collectionId: 'sales');

		expect(find.text('SALES Collection'), findsOneWidget);
		// Description from the database should be visible (collection-specific)
		expect(find.text('ESSENTIAL RANGE - OVER 20% OFF!'), findsOneWidget);
		// Sort and filter controls
		expect(find.text('Sort: '), findsOneWidget);
		expect(find.text('Filter: '), findsOneWidget);
		expect(find.byType(DropdownButton<SortOrder>), findsOneWidget);
		expect(find.byType(DropdownButton<PriceFilter>), findsOneWidget);
	});

	testWidgets('shows products for collection and filter under £10 works', (tester) async {
		// Clothes collection contains 3 items including one under £10
		await pumpCollectionScreen(tester, collectionId: 'clothes');

		// All products present initially
		expect(find.text('HOODIES'), findsOneWidget);
		expect(find.text('SHIRTS'), findsOneWidget);
		expect(find.text('TROUSERS'), findsOneWidget);

		// Open filter dropdown (shows selected label 'All') and pick 'Under £10'
		await tester.tap(find.text('All'));
		// Allow the dropdown overlay time to appear
		await tester.pump();
		await tester.pump(const Duration(milliseconds: 100));
		final underFinder = find.text('Under £10');
		expect(underFinder, findsWidgets,
			reason: 'Expected filter option "Under £10" to be present');
		await tester.tap(underFinder.last);
		await tester.pumpAndSettle();

		// Now only TROUSERS (9.99) should remain
		expect(find.text('TROUSERS'), findsOneWidget);
		expect(find.text('HOODIES'), findsNothing);
		expect(find.text('SHIRTS'), findsNothing);
	});

	testWidgets('sorts by price low -> high for a collection', (tester) async {
		await pumpCollectionScreen(tester, collectionId: 'sales', width: 400);

		// Ensure names exist
		expect(find.text('ZIP-HOODIE'), findsOneWidget);
		expect(find.text('T-SHIRT'), findsOneWidget);
		expect(find.text('TROUSERS'), findsOneWidget);

		double topOf(String text) => tester.getTopLeft(find.text(text)).dy;

		// Open sort dropdown and select 'Price: Low → High'
		await tester.tap(find.text('A to Z'));
		await tester.pumpAndSettle();
		await tester.tap(find.text('Price: Low → High').last);
		await tester.pumpAndSettle();

		final tShirtY = topOf('T-SHIRT');
		final trousersY = topOf('TROUSERS');
		final zipY = topOf('ZIP-HOODIE');

		expect(tShirtY < trousersY && trousersY < zipY, isTrue,
				reason: 'Expected order by price low→high: T-SHIRT, TROUSERS, ZIP-HOODIE');
	});

	testWidgets('navigates to product route on product tap', (tester) async {
		final router = GoRouter(
			initialLocation: '/collections/sales',
			routes: [
				GoRoute(
					path: '/collections/:collection',
					builder: (context, state) => CollectionScreen(collectionId: state.pathParameters['collection']!),
				),
				GoRoute(
					path: '/collections/:collection/products/:product',
					builder: (context, state) => Scaffold(
						body: Text('PRODUCT: ${state.pathParameters['product']}', textDirection: TextDirection.ltr),
					),
				),
			],
		);

		await pumpCollectionScreen(tester, collectionId: 'sales', router: router, width: 500);

		// Tap the T-SHIRT product card
		final tshirt = find.text('T-SHIRT');
		expect(tshirt, findsOneWidget);
		await tester.ensureVisible(tshirt);
		await tester.tap(tshirt);
		await tester.pumpAndSettle();

		// Should navigate to product route and show route text
		expect(find.textContaining('PRODUCT:'), findsOneWidget);
	});
}

