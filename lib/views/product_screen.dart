import 'package:flutter/material.dart';
import 'package:union_shop/views/common_widgets.dart';
import 'package:union_shop/models/cart_model.dart';
import 'package:union_shop/database.dart';
import 'package:go_router/go_router.dart';

class ProductScreen extends StatefulWidget {
  final String collectionId;
  final String productId;
  const ProductScreen(
      {super.key, required this.collectionId, required this.productId});

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {

  List<DropdownMenuItem<String>> _buildColourEntries(List<String> colours) {
    return colours
        .map((colour) => DropdownMenuItem<String>(
            value: colour, child: Text(colour, style: const TextStyle(fontSize: 14))))
        .toList();
  }

  List<DropdownMenuItem<String>> _buildSizeEntries(List<String> sizes) {
    return sizes
        .map((size) => DropdownMenuItem<String>(
            value: size, child: Text(size, style: const TextStyle(fontSize: 14))))
        .toList();
  }

  double getTotal() {
    for (var product in products) {
      if (product['collection'] == widget.collectionId.toUpperCase() &&
          product['product'] == widget.productId.toUpperCase()) {
        final price = double.parse(product['price']?.split(' ').last ?? '0');
        final total = price * _quantity;
        return total;
      }
    }
    return 0.0;
  }

  String? _selectedColour;
  String? _selectedSize;
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
                              Builder(builder: (context) {
                                final coloursList = (product['colours'] ?? '')
                                    .split(',')
                                    .map((size) => size.trim())
                                    .where((size) => size.isNotEmpty)
                                    .toList();

                                if (coloursList.isEmpty) {
                                  return const Text('');
                                }

                                return Row(
                                  children: [
                                    const Text('Colour: ', style: TextStyle(fontSize: 16)),
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
                                        child: DropdownButton<String>(
                                          menuWidth: 140,
                                          value: _selectedColour ?? coloursList[0],
                                          isExpanded: true,
                                          iconSize: 24,
                                          style: const TextStyle(fontSize: 14, color: Colors.black),
                                          items: _buildColourEntries(coloursList),
                                          onChanged: (String? value) {
                                            if (value != null) {
                                              setState(() {
                                                _selectedColour = value;
                                              });
                                            }
                                          },
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              }),
                            ]
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Builder(builder: (context) {
                                final sizesList = (product['sizes'] ?? '')
                                    .split(',')
                                    .map((size) => size.trim())
                                    .where((size) => size.isNotEmpty)
                                    .toList();

                                if (sizesList.isEmpty) {
                                  return const Text('');
                                }

                                return Row(
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
                                        child: DropdownButton<String>(
                                          menuWidth: 140,
                                          value: _selectedSize ?? sizesList[0],
                                          isExpanded: true,
                                          iconSize: 24,
                                          style: const TextStyle(fontSize: 14, color: Colors.black),
                                          items: _buildSizeEntries(sizesList),
                                          onChanged: (String? value) {
                                            if (value != null) {
                                              setState(() {
                                                _selectedSize = value;
                                              });
                                            }
                                          },
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              }),
                            ]
                          ),
                          Row(
                            children: [
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
                          ElevatedButton(
                            onPressed: () {
                              // add to cart and navigate to cart screen
                              final unitPrice = double.parse(product['price']?.split(' ').last ?? '0');

                              // derive available colours/sizes from product data
                              final coloursList = (product['colours'] ?? '')
                                  .split(',')
                                  .map((c) => c.trim())
                                  .where((c) => c.isNotEmpty)
                                  .toList();
                              final sizesList = (product['sizes'] ?? '')
                                  .split(',')
                                  .map((s) => s.trim())
                                  .where((s) => s.isNotEmpty)
                                  .toList();

                              final selectedColour = _selectedColour ?? (coloursList.isNotEmpty ? coloursList[0] : null);
                              final selectedSize = _selectedSize ?? (sizesList.isNotEmpty ? sizesList[0] : null);

                              final cartItem = CartItem(
                                name: product['product'] ?? '',
                                price: unitPrice,
                                color: selectedColour,
                                size: selectedSize,
                                quantity: _quantity,
                              );
                              CartModel.instance.addItem(cartItem);
                              context.go('/cart');
                            },
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 64, vertical: 12.0),
                            ),
                            child: Text('ADD £${getTotal()} TO CART'),
                          ),

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
