import 'package:flutter/material.dart';
import 'package:union_shop/models/cart_model.dart';
import 'package:union_shop/views/common_widgets.dart';
import 'package:go_router/go_router.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final cart = CartModel.instance;

  @override
  void initState() {
    super.initState();
    cart.addListener(_onCartChanged);
  }

  @override
  void dispose() {
    cart.removeListener(_onCartChanged);
    super.dispose();
  }

  void _onCartChanged() => setState(() {});

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildHeader(context),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Your Cart', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  if (cart.isEmpty) ...[
                    const SizedBox(height: 40),
                    Center(
                      child: Column(
                        children: [
                          const Text('Your cart is empty.'),
                          const SizedBox(height: 12),
                          ElevatedButton(
                            onPressed: () => context.go('/'),
                            child: const Text('Continue shopping'),
                          ),
                        ],
                      ),
                    ),
                  ] else ...[
                    ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: cart.items.length,
                      separatorBuilder: (context, index) => const Divider(),
                      itemBuilder: (context, index) {
                        final item = cart.items[index];
                        return Semantics(
                          label: 'Cart item: ${item.name}',
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(item.name, style: const TextStyle(fontSize: 16)),
                                      const SizedBox(height: 6),
                                      if (item.color != null)
                                        Text(
                                          '${item.color}',
                                          style: const TextStyle(color: Colors.grey),
                                        ),
                                      if (item.size != null)
                                        Text(
                                          '${item.size}',
                                          style: const TextStyle(color: Colors.grey),
                                        ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text('£${item.price.toStringAsFixed(2)}'),
                                        const SizedBox(height: 4),
                                        Text(
                                          '£${item.lineTotal.toStringAsFixed(2)}',
                                          style: const TextStyle(fontSize: 12, color: Colors.grey),
                                        ),
                                        const SizedBox(height: 8),
                                    Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        IconButton(
                                          onPressed: () {
                                            setState(() {
                                              if (item.quantity > 1) {
                                                item.quantity--;
                                              } else {
                                                cart.removeItem(item);
                                              }
                                            });
                                          },
                                          icon: const Icon(Icons.remove_circle_outline),
                                          tooltip: 'Decrease quantity',
                                        ),
                                        Text('${item.quantity}'),
                                        IconButton(
                                          onPressed: () {
                                            setState(() {
                                              item.quantity++;
                                            });
                                          },
                                          icon: const Icon(Icons.add_circle_outline),
                                          tooltip: 'Increase quantity',
                                        ),
                                      ],
                                    ),
                                    IconButton(
                                      onPressed: () => cart.removeItem(item),
                                      icon: const Icon(Icons.delete_outline),
                                      tooltip: 'Remove',
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 12),
                    Align(
                      alignment: isMobile ? Alignment.center : Alignment.centerRight,
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(minWidth: 200, maxWidth: 420),
                        child: Card(
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text('Total', style: TextStyle(fontSize: 16)),
                                    Text('£${cart.total.toStringAsFixed(2)}', style: const TextStyle(fontSize: 16)),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                ElevatedButton(
                                  onPressed: () {
                                    final hadItems = !cart.isEmpty;
                                    cart.clear();
                                    if (hadItems) {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(content: Text('Checkout complete')),
                                      );
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 14)),
                                  child: const Text('Checkout'),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
            buildFooter(context),
          ],
        ),
      ),
    );
  }
}
