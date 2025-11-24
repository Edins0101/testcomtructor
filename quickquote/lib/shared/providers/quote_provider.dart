import 'package:flutter/material.dart';
import 'package:quickquote/modules/products/model/product_response.dart';
import 'package:quickquote/modules/quotes/model/quote_response.dart';

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
  QuotePriority? _selectedQuote;
  int _quantity = 1;

  final List<QuoteItem> _items = [];

  ProductResponse? get selectedProduct => _selectedProduct;
  QuotePriority? get selectedQuote => _selectedQuote;
  int get quantity => _quantity;
  List<QuoteItem> get items => List.unmodifiable(_items);

  double get total =>
      _items.fold(0, (sum, item) => sum + item.subtotal);

  double get currentSubtotal {
    if (_selectedProduct == null) return 0;
    return _selectedProduct!.price * _quantity;
  }

  void selectProduct(ProductResponse product) {
    _selectedProduct = product;
    _quantity = 1;
    notifyListeners();
  }
  void selectQuote(QuotePriority quote) {
    _selectedQuote = quote;
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

  void addCurrentToQuote() {
    if (_selectedProduct == null || _quantity <= 0) return;

    final index = _items.indexWhere(
      (item) => item.product.id == _selectedProduct!.id,
    );

    if (index != -1) {
      _items[index].quantity += _quantity;
    } else {
      _items.add(
        QuoteItem(
          product: _selectedProduct!,
          quantity: _quantity,
        ),
      );
    }

    notifyListeners();
  }

  void removeItem(int productId) {
    _items.removeWhere((item) => item.product.id == productId);
    notifyListeners();
  }

  void clearQuote() {
    _items.clear();
    notifyListeners();
  }
}
