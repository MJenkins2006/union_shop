import 'package:flutter/material.dart';
import 'package:union_shop/views/common_widgets.dart';
import 'package:union_shop/database.dart';
import 'package:go_router/go_router.dart';

enum SortOrder { aToZ, zToA, priceDesc, priceAsc }
enum PriceFilter { all, under10, over10 }

class CollectionScreen extends StatefulWidget {
  final String collectionId;
  const CollectionScreen({super.key, required this.collectionId});

  @override
  State<CollectionScreen> createState() => _CollectionScreenState();
}

class _CollectionScreenState extends State<CollectionScreen> {
  SortOrder _selectedSortOrder = SortOrder.aToZ;
  PriceFilter _selectedFilter = PriceFilter.all;
  List<Map<String, dynamic>> _displayedProducts = [];

  @override
  void initState() {
    super.initState();
    _applyFiltersAndSort();
  }
  void _applyFiltersAndSort() {
    // Start from the global products list and filter to the current collection
    final collectionId = widget.collectionId.toUpperCase();
    _displayedProducts = products.where((product) => product['collection'] == collectionId).toList();

    // Apply price filter
    if (_selectedFilter == PriceFilter.under10) {
      _displayedProducts = _displayedProducts
          .where((product) => _parsePrice(product['price']) < 10.0)
          .toList();
    } else if (_selectedFilter == PriceFilter.over10) {
      _displayedProducts = _displayedProducts
          .where((product) => _parsePrice(product['price']) >= 10.0)
          .toList();
    }

    // Apply sort
    _displayedProducts.sort((leftProduct, rightProduct) {
      switch (_selectedSortOrder) {
        case SortOrder.aToZ:
          final leftName = (leftProduct['product'] ?? '').toString().toLowerCase();
          final rightName = (rightProduct['product'] ?? '').toString().toLowerCase();
          return leftName.compareTo(rightName);
        case SortOrder.zToA:
          final leftName = (leftProduct['product'] ?? '').toString().toLowerCase();
          final rightName = (rightProduct['product'] ?? '').toString().toLowerCase();
          return rightName.compareTo(leftName);
        case SortOrder.priceAsc:
          final leftPrice = _parsePrice(leftProduct['price']);
          final rightPrice = _parsePrice(rightProduct['price']);
          return leftPrice.compareTo(rightPrice);
        case SortOrder.priceDesc:
          final leftPrice = _parsePrice(leftProduct['price']);
          final rightPrice = _parsePrice(rightProduct['price']);
          return rightPrice.compareTo(leftPrice);
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

  List<DropdownMenuItem<PriceFilter>> _buildFilterEntries() {
    return [
      const DropdownMenuItem<PriceFilter>(
          value: PriceFilter.all, child: Text('All', style: TextStyle(fontSize: 14))),
      const DropdownMenuItem<PriceFilter>(
          value: PriceFilter.under10, child: Text('Under £10', style: TextStyle(fontSize: 14))),
      const DropdownMenuItem<PriceFilter>(
          value: PriceFilter.over10, child: Text('Over £10', style: TextStyle(fontSize: 14))),
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
            Text('${widget.collectionId.toUpperCase()} Collection',
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            for (var collection in collections)
              if (collection['collection'] == widget.collectionId.toUpperCase())
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
                              _applyFiltersAndSort();
                            });
                          }
                        },
                      ),
                    ),
                  ),
                  const SizedBox(width: 24),
                  const Text('Filter: '),
                  const SizedBox(width: 8),
                  SizedBox(
                    width: 140,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade400),
                        borderRadius: BorderRadius.circular(4.0),
                      ),
                      child: DropdownButton<PriceFilter>(
                        isExpanded: true,
                        value: _selectedFilter,
                        underline: const SizedBox.shrink(),
                        iconSize: 18,
                        style: const TextStyle(fontSize: 14, color: Colors.black),
                        items: _buildFilterEntries(),
                        onChanged: (PriceFilter? value) {
                          if (value != null) {
                            setState(() {
                              _selectedFilter = value;
                              _applyFiltersAndSort();
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
                    for (var product in _displayedProducts)
                        ProductCard(
                          collection: product['collection'] ?? '',
                          product: product['product'] ?? '',
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
