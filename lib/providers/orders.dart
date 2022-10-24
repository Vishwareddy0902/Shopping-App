import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/providers/cart.dart';
import 'package:http/http.dart' as http;

class OrderItem {
  final String orderId;
  final double totalAmount;
  final List<CartItem> list;
  final DateTime dateTime;

  OrderItem(
      {@required this.orderId,
      @required this.totalAmount,
      @required this.list,
      @required this.dateTime});
}

class Order with ChangeNotifier {
  String token;
  String userId;
  List<OrderItem> _list = [];
  Order(this.token, this.userId, this._list);
  List<OrderItem> get items {
    return [..._list];
  }

  Future<void> fetchAndSetOrders() {
    final url = Uri.parse(
        'https://shopping-app-c8efa-default-rtdb.firebaseio.com/orders/$userId.json?auth=$token');

    return http.get(url).then((Response) {
      final extractedData = json.decode(Response.body) as Map<String, dynamic>;
      List<OrderItem> _loadedProducts = [];
      if (extractedData == null) return;

      extractedData.forEach((orderId, orderData) {
        _loadedProducts.add(OrderItem(
            orderId: orderId,
            totalAmount: orderData['totalAmount'],
            list: (orderData['list'] as List<dynamic>)
                .map((cart) => CartItem(
                    id: cart['id'],
                    title: cart['title'],
                    price: cart['price'],
                    imageUrl: cart['imageUrl'],
                    quantity: cart['quantity']))
                .toList(),
            dateTime: DateTime.parse(orderData['dateTime'])));

        _list = _loadedProducts;
        notifyListeners();
      });
    }).catchError((error) {
      throw error;
    });
  }

  Future<void> addOrder(double totalAmount, List<CartItem> cartList) async {
    final url = Uri.parse(
        'https://shopping-app-c8efa-default-rtdb.firebaseio.com/orders/$userId.json?auth=$token');

    return http
        .post(url,
            body: json.encode({
              'totalAmount': totalAmount,
              'dateTime': DateTime.now().toIso8601String(),
              'list': cartList
                  .map((cart) => {
                        'id': cart.id,
                        'title': cart.title,
                        'price': cart.price,
                        'imageUrl': cart.imageUrl,
                        'quantity': cart.quantity,
                      })
                  .toList()
            }))
        .then((response) {
      _list.insert(
          0,
          OrderItem(
              orderId: json.decode(response.body)['name'],
              totalAmount: totalAmount,
              list: cartList,
              dateTime: DateTime.now()));
      notifyListeners();
    }).catchError((error) {
      throw error;
    });
  }
}
