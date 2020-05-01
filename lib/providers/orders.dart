import 'package:flutter/foundation.dart';
import 'package:shops_app/providers/cart.dart';

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

  void addOrder(List<CartItem> products, double total) {
    _orders.insert(
      0,
      OrderItem(
        id: DateTime.now().toString(),
        amount: total,
        products: products,
        timeStamp: DateTime.now(),
      ),
    );
    notifyListeners();
  }
}
