import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/providers/products.dart';
import 'package:flutter_complete_guide/widgets/product_item.dart';
import 'package:provider/provider.dart';

class ProductGridView extends StatelessWidget {
  final bool showFavorites;
  ProductGridView(this.showFavorites);
  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<Products>(context);
    final loadedProducts =
        showFavorites ? productsData.favoriteList : productsData.items;
    return GridView.builder(
      padding: EdgeInsets.all(10),
      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
        childAspectRatio: 3 / 2,
        crossAxisSpacing: 5,
        mainAxisSpacing: 20,
        maxCrossAxisExtent: 300,
      ),
      itemBuilder: (context, index) {
        return ChangeNotifierProvider.value(
            value: loadedProducts[index], child: ProductItem());
      },
      itemCount: loadedProducts.length,
    );
  }
}
