import 'package:flutter_test/flutter_test.dart';
import 'package:union_shop/models/cart_model.dart';

void main() {
	final cart = CartModel.instance;

	setUp(() {
		cart.clear();
	});

	test('starts empty', () {
		expect(cart.isEmpty, isTrue);
		expect(cart.items.length, 0);
		expect(cart.total, equals(0.0));
	});

	test('adding an item increases items and updates total', () {
		final item = CartItem(name: 'T-shirt', price: 10.0);
		cart.addItem(item);

		expect(cart.isEmpty, isFalse);
		expect(cart.items.length, 1);
		expect(cart.items.first.name, 'T-shirt');
		expect(cart.total, equals(10.0));
	});

	test('removing an item updates items and total', () {
		final a = CartItem(name: 'Sock', price: 3.0, quantity: 2);
		final b = CartItem(name: 'Hat', price: 5.0);
		cart.addItem(a);
		cart.addItem(b);

		expect(cart.items.length, 2);
		expect(cart.total, equals(3.0 * 2 + 5.0));

		cart.removeItem(a);
		expect(cart.items.length, 1);
		expect(cart.items.first.name, 'Hat');
		expect(cart.total, equals(5.0));
	});

	test('clear empties the cart', () {
		cart.addItem(CartItem(name: 'One', price: 1.0));
		cart.addItem(CartItem(name: 'Two', price: 2.0));
		expect(cart.items.isNotEmpty, isTrue);

		cart.clear();
		expect(cart.isEmpty, isTrue);
		expect(cart.items.length, 0);
		expect(cart.total, equals(0.0));
	});

	test('CartItem.lineTotal multiplies price by quantity', () {
		final it = CartItem(name: 'Bulk', price: 2.5, quantity: 3);
		expect(it.lineTotal, equals(7.5));
	});

	test('items getter returns unmodifiable list', () {
		cart.addItem(CartItem(name: 'Immutable', price: 1.0));
		expect(() => cart.items.add(CartItem(name: 'X', price: 1.0)), throwsUnsupportedError);
	});
}
