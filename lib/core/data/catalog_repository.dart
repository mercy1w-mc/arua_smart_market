import 'package:flutter/foundation.dart';

import '../../shared/models/product.dart';

/// Client-side repository seam for the product catalog.
///
/// The local implementation keeps the app usable before a backend is connected.
/// It can later be replaced with an authenticated HTTP/API implementation without
/// moving catalog logic into widgets.
class CatalogRepository extends ChangeNotifier {
  CatalogRepository._() : _products = List<Product>.of(demoProducts);

  static final CatalogRepository instance = CatalogRepository._();

  final List<Product> _products;
  int _nextProductId = 1;

  List<Product> get products => List<Product>.unmodifiable(_products);

  Future<Product> createProduct(Product draft) async {
    await Future<void>.delayed(const Duration(milliseconds: 250));
    final product = Product(
      id: 'local-${_nextProductId++}',
      name: draft.name,
      category: draft.category,
      price: draft.price,
      unit: draft.unit,
      farmer: draft.farmer,
      location: draft.location,
      imageUrl: draft.imageUrl,
      stock: draft.stock,
      description: draft.description,
      isFeatured: false,
    );
    _products.insert(0, product);
    notifyListeners();
    return product;
  }
}