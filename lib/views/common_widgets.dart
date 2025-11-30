import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// Desktop-oriented header preserved from previous implementation.
Widget buildHeaderDesktop(BuildContext context) {
  void navigateToHome(BuildContext context) {
    context.go('/');
  }

  void navigateToProduct(BuildContext context) {
    context.go('/product');
  }
  void navigateToCollections(BuildContext context) {
    context.go('/collections');
  }
  void navigateToAbout(BuildContext context) {
    context.go('/about');
  }

  void placeholderCallbackForButtons() {
    // This is the event handler for buttons that don't work yet
    print('Button pressed');
  }

  return Container(
    height: 120,
    color: Colors.white,
    child: Column(
      children: [
        // Top banner
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 8),
          color: const Color(0xFF4d2963),
          child: const Text(
            'BIG SALE! OUR ESSENTIAL RANGE HAS DROPPED IN PRICE! OVER 20% OFF! COME GRAB YOURS WHILE STOCK LASTS!',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
        ),
        // Main header
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () {
                    navigateToHome(context);
                  },
                  child: Image.network(
                    'https://shop.upsu.net/cdn/shop/files/upsu_300x300.png?v=1614735854',
                    height: 18,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: Colors.grey[300],
                        width: 18,
                        height: 18,
                        child: const Center(
                          child: Icon(Icons.image_not_supported,
                              color: Colors.grey),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(width: 16),
                TextButton(
                    onPressed: () => navigateToHome(context),
                    child: const Text('Home')),
                const SizedBox(width: 16),
                TextButton(
                    onPressed: () => navigateToCollections(context),
                    child: const Text('Shop')),
                const SizedBox(width: 16),
                TextButton(
                    onPressed: () => placeholderCallbackForButtons(),
                    child: const Text('The Print Shack')),
                const SizedBox(width: 16),
                TextButton(
                    onPressed: () => context.go('/collections/sales'),
                    child: const Text('SALE!')),
                const SizedBox(width: 16),
                TextButton(
                    onPressed: () => navigateToAbout(context),
                    child: const Text('About')),
                const Spacer(),
                ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 600),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(
                          Icons.search,
                          size: 18,
                          color: Colors.grey,
                        ),
                        padding: const EdgeInsets.all(8),
                        constraints: const BoxConstraints(
                          minWidth: 32,
                          minHeight: 32,
                        ),
                        onPressed: placeholderCallbackForButtons,
                      ),
                      IconButton(
                        icon: const Icon(
                          Icons.person_outline,
                          size: 18,
                          color: Colors.grey,
                        ),
                        padding: const EdgeInsets.all(8),
                        constraints: const BoxConstraints(
                          minWidth: 32,
                          minHeight: 32,
                        ),
                        onPressed: placeholderCallbackForButtons,
                      ),
                      IconButton(
                        icon: const Icon(
                          Icons.shopping_bag_outlined,
                          size: 18,
                          color: Colors.grey,
                        ),
                        padding: const EdgeInsets.all(8),
                        constraints: const BoxConstraints(
                          minWidth: 32,
                          minHeight: 32,
                        ),
                        onPressed: placeholderCallbackForButtons,
                      ),
                      IconButton(
                        icon: const Icon(
                          Icons.menu,
                          size: 18,
                          color: Colors.grey,
                        ),
                        padding: const EdgeInsets.all(8),
                        constraints: const BoxConstraints(
                          minWidth: 32,
                          minHeight: 32,
                        ),
                        onPressed: placeholderCallbackForButtons,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}

// Mobile header implementation: compact logo + hamburger that opens a modal drawer.
Widget buildHeaderMobile(BuildContext context) {
  void navigateToHome(BuildContext context) {
    context.go('/');
  }

  void navigateToProduct(BuildContext context) {
    context.go('/product');
  }

  void navigateToCollections(BuildContext context) {
    context.go('/collections');
  }

  void navigateToAbout(BuildContext context) {
    context.go('/about');
  }

  void placeholderCallbackForButtons() {
    print('Button pressed');
  }

  return Container(
    color: Colors.white,
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Banner scaled down
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
          color: const Color(0xFF4d2963),
          child: const FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              'BIG SALE! OUR ESSENTIAL RANGE HAS DROPPED IN PRICE! OVER 20% OFF!',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white, fontSize: 14),
            ),
          ),
        ),
        // Main row with hamburger and compact logo
        Container(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
          child: Row(
            children: [
              const SizedBox(width: 8),
              GestureDetector(
                onTap: () => navigateToHome(context),
                child: SizedBox(
                  width: 44,
                  height: 44,
                  child: Image.network(
                    'https://shop.upsu.net/cdn/shop/files/upsu_300x300.png?v=1614735854',
                    fit: BoxFit.contain,
                    errorBuilder: (c, e, s) => Container(
                      color: Colors.grey[300],
                      width: 44,
                      height: 44,
                      child: const Icon(Icons.image_not_supported),
                    ),
                  ),
                ),
              ),
              const Spacer(),
              // Keep action icons visible outside the drawer on mobile (accessible, >=44x44)
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: 44,
                    height: 44,
                    child: IconButton(
                      icon: const Icon(Icons.search),
                      onPressed: placeholderCallbackForButtons,
                      tooltip: 'Search',
                      padding: const EdgeInsets.all(8),
                      constraints:
                          const BoxConstraints(minWidth: 44, minHeight: 44),
                    ),
                  ),
                  SizedBox(
                    width: 44,
                    height: 44,
                    child: IconButton(
                      icon: const Icon(Icons.person_outline),
                      onPressed: placeholderCallbackForButtons,
                      tooltip: 'Account',
                      padding: const EdgeInsets.all(8),
                      constraints:
                          const BoxConstraints(minWidth: 44, minHeight: 44),
                    ),
                  ),
                  SizedBox(
                    width: 44,
                    height: 44,
                    child: IconButton(
                      icon: const Icon(Icons.shopping_bag_outlined),
                      onPressed: placeholderCallbackForButtons,
                      tooltip: 'Bag',
                      padding: const EdgeInsets.all(8),
                      constraints:
                          const BoxConstraints(minWidth: 44, minHeight: 44),
                    ),
                  ),
                  SizedBox(
                    width: 44,
                    height: 44,
                    child: IconButton(
                      icon: const Icon(Icons.menu),
                      onPressed: () {
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          builder: (ctx) {
                            return SafeArea(
                              child: SingleChildScrollView(
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Divider(),
                                      ListTile(
                                        title: const Text('Home'),
                                        onTap: () {
                                          Navigator.pop(ctx);
                                          navigateToHome(context);
                                        },
                                      ),
                                      ListTile(
                                        title: const Text('Shop'),
                                        onTap: () {
                                          Navigator.pop(ctx);
                                          navigateToCollections(context);
                                        },
                                      ),
                                      ListTile(
                                        title: const Text('The Print Shack'),
                                        onTap: () {
                                          Navigator.pop(ctx);
                                          placeholderCallbackForButtons();
                                        },
                                      ),
                                      ListTile(
                                        title: const Text('SALE!'),
                                        onTap: () {
                                          Navigator.pop(ctx);
                                          context.go('/collections/sales');
                                        },
                                      ),
                                      ListTile(
                                        title: const Text('About'),
                                        onTap: () {
                                          Navigator.pop(ctx);
                                          navigateToAbout(context);
                                        },
                                      ),
                                      const SizedBox(height: 16),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

// Responsive wrapper: preserves desktop for width >= 600, mobile otherwise.
Widget buildHeader(BuildContext context) {
  final width = MediaQuery.of(context).size.width;
  if (width >= 600) {
    return buildHeaderDesktop(context);
  }
  return buildHeaderMobile(context);
}

// Desktop footer preserved as the original layout.
Widget buildFooterDesktop(BuildContext context) {
  void placeholderCallbackForButtons() {}

  return Container(
    padding: const EdgeInsets.all(16),
    width: double.infinity,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Column(children: [
              Text("""
Opening Hours

❄️ Winter Break Closure Dates ❄️
Closing 4pm 19/12/2025
Reopening 10am 05/01/2026
Last post date: 12pm on 18/12/2025
------------------------
(Term Time)
Monday - Friday 10am - 4pm
(Outside of Term Time / Consolidation Weeks)
Monday - Friday 10am - 3pm
Purchase online 24/7
"""),
            ]),
            const Column(children: [
              Text("""
Search

Terms & Conditions of Sale Policy
""")
            ]),
            Column(children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Latest Offers'),
                  const SizedBox(
                    width: 150,
                    child: TextField(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Email Address',
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: placeholderCallbackForButtons,
                    child: const Text('SUBSCRIBE'),
                  ),
                ],
              )
            ]),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            GestureDetector(
              onTap: placeholderCallbackForButtons,
              child: Image.network(
                'https://cdn-icons-png.flaticon.com/512/733/733547.png',
                width: 28,
                height: 28,
                fit: BoxFit.contain,
                errorBuilder: (c, e, s) => Container(
                  width: 28,
                  height: 28,
                  color: Colors.grey[300],
                  child: const Icon(Icons.facebook, size: 18),
                ),
              ),
            ),
            const SizedBox(width: 12),
            GestureDetector(
              onTap: placeholderCallbackForButtons,
              child: Image.network(
                'https://cdn-icons-png.flaticon.com/512/733/733579.png',
                width: 28,
                height: 28,
                fit: BoxFit.contain,
                errorBuilder: (c, e, s) => Container(
                  width: 28,
                  height: 28,
                  color: Colors.grey[300],
                  child: const Icon(Icons.alternate_email, size: 18),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        const Text(
          '© 2025, upsu-store Powered by Shopify',
          style: TextStyle(fontSize: 12),
          textAlign: TextAlign.start,
        ),
      ],
    ),
  );
}

// Mobile footer: stacked columns, subscription input expands full width, scrollable if needed.
Widget buildFooterMobile(BuildContext context) {
  void placeholderCallbackForButtons() {}

  return Container(
    padding: const EdgeInsets.all(12),
    width: double.infinity,
    child: SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.symmetric(vertical: 8),
            child: const Text(
              """
Opening Hours

❄️ Winter Break Closure Dates ❄️
Closing 4pm 19/12/2025
Reopening 10am 05/01/2026
Last post date: 12pm on 18/12/2025
------------------------
(Term Time)
Monday - Friday 10am - 4pm
(Outside of Term Time / Consolidation Weeks)
Monday - Friday 10am - 3pm
Purchase online 24/7
""",
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(vertical: 8),
            child: const Text("""
Search

Terms & Conditions of Sale Policy
"""),
          ),
          Container(
            margin: const EdgeInsets.symmetric(vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Latest Offers'),
                const SizedBox(height: 8),
                const TextField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Email Address',
                  ),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: placeholderCallbackForButtons,
                    child: const Text('SUBSCRIBE'),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              GestureDetector(
                onTap: placeholderCallbackForButtons,
                child: Image.network(
                  'https://cdn-icons-png.flaticon.com/512/733/733547.png',
                  width: 28,
                  height: 28,
                  fit: BoxFit.contain,
                  errorBuilder: (c, e, s) => Container(
                    width: 28,
                    height: 28,
                    color: Colors.grey[300],
                    child: const Icon(Icons.facebook, size: 18),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              GestureDetector(
                onTap: placeholderCallbackForButtons,
                child: Image.network(
                  'https://cdn-icons-png.flaticon.com/512/733/733579.png',
                  width: 28,
                  height: 28,
                  fit: BoxFit.contain,
                  errorBuilder: (c, e, s) => Container(
                    width: 28,
                    height: 28,
                    color: Colors.grey[300],
                    child: const Icon(Icons.alternate_email, size: 18),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Text(
            '© 2025, upsu-store Powered by Shopify',
            style: TextStyle(fontSize: 12),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    ),
  );
}

// Responsive footer wrapper: desktop for width >= 600, mobile otherwise.
Widget buildFooter(BuildContext context) {
  final width = MediaQuery.of(context).size.width;
  if (width >= 700) {
    return buildFooterDesktop(context);
  }
  return buildFooterMobile(context);
}

class ProductCard extends StatelessWidget {
  final String product;
  final String price;
  final String imageUrl;
  final String collection;

  const ProductCard({
    super.key,
    required this.product,
    required this.price,
    required this.imageUrl,
    required this.collection,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.go('/collections/$collection/$product');
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Image.network(
              imageUrl,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  color: Colors.grey[300],
                  child: const Center(
                    child: Icon(Icons.image_not_supported, color: Colors.grey),
                  ),
                );
              },
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 4),
              Text(
                product,
                style: const TextStyle(fontSize: 14, color: Colors.black),
                maxLines: 2,
              ),
              const SizedBox(height: 4),
              // Strikethrough on multiple values
              Builder(builder: (context) {
                final prices = price.split(' ');
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
                    '£$price',
                    style: const TextStyle(fontSize: 13, color: Colors.grey),
                  );
                }
              }),
            ],
          ),
        ],
      ),
    );
  }
}
