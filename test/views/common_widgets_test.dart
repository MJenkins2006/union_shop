import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:union_shop/views/common_widgets.dart';

void main() {
	// Helper to pump a widget constrained to a specific width via MediaQuery.
	Future<void> pumpWithWidth(WidgetTester tester, double width, Widget child) async {
		await tester.pumpWidget(
			MediaQuery(
				data: MediaQueryData(size: Size(width, 800)),
				child: MaterialApp(home: Builder(builder: (context) => child)),
			),
		);
		await tester.pumpAndSettle();
	}

	testWidgets('buildHeaderDesktop shows banner and nav buttons', (WidgetTester tester) async {
		// Pump header inside a constrained width MediaQuery instead of modifying tester.window.
		await pumpWithWidth(
			tester,
			1200,
						Builder(
								builder: (context) => SingleChildScrollView(
											scrollDirection: Axis.horizontal,
											child: SizedBox(width: 1200, child: buildHeader(context)),
										)),
		);

		// Banner contains the 'BIG SALE' string
		expect(
			find.byWidgetPredicate((w) => w is Text && (w.data ?? '').contains('BIG SALE')),
			findsOneWidget,
		);

		// Desktop nav includes a 'Home' button
		expect(find.widgetWithText(TextButton, 'Home'), findsOneWidget);
	});

	testWidgets('tapping burger icon opens mobile menu dialog', (WidgetTester tester) async {
		// Pump mobile header (narrow width)
		await pumpWithWidth(
			tester,
			360,
			Builder(builder: (context) => SizedBox(width: 360, child: buildHeader(context))),
		);

		// Ensure menu icon exists and tap it
		final menuFinder = find.byIcon(Icons.menu);
		expect(menuFinder, findsOneWidget);

		await tester.tap(menuFinder);
		await tester.pumpAndSettle();

		// After tapping the burger, the dialog should expose navigation ListTile items such as 'Home'
		expect(find.text('Home'), findsOneWidget);
	});

	testWidgets('buildFooter produces desktop layout at wide widths', (WidgetTester tester) async {
		await pumpWithWidth(
			tester,
			1200,
			Builder(
				builder: (context) => Scaffold(
					body: SingleChildScrollView(
						scrollDirection: Axis.horizontal,
						child: SizedBox(width: 4000, child: buildFooter(context)),
					),
				),
			),
		);

		// Desktop footer should contain copyright text and subscription text
		expect(find.textContaining('© 2025, upsu-store'), findsOneWidget);
		expect(find.textContaining('Latest Offers'), findsOneWidget);
	});

	testWidgets('buildHeaderMobile shows banner and Account tooltip', (WidgetTester tester) async {
		final widget = MediaQuery(
			data: const MediaQueryData(size: Size(360, 800)),
			child: MaterialApp(
				home: Builder(
					builder: (context) => SizedBox(width: 360, child: buildHeader(context)),
				),
			),
		);
		await tester.pumpWidget(widget);
		await tester.pumpAndSettle();

		// Mobile banner still contains 'BIG SALE' (shortened)
		expect(
			find.byWidgetPredicate((w) => w is Text && (w.data ?? '').contains('BIG SALE')),
			findsOneWidget,
		);

		// Mobile header includes an Account icon with a tooltip
		expect(find.byTooltip('Account'), findsOneWidget);
	});

	testWidgets('ProductCard displays product name and single price', (WidgetTester tester) async {
		const widget = MaterialApp(
			home: Scaffold(
				body: SizedBox(
					height: 200,
					width: 200,
					child: ProductCard(
						product: 'T-Shirt',
						price: '9.99',
						imageUrl: 'assets/images/missing.png',
						collection: 'Clothing',
					),
				),
			),
		);

		await tester.pumpWidget(widget);
		await tester.pumpAndSettle();

		expect(find.text('T-Shirt'), findsOneWidget);
		expect(find.text('£9.99'), findsOneWidget);
	});

	testWidgets('ProductCard displays old and new prices when multiple values', (WidgetTester tester) async {
		const widget = MaterialApp(
			home: Scaffold(
				body: SizedBox(
					height: 200,
					width: 200,
					child: ProductCard(
						product: 'Hoodie',
						price: '15.00 9.99',
						imageUrl: 'assets/images/missing.png',
						collection: 'Clothing',
					),
				),
			),
		);

		await tester.pumpWidget(widget);
		await tester.pumpAndSettle();

		expect(
			find.byWidgetPredicate((w) => w is Text && (w.data ?? '').contains('£15.00')),
			findsOneWidget,
		);
		expect(find.text('£9.99'), findsOneWidget);
	});
}
