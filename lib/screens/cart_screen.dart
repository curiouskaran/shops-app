import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/cart_item.dart';
import '../providers/cart.dart' show Cart;
import '../providers/orders.dart';

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
                            '${cart.totalAmount.toStringAsFixed(2)} ₹',
                            style: TextStyle(
                                color: Theme.of(context)
                                    .primaryTextTheme
                                    .headline6
                                    .color),
                          ),
                          backgroundColor: Theme.of(context).primaryColor,
                        ),
                        OrderButton(cart: cart)
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

class OrderButton extends StatefulWidget {
  const OrderButton({
    Key key,
    @required this.cart,
  }) : super(key: key);

  final Cart cart;

  @override
  _OrderButtonState createState() => _OrderButtonState();
}

class _OrderButtonState extends State<OrderButton> {
  var _isLoading = false;
  @override
  Widget build(BuildContext context) {
    return FlatButton(
      onPressed: (widget.cart.totalAmount <= 0 || _isLoading)
          ? null
          : () async {
              setState(() {
                _isLoading = true;
              });
              await Provider.of<Orders>(
                context,
                listen: false,
              ).addOrder(
                widget.cart.items.values.toList(),
                widget.cart.totalAmount,
              );
              setState(() {
                _isLoading = false;
              });
              widget.cart.clear();
            },
      child: _isLoading
          ? CircularProgressIndicator()
          : Text(
              'ORDER NOW',
              style: TextStyle(color: Theme.of(context).primaryColor),
            ),
    );
  }
}
