import 'package:flutter_test/flutter_test.dart';
import 'package:union_shop/database.dart';

void main() {
	test('Collections structure', () {
		expect(collections, isNotEmpty);
		expect(collections.length, 3);

		for (final c in collections) {
			expect(c.containsKey('collection'), isTrue);
			expect(c.containsKey('description'), isTrue);
			expect(c.containsKey('imageUrl'), isTrue);
		}

		final names = collections.map((c) => c['collection']).toSet();
		expect(names, containsAll(['SALES', 'CARDS', 'CLOTHES']));
	});

	test('Products structure and content', () {
		expect(products, isNotEmpty);

		for (final p in products) {
			expect(p.containsKey('product'), isTrue);
			expect(p.containsKey('price'), isTrue);
			expect(p.containsKey('imageUrl'), isTrue);
			expect((p['product'] ?? '').isNotEmpty, isTrue);
		}
	});

	test('Filter products by collection', () {
		final sales = products.where((p) => p['collection'] == 'SALES').toList();
		expect(sales.length, 3);
		final productNames = sales.map((p) => p['product']).toSet();
		expect(productNames, containsAll(['ZIP-HOODIE', 'T-SHIRT', 'TROUSERS']));
	});

	test('ZIP-HOODIE has expected description and price', () {
		final zip = products.firstWhere((p) => p['product'] == 'ZIP-HOODIE');
		expect(zip, isNotNull);
		expect((zip['description'] ?? '').toLowerCase(), contains('cozy zip-up hoodie'));
		expect((zip['price'] ?? ''), contains('14.99'));
	});
}
