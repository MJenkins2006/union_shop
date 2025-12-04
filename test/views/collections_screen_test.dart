import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:union_shop/views/collections_screen.dart';
import 'package:union_shop/database.dart';

void main() {
	// Keep a snapshot of the original collections so tests can restore state.
	late List<Map<String, String>> originalCollections;

	setUp(() {
		originalCollections = collections.map((m) => Map<String, String>.from(m)).toList();
	});

	tearDown(() {
		collections.clear();
		collections.addAll(originalCollections.map((m) => Map<String, String>.from(m)));
	});

	Future<void> pumpCollectionsScreen(WidgetTester tester,
			{double width = 700, GoRouter? router}) async {
		final widget = router != null
				? MaterialApp.router(
						routerConfig: router,
					)
				: const MaterialApp(
						home: MediaQuery(
							data: MediaQueryData(size: Size(400, 900)),
							child: CollectionsScreen(),
						),
					);

		await tester.pumpWidget(MediaQuery(
			data: MediaQueryData(size: Size(width, 900)),
			child: widget,
		));
		await tester.pumpAndSettle();
	}

	testWidgets('renders header, title and sort dropdown', (tester) async {
		await pumpCollectionsScreen(tester);

		expect(find.text('Collections'), findsOneWidget);
		expect(find.text('Sort: '), findsOneWidget);
		expect(find.byType(DropdownButton<SortOrder>), findsOneWidget);
	});

	testWidgets('shows all collection cards with correct texts', (tester) async {
		await pumpCollectionsScreen(tester);

		// The database contains these collection names
		expect(find.text('SALES'), findsOneWidget);
		expect(find.text('CARDS'), findsOneWidget);
		expect(find.text('CLOTHES'), findsOneWidget);
	});

	testWidgets('navigates to collection route on tap', (tester) async {
		final router = GoRouter(
			initialLocation: '/',
			routes: [
				GoRoute(
					path: '/',
					builder: (context, state) => const CollectionsScreen(),
				),
				GoRoute(
					path: '/collections/:name',
					builder: (context, state) => Scaffold(
						body: Text('COLLECTION: ${state.pathParameters['name']}', textDirection: TextDirection.ltr),
					),
				),
			],
		);

		// Use a moderate width to avoid header overflow in the test environment
		await pumpCollectionsScreen(tester, width: 400, router: router);

		// Tap the first collection card (SALES)
		final salesFinder = find.text('SALES');
		expect(salesFinder, findsOneWidget);
		await tester.ensureVisible(salesFinder);
		await tester.tap(salesFinder);
		await tester.pumpAndSettle();

		// After tapping we should land on the collection route and see route text
		expect(find.textContaining('COLLECTION:'), findsOneWidget);
	});
  
	testWidgets('sorts collections A-Z and Z-A', (tester) async {
		// Use narrow width so collections stack vertically (single column)
		await pumpCollectionsScreen(tester, width: 400);

		// Ensure the named collection texts exist
		expect(find.text('CARDS'), findsOneWidget);
		expect(find.text('CLOTHES'), findsOneWidget);
		expect(find.text('SALES'), findsOneWidget);

		double topOf(String text) => tester.getTopLeft(find.text(text)).dy;

		// Default sort is A to Z (configured in the widget state)
		final cardsY = topOf('CARDS');
		final clothesY = topOf('CLOTHES');
		final salesY = topOf('SALES');

		expect(cardsY < clothesY && clothesY < salesY, isTrue,
				reason: 'Expected A→Z order: CARDS, CLOTHES, SALES');

		// Open the dropdown by tapping the visible selected label and select Z to A
		await tester.tap(find.text('A to Z'));
		await tester.pumpAndSettle();
		await tester.tap(find.text('Z to A').last);
		await tester.pumpAndSettle();

		// After selecting Z→A the order should be reversed
		final cardsY2 = topOf('CARDS');
		final clothesY2 = topOf('CLOTHES');
		final salesY2 = topOf('SALES');

		expect(salesY2 < clothesY2 && clothesY2 < cardsY2, isTrue,
				reason: 'Expected Z→A order: SALES, CLOTHES, CARDS');
	});
}