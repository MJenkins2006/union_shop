import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:union_shop/views/about_screen.dart';

void main() {
	Future<void> pumpAboutScreen(WidgetTester tester, {double width = 800}) async {
		await tester.pumpWidget(
			MaterialApp(
				home: MediaQuery(
					data: MediaQueryData(size: Size(width, 800)),
					child: const AboutScreen(),
				),
			),
		);
		await tester.pumpAndSettle();
	}

	testWidgets('AboutScreen shows heading and contact email', (tester) async {
		await pumpAboutScreen(tester, width: 400);

		// Heading should be visible
		expect(find.text('About us'), findsOneWidget);

		// The long paragraph contains the contact email; search Text widgets for that substring
		final finder = find.byWidgetPredicate((w) {
			return w is Text && (w.data ?? '').contains('hello@upsu.net');
		});
		expect(finder, findsOneWidget);

		// Page is scrollable (there may be multiple scrollables from header/footer)
		expect(find.byType(SingleChildScrollView), findsWidgets);
	});

	testWidgets('AboutScreen shows message', (tester) async {
		await pumpAboutScreen(tester, width: 400);
		expect(find.text(
                '''
Welcome to the Union Shop!

We're dedicated to giving you the very best University branded products, with a range of clothing and merchandise available to shop all year round! We even offer an exclusive personalisation service!

All online purchases are available for delivery or instore collection!

We hope you enjoy our products as much as we enjoy offering them to you. If you have any questions or comments, please don’t hesitate to contact us at hello@upsu.net.

Happy shopping!

The Union Shop & Reception Team
            '''), findsOneWidget);
	});

	testWidgets('AboutScreen shows footer', (tester) async {
		await pumpAboutScreen(tester, width: 400);

		// Footer contains the copyright/credit line
		expect(find.text('© 2025, upsu-store Powered by Shopify'), findsOneWidget);
	});
}