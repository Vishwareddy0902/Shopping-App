import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/providers/cart.dart';

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
  List<OrderItem> _list = [];
  List<OrderItem> get items {
    return [..._list];
  }

  void addOrder(double totalAmount, List<CartItem> cartList) {
    _list.insert(
        0,
        OrderItem(
            orderId: DateTime.now().toString(),
            totalAmount: totalAmount,
            list: cartList,
            dateTime: DateTime.now()));
    notifyListeners();
  }
}
