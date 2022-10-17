import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/providers/products.dart';
import 'package:flutter_complete_guide/screens/edit_product_screen.dart';
import 'package:flutter_complete_guide/widgets/app_drawer.dart';
import 'package:flutter_complete_guide/widgets/user_product_item.dart';
import 'package:provider/provider.dart';

class UserProductScreen extends StatelessWidget {
  const UserProductScreen({Key key}) : super(key: key);
  static final String routeName = 'UserProductScreen';

  @override
  Widget build(BuildContext context) {
    Future<void> _refreshScreen() {
      return Provider.of<Products>(context, listen: false)
          .fetchAndSetData()
          .then((value) {});
    }

    final products = Provider.of<Products>(context);
    return Scaffold(
        appBar: AppBar(
          title: Text('Your Products'),
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.pushNamed(context, EditProductScreen.routeName);
                },
                icon: Icon(Icons.add))
          ],
        ),
        drawer: AppDrawer(),
        body: RefreshIndicator(
          onRefresh: () => _refreshScreen(),
          child: Padding(
            padding: EdgeInsets.all(1),
            child: Expanded(
                child: ListView.builder(
              itemBuilder: (context, index) =>
                  UserProductItem(products.items[index]),
              itemCount: products.items.length,
            )),
          ),
        ));
  }
}
