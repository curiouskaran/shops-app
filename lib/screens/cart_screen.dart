import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/cart.dart' show Cart;
import '../widgets/cart_item.dart';

class CartScreen extends StatelessWidget {
  static const routeName = '/cart';
  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Cart'),
      ),
      body: cart.itemCount != 0
          ? Column(
              children: <Widget>[
                Card(
                  margin: EdgeInsets.all(15),
                  child: Padding(
                    padding: EdgeInsets.all(10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          'Total',
                          style: TextStyle(fontSize: 25),
                        ),
                        Spacer(),
                        Chip(
                          label: Text(
                            '${cart.totalAmount.toString()} ₹',
                            style: TextStyle(
                                color: Theme.of(context)
                                    .primaryTextTheme
                                    .title
                                    .color),
                          ),
                          backgroundColor: Theme.of(context).primaryColor,
                        ),
                        FlatButton(
                            onPressed: () {},
                            child: Text(
                              'ORDER NOW',
                              style: TextStyle(
                                  color: Theme.of(context).primaryColor),
                            ))
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Expanded(
                    child: ListView.builder(
                  itemBuilder: (ctx, i) => CartItem(
                    id: cart.items.values.toList()[i].id,
                    title: cart.items.values.toList()[i].title,
                    quantity: cart.items.values.toList()[i].quantity,
                    price: cart.items.values.toList()[i].price,
                    productId: cart.items.keys.toList()[i],
                  ),
                  itemCount: cart.itemCount,
                ))
              ],
            )
          : Center(
              child: Text('Cart is currwntly empty. Please add some data.'),
            ),
    );
  }
}
