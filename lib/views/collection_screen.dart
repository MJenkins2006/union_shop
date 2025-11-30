import 'package:flutter/material.dart';
import 'package:union_shop/views/common_widgets.dart';
import 'package:union_shop/database.dart';

enum SortOrder { aToZ, zToA }

class CollectionScreen extends StatefulWidget {
  final String id;
  const CollectionScreen({super.key, required this.id});

  @override
  State<CollectionScreen> createState() => _CollectionScreenState();
}

class _CollectionScreenState extends State<CollectionScreen> {
  SortOrder _selectedSortOrder = SortOrder.aToZ;

  @override
  void initState() {
    super.initState();
    _sortProducts();
  }

  void _sortProducts() {
    products.sort((a, b) {
      final at = a['title']!.toLowerCase();
      final bt = b['title']!.toLowerCase();
      int cmp = at.compareTo(bt);
      return _selectedSortOrder == SortOrder.aToZ ? cmp : -cmp;
    });
  }

  List<DropdownMenuItem<SortOrder>> _buildSortEntries() {
    return [
      const DropdownMenuItem<SortOrder>(
          value: SortOrder.aToZ, child: Text('A to Z', style: TextStyle(fontSize: 14))),
      const DropdownMenuItem<SortOrder>(
          value: SortOrder.zToA, child: Text('Z to A', style: TextStyle(fontSize: 14))),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header
            buildHeader(context),
            Text('${widget.id.toUpperCase()} Collection',
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            for (var product in products)
              if (product['collection'] == widget.id.toUpperCase())
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: SizedBox(
                  height: 200,
                  child: ProductCard(
                    title: product['title']!,
                    imageUrl: product['imageUrl']!,
                  ),
                ),
              ),
            // Footer
            buildFooter(context),
          ],
        ),
      ),
    );
  }
}

class ProductCard extends StatelessWidget {
  final String title;
  final String imageUrl;

  const ProductCard({
    super.key,
    required this.title,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, '/product');
      },
      child: Stack(
        children: [
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(
                    imageUrl,
                  ),
                  fit: BoxFit.cover,
                ),
              ),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.7),
                ),
              ),
            ),
          ),
          Positioned.fill(
            child: Center(
              child: Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  height: 1.2,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
