import 'package:flutter/material.dart';

import '../widgets/product_grid.dart';

class ProductOverviewScreen extends StatelessWidget {
  static const routeName = '/';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Dukkan')),
      body: ProductsGrid(),
    );
  }
}
