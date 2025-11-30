import 'package:flutter/material.dart';
import 'package:union_shop/views/common_widgets.dart';
import 'package:union_shop/database.dart';

class ProductScreen extends StatefulWidget {
  final String collectionId;
  final String productId;
  const ProductScreen(
      {super.key, required this.collectionId, required this.productId});

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
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
                          const Text('Tax included.')
                        ],
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
