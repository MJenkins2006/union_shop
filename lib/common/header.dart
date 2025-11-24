import 'package:flutter/material.dart';

Widget buildHeader(BuildContext context) {
  void navigateToHome(BuildContext context) {
    Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
  }

  void navigateToProduct(BuildContext context) {
    Navigator.pushNamed(context, '/product');
  }

  void navigateToAbout(BuildContext context) {
    Navigator.pushNamed(context, '/about');
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
                    onPressed: () => placeholderCallbackForButtons(),
                    child: const Text('Shop')),
                const SizedBox(width: 16),
                TextButton(
                    onPressed: () => placeholderCallbackForButtons(),
                    child: const Text('The Print Shack')),
                const SizedBox(width: 16),
                TextButton(
                    onPressed: () => placeholderCallbackForButtons(),
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
