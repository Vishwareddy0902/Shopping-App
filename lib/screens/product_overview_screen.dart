import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/models/product.dart';
import 'package:flutter_complete_guide/widgets/product_item.dart';

import '../widgets/product_gridview.dart';

class ProductOverviewScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('My Shop'),
        ),
        body: ProductGridView());
  }
}
