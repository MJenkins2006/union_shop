import 'package:flutter/material.dart';
import 'package:union_shop/product_page.dart';
import 'package:union_shop/views/about_screen.dart';
import 'package:union_shop/views/home_screen.dart';
import 'package:union_shop/views/collections_screen.dart';
import 'package:union_shop/views/collection_screen.dart';
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
          path: '/product',
          builder: (context, state) => const ProductPage(),
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
          path: '/collections/:id',
          builder: (context, state) {
            final rawId = state.pathParameters['id'] ?? '';
            final id = Uri.decodeComponent(rawId);
            return CollectionScreen(id: id);
          },
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