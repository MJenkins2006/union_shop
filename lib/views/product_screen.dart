import 'package:flutter/material.dart';
import 'package:union_shop/views/common_widgets.dart';
import 'package:union_shop/database.dart';

class ProductScreen extends StatefulWidget {
  final String collectionId;
  final String productId;
  const ProductScreen({super.key, required this.collectionId, required this.productId});

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header
            buildHeader(context),
            Text(widget.collectionId),
            Text(widget.productId),
            // Footer
            buildFooter(context),
          ],
        ),
      ),
    );
  }
}
