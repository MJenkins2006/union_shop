import 'package:flutter/material.dart';
import 'package:union_shop/product_page.dart';
import 'package:union_shop/views/about_screen.dart';
import 'package:union_shop/views/home_screen.dart';
import 'package:union_shop/views/collections_screen.dart';
import 'package:union_shop/views/collection_screen.dart';

void main() {
  runApp(const UnionShopApp());
}

class UnionShopApp extends StatelessWidget {
  const UnionShopApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Union Shop',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF4d2963)),
      ),
      home: const HomeScreen(),
      // By default, the app starts at the '/' route, which is the HomeScreen
      initialRoute: '/',
      routes: {
        '/product': (context) => const ProductPage(),
        '/about': (context) => const AboutScreen(),
        '/collections': (context) => const CollectionsScreen(),
      },
      onGenerateRoute: (collection) {
        final uri = Uri.parse(collection.name!);
        return MaterialPageRoute(
            builder: (context) => CollectionScreen(id: Uri.decodeComponent(uri.pathSegments[1])),
            settings: collection,
          );
        }
    );
  }
}