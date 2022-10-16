import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

import '../providers/product.dart';

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
                        onPressed: () {},
                        icon: Icon(
                          Icons.edit,
                          color: Theme.of(context).primaryColor,
                        )),
                    IconButton(
                        onPressed: () {},
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
