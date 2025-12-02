import 'package:flutter/material.dart';
import 'package:union_shop/views/common_widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:union_shop/models/cart_model.dart';

enum LineCount { one, two , three, four }

class PersonalisationScreen extends StatefulWidget {
  const PersonalisationScreen({super.key});

  @override
  State<PersonalisationScreen> createState() => _PersonalisationScreenState();
}

class _PersonalisationScreenState extends State<PersonalisationScreen> {

  LineCount _selectedLineCount = LineCount.one;

  // Controllers for each potential line of personalisation (max 4)
  final List<TextEditingController> _lineControllers = List.generate(
    4,
    (_) => TextEditingController(),
  );

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    for (final controller in _lineControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  List<DropdownMenuItem<LineCount>> _buildLineCountEntries() {
    return [
      const DropdownMenuItem<LineCount>(
          value: LineCount.one, child: Text('One', style: TextStyle(fontSize: 14))),
      const DropdownMenuItem<LineCount>(
          value: LineCount.two, child: Text('Two', style: TextStyle(fontSize: 14))),
      const DropdownMenuItem<LineCount>(
          value: LineCount.three, child: Text('Three', style: TextStyle(fontSize: 14))),
      const DropdownMenuItem<LineCount>(
          value: LineCount.four, child: Text('Four', style: TextStyle(fontSize: 14))),
    ];
  }

  double getTotal() {
    return (1.0 + (2.0 * (_selectedLineCount.index + 1))) * _quantity;
  }

  int _quantity = 1;
  final double _controlHeight = 36.0;

  Widget _buildLineEntryFields() {
    final int count = _selectedLineCount.index + 1;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(count, (i) {
        return Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: TextField(
            controller: _lineControllers[i],
            decoration: InputDecoration(
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(6.0)),
              labelText: 'Line ${i + 1}',
              hintText: 'Enter text for line ${i + 1}',
              contentPadding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 10.0),
            ),
            maxLines: 1,
            maxLength: 10,
          ),
        );
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            buildHeader(context),
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
                                'https://shop.upsu.net/cdn/shop/products/Personalised_Image_720x.jpg?v=1562949869',
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
                          const Text('Personalisation',
                              style: TextStyle(fontSize: 22), textAlign: TextAlign.left),
                          const SizedBox(height: 6),
                          const Text('£1.00 + £2/line',
                              style: TextStyle(
                                  fontSize: 13, fontWeight: FontWeight.bold, color: Colors.grey)),
                          const SizedBox(height: 6),
                          const Text('Tax included.'),
                          const SizedBox(height: 12),
                          ElevatedButton(
                            onPressed: () => context.go('/personalisation/about'),
                            child: const Text('Find out more!')),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              const Text('Number of lines: ', style: TextStyle(fontSize: 16)),
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
                                  child: DropdownButton<LineCount>(
                                    value: _selectedLineCount,
                                    isExpanded: true,
                                    iconSize: 24,
                                    style: const TextStyle(fontSize: 14, color: Colors.black),
                                    items: _buildLineCountEntries(),
                                    onChanged: (LineCount? value) {
                                      if (value != null) {
                                        setState(() {
                                          _selectedLineCount = value;
                                        });
                                      }
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
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

                          // Entry boxes for each selected line
                          Padding(
                            padding: const EdgeInsets.only(top: 12.0),
                            child: _buildLineEntryFields(),
                          ),

                          ElevatedButton(
                            onPressed: () {
                              final cartItem = CartItem(
                                name: 'Personalised Item',
                                price: getTotal(),
                                quantity: _quantity,
                              );
                              CartModel.instance.addItem(cartItem);
                              context.go('/cart');
                            },                           style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 64, vertical: 12.0),
                            ),
                            child: Text('ADD £${getTotal()} TO CART'),
                          ),

                          const SizedBox(height: 12),

                          const Text(
"""
Please ensure all spellings are correct before submitting your purchase.
"""
                          ),
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
