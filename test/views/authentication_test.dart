import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:union_shop/views/authentication.dart';
import 'package:go_router/go_router.dart';

void main() {
	testWidgets('SignInScreen shows header, footer and sign in button works', (WidgetTester tester) async {
		await tester.pumpWidget(
			const MaterialApp(
				home: MediaQuery(
					data: MediaQueryData(size: Size(400, 900)),
					child: SignInScreen(),
				),
			),
		);

		await tester.pumpAndSettle();

		// Header contains banner text
		final headerFinder = find.byWidgetPredicate((w) => w is Text && (w.data ?? '').contains('BIG SALE'));
		expect(headerFinder, findsWidgets);

		// Footer copyright text
		final footerFinder = find.text('© 2025, upsu-store Powered by Shopify');
		expect(footerFinder, findsOneWidget);

		// Sign in form fields exist
		expect(find.byKey(const Key('signin-email')), findsOneWidget);
		expect(find.byKey(const Key('signin-password')), findsOneWidget);

		// Enter text into fields
		await tester.enterText(find.byKey(const Key('signin-email')), 'test@example.com');
		await tester.enterText(find.byKey(const Key('signin-password')), 'password123');
		await tester.pump();
		expect(find.text('test@example.com'), findsOneWidget);

		// Sign in button exists and is enabled
		final signInButtonFinder = find.widgetWithText(ElevatedButton, 'Sign in');
		expect(signInButtonFinder, findsOneWidget);
		final ElevatedButton signInButton = tester.widget(signInButtonFinder);
		expect(signInButton.onPressed, isNotNull);

		// Tap the button (should not throw)
		await tester.tap(signInButtonFinder);
		await tester.pump();
	});

	testWidgets('SignUpScreen shows header, footer and create account button works', (WidgetTester tester) async {
		await tester.pumpWidget(
			const MaterialApp(
				home: MediaQuery(
					data: MediaQueryData(size: Size(400, 900)),
					child: SignUpScreen(),
				),
			),
		);

		await tester.pumpAndSettle();

		// Header contains banner text
		final headerFinder = find.byWidgetPredicate((w) => w is Text && (w.data ?? '').contains('BIG SALE'));
		expect(headerFinder, findsWidgets);

		// Footer copyright text
		final footerFinder = find.text('© 2025, upsu-store Powered by Shopify');
		expect(footerFinder, findsOneWidget);

		// Sign up form fields exist
		expect(find.byKey(const Key('signup-name')), findsOneWidget);
		expect(find.byKey(const Key('signup-email')), findsOneWidget);
		expect(find.byKey(const Key('signup-password')), findsOneWidget);

		// Enter text into fields
		await tester.enterText(find.byKey(const Key('signup-name')), 'Test User');
		await tester.enterText(find.byKey(const Key('signup-email')), 'new@example.com');
		await tester.enterText(find.byKey(const Key('signup-password')), 'pass1234');
		await tester.pump();
		expect(find.text('Test User'), findsOneWidget);

		// Create account button exists and is enabled
		final createButtonFinder = find.widgetWithText(ElevatedButton, 'Create account');
		expect(createButtonFinder, findsOneWidget);
		final ElevatedButton createButton = tester.widget(createButtonFinder);
		expect(createButton.onPressed, isNotNull);

		// Tap the button (should not throw)
		await tester.tap(createButtonFinder);
		await tester.pump();
	});

	testWidgets('small two-step navigation: signin -> signup -> signin', (WidgetTester tester) async {
		final router = GoRouter(routes: [
			GoRoute(
				path: '/signin',
				builder: (context, state) => const MediaQuery(
					data: MediaQueryData(size: Size(400, 900)),
					child: SignInScreen(),
				),
			),
			GoRoute(
				path: '/signup',
				builder: (context, state) => const MediaQuery(
					data: MediaQueryData(size: Size(400, 900)),
					child: SignUpScreen(),
				),
			),
		], initialLocation: '/signin');

		await tester.pumpWidget(MaterialApp.router(routerConfig: router));
		await tester.pumpAndSettle();

		// Start on SignInScreen
		expect(find.byType(SignInScreen), findsOneWidget);
		// Tap 'Need an account? Sign up'
		final needAccount = find.text('Need an account? Sign up');
		expect(needAccount, findsOneWidget);
		await tester.tap(needAccount);
		await tester.pumpAndSettle();

		// Should be on SignUpScreen
		expect(find.byType(SignUpScreen), findsOneWidget);

		// Tap 'Got an account? Sign in'
		final gotAccount = find.text('Got an account? Sign in');
		expect(gotAccount, findsOneWidget);
		await tester.tap(gotAccount);
		await tester.pumpAndSettle();

		// Back to SignInScreen
		expect(find.byType(SignInScreen), findsOneWidget);
	});
}

