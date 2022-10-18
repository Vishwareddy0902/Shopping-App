import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/providers/cart.dart' show Cart;
import 'package:flutter_complete_guide/providers/orders.dart';
import 'package:provider/provider.dart';

import '../widgets/cart_item.dart';

class CartScreen extends StatelessWidget {
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
                      '₹${cart.totalAmount.toStringAsFixed(2).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}',
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
                  OrderNowButton(cart: cart)
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
                cart.items.values.toList()[index].imageUrl,
                cart.items.values.toList()[index].quantity)),
            itemCount: cart.getCount,
          ))
        ],
      ),
    );
  }
}

class OrderNowButton extends StatefulWidget {
  OrderNowButton({
    Key key,
    @required this.cart,
  }) : super(key: key);

  final Cart cart;

  @override
  State<OrderNowButton> createState() => _OrderNowButtonState();
}

class _OrderNowButtonState extends State<OrderNowButton> {
  bool _isLoading = false;

  bool noError = true;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      child: _isLoading
          ? CircularProgressIndicator()
          : Text('ORDER NOW',
              style: TextStyle(
                color: (widget.cart.totalAmount <= 0)
                    ? Colors.black38
                    : Colors.red,
              )),
      onPressed: (widget.cart.totalAmount <= 0 || _isLoading)
          ? null
          : () {
              setState(() {
                _isLoading = true;
              });
              Provider.of<Order>(context, listen: false)
                  .addOrder(widget.cart.totalAmount,
                      widget.cart.items.values.toList())
                  .catchError((error) {
                noError = false;
                return showDialog<Null>(
                    context: context,
                    builder: (context) => AlertDialog(
                          title: Text('ERROR!'),
                          icon: Icon(Icons.error),
                          iconColor: Theme.of(context).errorColor,
                          content: Text('Something went wrong'),
                          actions: [
                            TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: Text('Ok'))
                          ],
                        ));
              }).then((value) {
                setState(() {
                  _isLoading = false;
                });
                if (noError) widget.cart.clear();
              });
            },
    );
  }
}
