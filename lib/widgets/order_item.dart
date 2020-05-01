import 'dart:math';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:shops_app/providers/orders.dart' as data;

class OrderItem extends StatefulWidget {
  final data.OrderItem order;

  OrderItem(this.order);

  @override
  _OrderItemState createState() => _OrderItemState();
}

class _OrderItemState extends State<OrderItem> {
  var _expanded = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(10),
      child: Column(
        children: <Widget>[
          ListTile(
            title: Text('${widget.order.amount} ₹'),
            subtitle: Text(
              DateFormat('dd/MM/yyyy hh:mm').format(widget.order.timeStamp),
            ),
            trailing: IconButton(
                icon: Icon(_expanded ? Icons.expand_more : Icons.expand_less),
                onPressed: () {
                  setState(() {
                    _expanded = !_expanded;
                  });
                }),
          ),
          if (_expanded)
            Container(
              margin: EdgeInsets.all(10),
              height: min(widget.order.products.length * 10.0 + 100.0, 50),
              child: ListView.builder(
                itemBuilder: (ctx, i) => Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      '${widget.order.products[i].title}',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '${widget.order.products[i].quantity}x ${widget.order.products[i].price} ₹',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.grey,
                      ),
                    )
                  ],
                ),
                itemCount: widget.order.products.length,
              ),
            )
        ],
      ),
    );
  }
}
