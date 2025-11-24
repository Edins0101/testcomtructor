import 'package:flutter/material.dart';
import 'package:quickquote/modules/products/model/product_response.dart';

class QuoteItem {
  final ProductResponse product;
  int quantity;

  QuoteItem({
    required this.product,
    required this.quantity,
  });

  double get subtotal => product.price * quantity;
}

class QuoteProvider extends ChangeNotifier {
  ProductResponse? _selectedProduct;
  int _quantity = 1;
  final List<QuoteItem> _items = [];

  ProductResponse? get selectedProduct => _selectedProduct;
  int get quantity => _quantity;
  List<QuoteItem> get items => List.unmodifiable(_items);

  void selectProduct(ProductResponse product) {
    _selectedProduct = product;
    _quantity = 1;
    notifyListeners();
  }

  void incrementQuantity() {
    _quantity++;
    notifyListeners();
  }

  void decrementQuantity() {
    if (_quantity > 1) {
      _quantity--;
      notifyListeners();
    }
  }

  double get currentSubtotal {
    if (_selectedProduct == null) return 0;
    return _selectedProduct!.price * _quantity;
  }

  void addCurrentToQuote() {
    if (_selectedProduct == null) return;

    // Si ya existe en la lista, solo aumento la cantidad
    final index = _items.indexWhere(
      (item) => item.product.id == _selectedProduct!.id,
    );

    if (index != -1) {
      _items[index].quantity += _quantity;
    } else {
      _items.add(
        QuoteItem(product: _selectedProduct!, quantity: _quantity),
      );
    }

    notifyListeners();
  }

  void clearQuote() {
    _items.clear();
    notifyListeners();
  }
}
