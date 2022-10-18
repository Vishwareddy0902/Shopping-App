import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/providers/orders.dart';
import 'package:flutter_complete_guide/widgets/app_drawer.dart';
import 'package:flutter_complete_guide/widgets/order_item.dart';
import 'package:provider/provider.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({Key key}) : super(key: key);

  static final String routeName = 'OrdersScreen';

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  bool _init = true;
  bool _isLoading = false;
  @override
  Future<void> didChangeDependencies() async {
    if (_init) {
      setState(() {
        _isLoading = true;
      });
      Provider.of<Order>(context, listen: false)
          .fetchAndSetOrders()
          .catchError((error) {})
          .then((value) {
        setState(() {
          _isLoading = false;
        });
      });
      _init = false;
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final orderData = Provider.of<Order>(context);
    return Scaffold(
        appBar: AppBar(
          title: Text('Your Orders'),
        ),
        drawer: AppDrawer(),
        body: _isLoading
            ? Center(child: CircularProgressIndicator())
            : ListView.builder(
                itemBuilder: ((context, index) =>
                    OrderTile(orderData.items[index])),
                itemCount: orderData.items.length,
              ));
  }
}
