import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/providers/cart.dart' show Cart;
import 'package:flutter_complete_guide/providers/orders.dart';
import 'package:provider/provider.dart';

import '../widgets/cart_item.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({Key key}) : super(key: key);
  static final String routeName = 'CartScreen';

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Cart'),
      ),
      body: Column(
        children: [
          Card(
            margin: EdgeInsets.all(15),
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Row(
                children: [
                  Text(
                    'Total',
                    style: TextStyle(fontSize: 25, color: Colors.red),
                  ),
                  Spacer(),
                  Chip(
                    label: Text(
                      '\$${cart.totalAmount.toStringAsFixed(2)}',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    backgroundColor: Colors.blue,
                    padding: EdgeInsets.all(5),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  TextButton(
                    child: Text('ORDER NOW',
                        style: TextStyle(
                          color: Colors.red,
                        )),
                    onPressed: () {
                      Provider.of<Order>(context, listen: false).addOrder(
                          cart.totalAmount, cart.items.values.toList());
                      cart.clear();
                    },
                  )
                ],
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Expanded(
              child: ListView.builder(
            itemBuilder: ((context, index) => CartItem(
                cart.items.values.toList()[index].id,
                cart.items.keys.toList()[index],
                cart.items.values.toList()[index].price,
                cart.items.values.toList()[index].title,
                cart.items.values.toList()[index].quantity)),
            itemCount: cart.getCount,
          ))
        ],
      ),
    );
  }
}
