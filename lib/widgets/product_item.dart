import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/providers/product.dart';
import 'package:flutter_complete_guide/screens/product_detail_screen.dart';
import 'package:provider/provider.dart';

import '../providers/auth.dart';
import '../providers/cart.dart';

class ProductItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<Auth>(context, listen: false);
    final _product = Provider.of<Product>(context, listen: false);
    final _cart = Provider.of<Cart>(context, listen: false);
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Card(
        elevation: 10,
        child: GridTile(
          child: GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, ProductDetailScreen.routeName,
                  arguments: _product.id);
            },
            child: Image.network(
              _product.imageUrl,
              fit: BoxFit.contain,
            ),
          ),
          footer: GridTileBar(
            backgroundColor: Colors.black54,
            leading: IconButton(
              onPressed: () => _product
                  .toggleFavourite(auth.token, auth.getUserId)
                  .catchError((error) {
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text(
                    'Something went wrong',
                    textAlign: TextAlign.center,
                  ),
                  duration: Duration(seconds: 2),
                  //backgroundColor: Colors.blue,
                ));
              }),
              icon: Consumer<Product>(
                builder: (context, value, child) => Icon(_product.isFavourite
                    ? Icons.favorite
                    : Icons.favorite_border),
              ),
              color: Theme.of(context).colorScheme.secondary,
            ),
            title: Text(
              _product.title,
              style: TextStyle(fontSize: 10),
              maxLines: 2,
              textAlign: TextAlign.center,
            ),
            trailing: IconButton(
              onPressed: () {
                _cart.addItem(_product.id, _product.title, _product.price,
                    _product.imageUrl);
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text('${_product.title} added to Cart'),
                  duration: Duration(seconds: 2),
                  //backgroundColor: Colors.blue,
                  action: SnackBarAction(
                      label: 'UNDO',
                      onPressed: () {
                        _cart.deleteSingleProduct(_product.id);
                      }),
                ));
              },
              icon: Icon(Icons.shopping_cart),
              color: Theme.of(context).colorScheme.secondary,
            ),
          ),
        ),
      ),
    );
  }
}
