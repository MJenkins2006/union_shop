import 'package:flutter/foundation.dart';

class CartItem {
  final String name;
  final double price;
  final String? color;
  final String? size;
  int quantity;

  CartItem({
    required this.name,
    required this.price,
    this.color,
    this.size,
    this.quantity = 1,
  });

  double get lineTotal => price * quantity;
}

class CartModel extends ChangeNotifier {
  CartModel._privateConstructor();

  static final CartModel instance = CartModel._privateConstructor();

  final List<CartItem> _items = [];

  List<CartItem> get items => List.unmodifiable(_items);

  void addItem(CartItem item) {
    _items.add(item);
    notifyListeners();
  }

  void removeItem(CartItem item) {
    _items.remove(item);
    notifyListeners();
  }

  void clear() {
    _items.clear();
    notifyListeners();
  }

  double get total {
    double sum = 0.0;
    for (final item in _items) {
      sum += item.lineTotal;
    }
    return sum;
  }

  bool get isEmpty => _items.isEmpty;
}
