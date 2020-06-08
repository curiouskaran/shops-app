import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavourite;

  Product({
    @required this.id,
    @required this.title,
    @required this.description,
    @required this.price,
    @required this.imageUrl,
    this.isFavourite = false,
  });

  void _setFavStatus(bool status) {
    isFavourite = status;
    notifyListeners();
  }

  Future<void> toggleFavouriteStatus() async {
    final oldStatus = isFavourite;
    isFavourite = !isFavourite;
    notifyListeners();
    final url = 'https://dukan-2092e.firebaseio.com/products/$id.json';
    try {
      final response = await http.patch(
        url,
        body: jsonEncode({
          'isFavourite': isFavourite,
        }),
      );
      if (response.statusCode >= 400) {
        _setFavStatus(oldStatus);
      }
    } catch (error) {
      _setFavStatus(oldStatus);
    }
  }
}
