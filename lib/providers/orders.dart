import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shops_app/widgets/order_item.dart';

import './cart.dart';

class OrderItem {
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime timeStamp;

  OrderItem({
    @required this.id,
    @required this.amount,
    @required this.products,
    @required this.timeStamp,
  });
}

class Orders with ChangeNotifier {
  List<OrderItem> _orders = [];

  List<OrderItem> get orders {
    return [..._orders];
  }

  int get count {
    return _orders.length;
  }

  Future<void> addOrder(List<CartItem> products, double total) async {
    final url = 'https://dukan-2092e.firebaseio.com/orders.json';
    final timeStamp = DateTime.now();
    final response = await http.post(url,
        body: jsonEncode(
          {
            'amount': total,
            'timeStamp': timeStamp.toIso8601String(),
            'products': products
                .map((cp) => {
                      'id': cp.id,
                      'title': cp.title,
                      'quantity': cp.quantity,
                      'price': cp.price
                    })
                .toList()
          },
        ));
    _orders.insert(
      0,
      OrderItem(
        id: json.decode(response.body)['name'],
        amount: total,
        products: products,
        timeStamp: timeStamp,
      ),
    );
    notifyListeners();
  }

  Future<void> fetchAndSetOrder() async {
    final url = 'https://dukan-2092e.firebaseio.com/orders.json';
    final response = await http.get(url);
    final List<OrderItem> loadedOrders = [];
    final extractedData = json.decode(response.body) as Map<String, dynamic>;
    if (extractedData == null) {
      _orders = loadedOrders;
      notifyListeners();
      return;
    }
    extractedData.forEach((orderId, orderData) {
      loadedOrders.add(
        OrderItem(
          id: orderId,
          amount: orderData['amount'] as double,
          timeStamp: DateTime.parse(orderData['timeStamp']),
          products: (orderData['products'] as List<dynamic>)
              .map(
                (data) => CartItem(
                  id: data['id'],
                  title: data['title'],
                  quantity: data['quantity'],
                  price: data['price'] as double,
                ),
              )
              .toList(),
        ),
      );
      _orders = loadedOrders.reversed.toList();
      notifyListeners();
    });
  }
}
