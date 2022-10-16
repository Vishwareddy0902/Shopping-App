import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/screens/orders_screen.dart';
import 'package:flutter_complete_guide/screens/user_products_screen.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          AppBar(
            automaticallyImplyLeading: false,
            title: Text(
              'Hello Friend',
              style: TextStyle(fontSize: 20),
            ),
          ),
          ListTile(
              leading: Icon(Icons.shop),
              title: Text('Shopping'),
              onTap: () {
                Navigator.popAndPushNamed(context, '/');
              }),
          Divider(),
          ListTile(
            leading: Icon(Icons.payment),
            title: Text('Orders'),
            onTap: () =>
                Navigator.popAndPushNamed(context, OrdersScreen.routeName),
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.edit),
            title: Text('Manage Products'),
            onTap: () =>
                Navigator.popAndPushNamed(context, UserProductScreen.routeName),
          ),
          Divider(),
        ],
      ),
    );
  }
}
