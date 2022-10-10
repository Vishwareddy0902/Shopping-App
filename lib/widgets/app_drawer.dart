import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_complete_guide/screens/orders_screen.dart';

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
            onTap: () => Navigator.pushNamed(context, '/'),
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.payment),
            title: Text('Orders'),
            onTap: () => Navigator.pushNamed(context, OrdersScreen.routeName),
          ),
          Divider(),
        ],
      ),
    );
  }
}
