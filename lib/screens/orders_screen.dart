import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/app_drawer.dart';
import '../providers/orders.dart' show Orders;
import '../widgets/order_item.dart';

class OrdersScreen extends StatefulWidget {
  static const routeName = '/orders';

  @override
  _OrdersScreenState createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  var _isLoading = false;
  @override
  // void initState() {
  //   Future.delayed(Duration.zero).then((value) async {
  //     setState(() {
  //       _isLoading = true;
  //     });
  //     await Provider.of<Orders>(context, listen: false).fetchAndSetOrder();
  //     setState(() {
  //       _isLoading = false;
  //     });
  //   });
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('All Orders'),
        ),
        drawer: AppDrawer(),
        body: FutureBuilder(
            future:
                Provider.of<Orders>(context, listen: false).fetchAndSetOrder(),
            builder: (ctx, dataSnapshot) {
              if (dataSnapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else {
                if (dataSnapshot.error != null) {
                  return Center(
                    child: Text('Something went wrong!'),
                  );
                } else {
                  return Consumer<Orders>(
                    builder: (ctx, orderData, child) {
                      return orderData.count == 0
                          ? Center(
                              child: Text('No order.Please place some'),
                            )
                          : ListView.builder(
                              itemBuilder: (ctx, i) =>
                                  OrderItem(orderData.orders[i]),
                              itemCount: orderData.count,
                            );
                    },
                  );
                }
              }
            }));
  }
}
