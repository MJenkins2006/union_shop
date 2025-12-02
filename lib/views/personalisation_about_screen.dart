import 'package:flutter/material.dart';
import 'package:union_shop/views/common_widgets.dart';
import 'package:go_router/go_router.dart';

class PersonalisationAboutScreen extends StatelessWidget {
  const PersonalisationAboutScreen({super.key});

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
              'Personalisation Service',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),

            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: const Text(
'''
At the Union Shop, we offer a personalisation service that allows you to add custom text to selected products. Whether you're looking to personalise a gift or create something unique for yourself, our service makes it easy and affordable.
''',
                style: TextStyle(fontSize: 16, height: 1.5),
                textAlign: TextAlign.left,
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
                onPressed: () => context.go('/personalisation'),
                child: const Text('Back to Personalisation')),
            // Footer
            buildFooter(context),
          ],
        ),
      ),
    );
  }
}
