import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import './product.dart';

class Products with ChangeNotifier {
  List<Product> _items = [];

  // var _showFavouritesOnly = false;

  List<Product> get items {
    // if (_showFavouritesOnly) {
    //   return _items.where((item) => item.isFavourite == true).toList();
    // }
    return [..._items];
  }

  List<Product> get favouriteItems {
    return _items.where((item) => item.isFavourite == true).toList();
  }

  Future<void> fetchAndSetProducts() async {
    const url = 'https://dukan-2092e.firebaseio.com/products.json';
    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      final List<Product> loadedData = [];

      extractedData.forEach((productId, productData) {
        loadedData.add(Product(
            id: productId,
            title: productData['title'],
            description: productData['description'],
            price: productData['price'],
            imageUrl: productData['imageUrl']));
        _items = loadedData;
        notifyListeners();
      });
    } catch (error) {
      throw (error);
    }
  }

  Future<void> addProduct(product) {
    // _items.add(value)
    const url = 'https://dukan-2092e.firebaseio.com/products.json';
    return http
        .post(
      url,
      body: json.encode({
        'title': product.title,
        'description': product.description,
        'price': product.price,
        'imageUrl': product.imageUrl,
        'isFavourite': product.isFavourite,
      }),
    )
        .then((response) {
      var newProduct = Product(
        id: json.decode(response.body)['name'],
        title: product.title,
        description: product.description,
        price: product.price,
        imageUrl: product.imageUrl,
      );
      _items.add(newProduct);
      notifyListeners();
    }).catchError((err) {
      print('error $err');
      throw err;
    });
  }

  void updateProduct(String id, Product updatedProduct) {
    var productIndex = _items.indexWhere((product) => product.id == id);
    if (productIndex >= 0) {
      _items[productIndex] = updatedProduct;
      notifyListeners();
    }
  }

  void deleteProduct(String id) {
    // var productIndex = _items.indexWhere((product) => product.id == id);
    // if (productIndex >= 0) {
    //   _items.removeAt(productIndex);
    //   notifyListeners();
    // }
    _items.removeWhere((product) => product.id == id);
    notifyListeners();
  }

  // void showFavourites() {
  //   _showFavouritesOnly = true;
  //   notifyListeners();
  // }

  // void showAll() {
  //   _showFavouritesOnly = false;
  //   notifyListeners();
  // }

  Product findById(String id) {
    return _items.firstWhere((item) => item.id == id);
  }
}
