import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/models/product.dart';
import 'package:flutter_complete_guide/screens/product_detail_screen.dart';

class ProductItem extends StatelessWidget {
  final Product _product;

  ProductItem(this._product);

  @override
  Widget build(BuildContext context) {
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
              fit: BoxFit.cover,
            ),
          ),
          footer: GridTileBar(
            backgroundColor: Colors.black54,
            leading: IconButton(
              onPressed: () {},
              icon: Icon(Icons.favorite),
              color: Theme.of(context).colorScheme.secondary,
            ),
            title: Text(_product.title),
            trailing: IconButton(
              onPressed: () {},
              icon: Icon(Icons.shopping_cart),
              color: Theme.of(context).colorScheme.secondary,
            ),
          ),
        ),
      ),
    );
  }
}
