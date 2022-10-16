import 'package:flutter/material.dart';

class CartItem {
  final String id;
  final String title;
  final double price;
  final String imageUrl;
  final int quantity;
  CartItem({
    @required this.id,
    @required this.title,
    @required this.price,
    @required this.imageUrl,
    @required this.quantity,
  });
}

class Cart with ChangeNotifier {
  Map<String, CartItem> _items = {};

  Map<String, CartItem> get items {
    return {..._items};
  }

  void addItem(String productId, String title, double price, String imageUrl) {
    if (_items.containsKey(productId)) {
      _items.update(
          productId,
          (existingCartItem) => CartItem(
              id: existingCartItem.id,
              title: existingCartItem.title,
              price: existingCartItem.price,
              imageUrl: existingCartItem.imageUrl,
              quantity: existingCartItem.quantity + 1));
    } else {
      _items.putIfAbsent(
          productId,
          () => CartItem(
              id: DateTime.now().toString(),
              title: title,
              price: price,
              imageUrl: imageUrl,
              quantity: 1));
    }
    notifyListeners();
  }

  int get getCount {
    return _items.length;
  }

  double get totalAmount {
    double total = 0.0;
    _items.forEach((key, value) {
      total += (value.price * value.quantity);
    });
    return total;
  }

  void deleteCartItem(String productId) {
    _items.remove(productId);
    notifyListeners();
  }

  void deleteSingleProduct(String productId) {
    if (!_items.containsKey(productId)) {
      return;
    }
    if (_items[productId].quantity > 1) {
      _items.update(
          productId,
          (existingProd) => CartItem(
              id: existingProd.id,
              title: existingProd.title,
              price: existingProd.price,
              imageUrl: existingProd.imageUrl,
              quantity: existingProd.quantity - 1));
    } else {
      _items.remove(productId);
    }
    notifyListeners();
  }

  void clear() {
    _items = {};
    notifyListeners();
  }
}
