import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_complete_guide/screens/edit_product_screen.dart';
import 'package:provider/provider.dart';

import '../providers/product.dart';
import '../providers/products.dart';

class UserProductItem extends StatelessWidget {
  final Product _product;
  UserProductItem(this._product);
  @override
  Widget build(BuildContext context) {
    return Card(
        margin: EdgeInsets.symmetric(horizontal: 15, vertical: 4),
        child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: ListTile(
              leading: CircleAvatar(
                //minRadius: 0,
                backgroundImage: NetworkImage(_product.imageUrl),
              ),
              title: Text(_product.title),
              subtitle: Text(
                  'Price:-₹${(_product.price).toStringAsFixed(2).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}'),
              trailing: Container(
                width: 100,
                child: Row(
                  children: [
                    IconButton(
                        onPressed: () {
                          Navigator.pushNamed(
                              context, EditProductScreen.routeName,
                              arguments: _product.id);
                        },
                        icon: Icon(
                          Icons.edit,
                          color: Theme.of(context).primaryColor,
                        )),
                    IconButton(
                        onPressed: () {
                          Provider.of<Products>(context, listen: false)
                              .deleteProduct(_product.id)
                              .catchError((error) {
                            ScaffoldMessenger.of(context).hideCurrentSnackBar();
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text(
                                'Unable to Delete',
                                textAlign: TextAlign.center,
                              ),
                              duration: Duration(seconds: 2),
                            ));
                          });
                        },
                        icon: Icon(
                          Icons.delete,
                          color: Theme.of(context).errorColor,
                        )),
                  ],
                ),
              ),
            )));
  }
}
