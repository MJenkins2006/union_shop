import 'package:flutter/material.dart';
import 'package:union_shop/views/common_widgets.dart';
import 'package:union_shop/database.dart';
import 'package:go_router/go_router.dart';

enum SortOrder { aToZ, zToA, priceDesc, priceAsc }

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
      switch (_selectedSortOrder) {
        case SortOrder.aToZ:
          final at = a['title']!.toLowerCase();
          final bt = b['title']!.toLowerCase();
          return at.compareTo(bt);
        case SortOrder.zToA:
          final at = a['title']!.toLowerCase();
          final bt = b['title']!.toLowerCase();
          return bt.compareTo(at);
        case SortOrder.priceAsc:
          final ap = _parsePrice(a['price']);
          final bp = _parsePrice(b['price']);
          return ap.compareTo(bp);
        case SortOrder.priceDesc:
          final ap = _parsePrice(a['price']);
          final bp = _parsePrice(b['price']);
          return bp.compareTo(ap);
      }
    });
  }

  double _parsePrice(String? priceStr) {
    if (priceStr == null || priceStr.isEmpty) return double.infinity;
    // Handle cases where there might be a discount (e.g., "20.00 14.99")
    final parts = priceStr.split(' ');
    return double.tryParse(parts.last) ?? double.infinity;
  }

  List<DropdownMenuItem<SortOrder>> _buildSortEntries() {
    return [
      const DropdownMenuItem<SortOrder>(
          value: SortOrder.aToZ, child: Text('A to Z', style: TextStyle(fontSize: 14))),
      const DropdownMenuItem<SortOrder>(
          value: SortOrder.zToA, child: Text('Z to A', style: TextStyle(fontSize: 14))),
      const DropdownMenuItem<SortOrder>(
          value: SortOrder.priceAsc, child: Text('Price: Low → High', style: TextStyle(fontSize: 14))),
      const DropdownMenuItem<SortOrder>(
          value: SortOrder.priceDesc, child: Text('Price: High → Low', style: TextStyle(fontSize: 14))),
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
            for (var collection in collections)
              if (collection['collection'] == widget.id.toUpperCase())
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  child: Text(
                    collection['description'] ?? '',
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 2.0),
              child: Row(
                children: [
                  const Text('Sort: '),
                  const SizedBox(width: 8),
                  SizedBox(
                    width: 140,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade400),
                        borderRadius: BorderRadius.circular(4.0),
                      ),
                      child: DropdownButton<SortOrder>(
                        isExpanded: true,
                        value: _selectedSortOrder,
                        underline: const SizedBox.shrink(),
                        iconSize: 18,
                        style: const TextStyle(fontSize: 14, color: Colors.black),
                        items: _buildSortEntries(),
                        onChanged: (SortOrder? value) {
                          if (value != null) {
                            setState(() {
                              _selectedSortOrder = value;
                              _sortProducts();
                            });
                          }
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(40.0),
                child: GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount:
                      MediaQuery.of(context).size.width > 600 ? 2 : 1,
                  crossAxisSpacing: 24,
                  mainAxisSpacing: 48,
                  children: [
                    for (var product in products)
                    if (product['collection'] == widget.id.toUpperCase())
                        ProductCard(
                          title: product['title'] ?? '',
                          price: product['price'] ?? '',
                          imageUrl: product['imageUrl'] ?? '',
                        ),
                  ],
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
              context.go('/collections');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF4d2963),
                foregroundColor: Colors.white,
              ),
              child: const Text('Return to Collections'),
            ),
            // Footer
            buildFooter(context),
          ],
        ),
      ),
    );
  }
}
