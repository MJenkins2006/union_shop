import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:union_shop/views/personalisation_about_screen.dart';

void main() {
	Future<void> pumpAboutScreen(WidgetTester tester, {double width = 800}) async {
		final router = GoRouter(routes: [
			GoRoute(
				path: '/',
				builder: (context, state) => MediaQuery(
					  data: MediaQueryData(size: Size(width, 800)),
					  child: const PersonalisationAboutScreen(),
					),
			),
			GoRoute(
				path: '/personalisation',
				builder: (context, state) => const Scaffold(
					  body: Center(child: Text('PERSONALISATION PAGE')),
					),
			),
		]);

		await tester.pumpWidget(MaterialApp.router(routerConfig: router));
		await tester.pumpAndSettle();
	}

	testWidgets('PersonalisationAboutScreen shows heading', (tester) async {
		await pumpAboutScreen(tester, width: 400);

		// Heading should be visible
		expect(find.text('Personalisation Service'), findsOneWidget);

		// Page is scrollable (there may be multiple scrollables from header/footer)
		expect(find.byType(SingleChildScrollView), findsWidgets);
	});

	testWidgets('PersonalisationAboutScreen shows message', (tester) async {
		await pumpAboutScreen(tester, width: 400);
		expect(find.text(
'''
At the Union Shop, we offer a personalisation service that allows you to add custom text to selected products. Whether you're looking to personalise a gift or create something unique for yourself, our service makes it easy and affordable.
''',), findsOneWidget);
	});

	testWidgets('PersonalisationAboutScreen shows footer', (tester) async {
		await pumpAboutScreen(tester, width: 400);

		// Footer contains the copyright/credit line
		expect(find.text('© 2025, upsu-store Powered by Shopify'), findsOneWidget);
	});

		testWidgets('Back button navigates to personalisation route', (tester) async {
				await pumpAboutScreen(tester, width: 400);

				// The screen exposes a back button to the personalisation page
				final buttonFinder = find.widgetWithText(ElevatedButton, 'Back to Personalisation');
				expect(buttonFinder, findsOneWidget);

				await tester.tap(buttonFinder);
				await tester.pumpAndSettle();

				// After tapping, the router should navigate to our placeholder personalisation page
				expect(find.text('PERSONALISATION PAGE'), findsOneWidget);
			});
}

