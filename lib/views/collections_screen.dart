import 'package:flutter/material.dart';
import 'package:union_shop/views/common_widgets.dart';
import 'package:union_shop/database.dart';
import 'package:go_router/go_router.dart';

enum SortOrder { aToZ, zToA }

class CollectionsScreen extends StatefulWidget {
  const CollectionsScreen({super.key});

  @override
  State<CollectionsScreen> createState() => _CollectionsScreenState();
}

class _CollectionsScreenState extends State<CollectionsScreen> {
  SortOrder _selectedSortOrder = SortOrder.aToZ;

  @override
  void initState() {
    super.initState();
    _sortCollections();
  }

  void _sortCollections() {
    collections.sort((a, b) {
      final at = a['collection']!.toLowerCase();
      final bt = b['collection']!.toLowerCase();
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
            // Hero Section
            const SizedBox(height: 8),
            const Text(
              'Collections',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
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
                              _sortCollections();
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
                    for (var item in collections)
                      CollectionCard(
                        collection: item['collection']!,
                        imageUrl: item['imageUrl']!,
                      ),
                  ],
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
              context.go('/');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF4d2963),
                foregroundColor: Colors.white,
              ),
              child: const Text('Return home'),
            ),
            const SizedBox(height: 24),
            // Footer
            buildFooter(context),
          ],
        ),
      ),
    );
  }
}

class CollectionCard extends StatelessWidget {
  final String collection;
  final String imageUrl;

  const CollectionCard({
    super.key,
    required this.collection,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.go('/collections/${Uri.encodeComponent(collection).toLowerCase()}');
      },
      child: Stack(
        children: [
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(
                    imageUrl,
                  ),
                  fit: BoxFit.cover,
                ),
              ),
              child: Container(
                decoration: const BoxDecoration(
                  color: Color.fromRGBO(0, 0, 0, 0.7),
                ),
              ),
            ),
          ),
          Positioned.fill(
            child: Center(
              child: Text(
                collection,
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
