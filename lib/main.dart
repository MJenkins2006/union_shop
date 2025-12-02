import 'package:flutter/material.dart';
import 'package:union_shop/views/product_screen.dart';
import 'package:union_shop/views/about_screen.dart';
import 'package:union_shop/views/home_screen.dart';
import 'package:union_shop/views/collections_screen.dart';
import 'package:union_shop/views/personalisation_screen.dart';
import 'package:union_shop/views/personalisation_about_screen.dart';
import 'package:union_shop/views/collection_screen.dart';
import 'package:union_shop/views/cart_screen.dart';
import 'package:union_shop/views/authentication.dart';
import 'package:go_router/go_router.dart';

void main() {
  runApp(const UnionShopApp());
}

class UnionShopApp extends StatelessWidget {
  const UnionShopApp({super.key});

  @override
  Widget build(BuildContext context) {
    final GoRouter router = GoRouter(
      initialLocation: '/',
      routes: <GoRoute>[
        GoRoute(
          path: '/',
          builder: (context, state) => const HomeScreen(),
        ),
        GoRoute(
          path: '/about',
          builder: (context, state) => const AboutScreen(),
        ),
        GoRoute(
          path: '/collections',
          builder: (context, state) => const CollectionsScreen(),
        ),
        GoRoute(
          path: '/personalisation',
          builder: (context, state) => const PersonalisationScreen(),
        ),
        GoRoute(
          path: '/personalisation/about',
          builder: (context, state) => const PersonalisationAboutScreen(),
        ),
        GoRoute(
          path: '/signup',
          builder: (context, state) => const SignUpScreen(),
        ),
        GoRoute(
          path: '/collections/:collectionId',
          builder: (context, state) {
            final rawCollectionId = state.pathParameters['collectionId'] ?? '';
            final collectionId = Uri.decodeComponent(rawCollectionId);
            return CollectionScreen(collectionId: collectionId);
          },
        ),
        GoRoute(
          path: '/collections/:collectionId/products/:productId',
          builder: (context, state) {
            final rawProductId = state.pathParameters['productId'] ?? '';
            final productId = Uri.decodeComponent(rawProductId);
            final rawCollectionId = state.pathParameters['collectionId'] ?? '';
            final collectionId = Uri.decodeComponent(rawCollectionId);
            return ProductScreen(collectionId: collectionId, productId: productId);
          },
        ),
        GoRoute(
          path: '/cart',
          builder: (context, state) => const CartScreen(),
        ),
      ],
    );

    return MaterialApp.router(
      title: 'Union Shop',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF4d2963)),
      ),
      routerConfig: router,
    );
  }
}