import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/providers/products.dart';
import 'package:flutter_complete_guide/widgets/product_item.dart';
import 'package:provider/provider.dart';

import '../models/product.dart';

class ProductGridView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<Products>(context);
    final loadedProducts = productsData.items;
    return GridView.builder(
      padding: EdgeInsets.all(10),
      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
        childAspectRatio: 3 / 2,
        crossAxisSpacing: 15,
        mainAxisSpacing: 20,
        maxCrossAxisExtent: 300,
      ),
      itemBuilder: (context, index) {
        return ProductItem(loadedProducts[index]);
      },
      itemCount: loadedProducts.length,
    );
  }
}
