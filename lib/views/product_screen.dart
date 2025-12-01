import 'package:flutter/material.dart';
import 'package:union_shop/views/common_widgets.dart';
import 'package:union_shop/database.dart';
import 'package:go_router/go_router.dart';

enum Sizes { S, M, L }

class ProductScreen extends StatefulWidget {
  final String collectionId;
  final String productId;
  const ProductScreen(
      {super.key, required this.collectionId, required this.productId});

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {

  List<DropdownMenuItem<Sizes>> _buildSizeEntries() {
    return [
      const DropdownMenuItem<Sizes>(
          value: Sizes.S, child: Text('S', style: TextStyle(fontSize: 14))),
      const DropdownMenuItem<Sizes>(
          value: Sizes.M, child: Text('M', style: TextStyle(fontSize: 14))),
      const DropdownMenuItem<Sizes>(
          value: Sizes.L, child: Text('L', style: TextStyle(fontSize: 14))),
    ];
  }

  Sizes? _selectedSize = Sizes.S;
  int _quantity = 1;
  final double _controlHeight = 36.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            buildHeader(context),
            for (var product in products)
              if (product['collection'] == widget.collectionId.toUpperCase() &&
                  product['product'] == widget.productId.toUpperCase())
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            alignment: Alignment.center,
                            width: double.infinity,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8.0),
                              child: Image.network(
                                product['imageUrl'] ?? '',
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Container(
                                    color: Colors.grey[300],
                                    height: 180,
                                    child: const Center(
                                      child: Icon(Icons.image_not_supported, color: Colors.grey),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(product['product'] ?? '',
                              style: const TextStyle(fontSize: 22), textAlign: TextAlign.left),
                          const SizedBox(height: 6),
                          Builder(builder: (context) {
                            final prices = product['price']?.split(' ') ?? [];
                            String oldPrices = '';
                            for (var i = 0; i < prices.length - 1; i++) {
                              oldPrices += '${prices[i]} ';
                            }
                            if (prices.length != 1) {
                              return Row(
                                children: [
                                  Text(
                                    '£$oldPrices',
                                    style: 
                                      const TextStyle(fontSize: 13, color: Colors.grey,
                                      decoration: TextDecoration.lineThrough,
                                    ),
                                  ),
                                  Text(
                                    '£${prices[prices.length - 1]}',
                                    style:
                                        const TextStyle(fontSize: 13, color: Colors.grey),
                                  ),
                                ],
                              );
                            } else {
                              return Text(
                                '£${product['price']}',
                                style: const TextStyle(fontSize: 13, color: Colors.grey),
                              );
                            }
                          }),
                          const SizedBox(height: 6),
                          const Text('Tax included.'),
                          const SizedBox(height: 12),

                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Text('Size: ', style: TextStyle(fontSize: 16)),
                              const SizedBox(width: 8),
                              Container(
                                height: _controlHeight,
                                width: 140,
                                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                                alignment: Alignment.centerLeft,
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey.shade400),
                                  borderRadius: BorderRadius.circular(6.0),
                                ),
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton<Sizes>(
                                    menuWidth: 140,
                                    value: _selectedSize,
                                    isExpanded: true,
                                    iconSize: 24,
                                    style: const TextStyle(fontSize: 14, color: Colors.black),
                                    items: _buildSizeEntries(),
                                    onChanged: (Sizes? value) {
                                      if (value != null) {
                                        setState(() {
                                          _selectedSize = value;
                                        });
                                      }
                                    },
                                  ),
                                ),
                              ),
                              const SizedBox(width: 16),
                              const Text('Quantity: ', style: TextStyle(fontSize: 16)),
                              const SizedBox(width: 8),
                              Container(
                                height: _controlHeight,
                                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey.shade400),
                                  borderRadius: BorderRadius.circular(6.0),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        setState(() {
                                          if (_quantity > 1) _quantity--;
                                        });
                                      },
                                      child: const Icon(Icons.remove, size: 18),
                                    ),
                                    const SizedBox(width: 8),
                                    Text('$_quantity', style: const TextStyle(fontSize: 14)),
                                    const SizedBox(width: 8),
                                    InkWell(
                                      onTap: () {
                                        setState(() {
                                          _quantity++;
                                        });
                                      },
                                      child: const Icon(Icons.add, size: 18),
                                    ),
                                  ],
                                ),
                              ),
                            ]
                          ),

                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () => print('Button pressed'),
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 64, vertical: 12.0),
                            ),
                            child: const Text('ADD TO CART')),

                          const SizedBox(height: 12),

                          Text(product['description'] ?? ''),
                        ],
                      ),
                    ),
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 24.0),
                child: ElevatedButton(
                  onPressed: () {
                    context.go('/collections/${widget.collectionId.toLowerCase()}');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF4d2963),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
                  ),
                  child: Text('Return to ${widget.collectionId}'),
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
