import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_complete_guide/providers/product.dart';
import 'package:http/http.dart' as http;

class Products with ChangeNotifier {
  String token;
  String userId;
  List<Product> _items = [];

  Products(this.token, this.userId, this._items);

  List<Product> get items {
    return [..._items];
  }

  List<Product> get favoriteList {
    return items.where((element) => element.isFavourite).toList();
  }

  Future<void> fetchAndSetData({fetchUserProducts = false}) async {
    String filterByUser =
        fetchUserProducts ? 'orderBy="creatorId"&equalTo="$userId"' : '';
    final url = Uri.parse(
        'https://shopping-app-c8efa-default-rtdb.firebaseio.com/products.json?auth=$token&$filterByUser');
    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      if (extractedData == null) return;
      final favoriteResponse = await http.get(Uri.parse(
          'https://shopping-app-c8efa-default-rtdb.firebaseio.com/userFavorites/$userId.json?auth=$token'));
      final favoriteData = json.decode(favoriteResponse.body);
      List<Product> loadedProducts = [];
      extractedData.forEach((prodID, prodData) {
        if (prodData['creatorId'] != userId || fetchUserProducts) {
          final product = Product(
              id: prodID,
              title: prodData['title'],
              description: prodData['description'],
              price: prodData['price'],
              imageUrl: prodData['imageUrl'],
              isFavourite:
                  favoriteData == null ? false : favoriteData[prodID] ?? false);
          loadedProducts.add(product);
        }
      });
      _items = loadedProducts;
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> addNewItem(Product product) {
    final url = Uri.parse(
        'https://shopping-app-c8efa-default-rtdb.firebaseio.com/products.json?auth=$token');

    return http
        .post(url,
            body: json.encode({
              'creatorId': userId,
              'title': product.title,
              'price': product.price,
              'description': product.description,
              'imageUrl': product.imageUrl,
            }))
        .then((Response) {
      print(json.decode(Response.body)['name']);
      Product newProduct = Product(
          id: json.decode(Response.body)['name'],
          title: product.title,
          description: product.description,
          price: product.price,
          imageUrl: product.imageUrl);
      _items.add(newProduct);
      notifyListeners();
    }).catchError((error) {
      print(error);
      throw error;
    });
  }

  Product findById(String Id) {
    return _items.firstWhere((prod) => prod.id == Id);
  }

  Future<void> deleteProduct(String Id) {
    final index = _items.indexWhere((element) => element.id == Id);
    if (index >= 0) {
      final url = Uri.parse(
          'https://shopping-app-c8efa-default-rtdb.firebaseio.com/products/$Id.json?auth=$token');

      return http.delete(url).then((response) {
        if (response.statusCode >= 400) {
          throw Exception();
        }
        _items.removeWhere((product) => product.id == Id);
        notifyListeners();
      }).catchError((error) {
        throw error;
      });
    } else {
      print('....');
    }
  }

  Future<void> updateProduct(Product product) {
    final index = _items.indexWhere((element) => element.id == product.id);
    if (index >= 0) {
      final url = Uri.parse(
          'https://shopping-app-c8efa-default-rtdb.firebaseio.com/products/${product.id}.json?auth=$token');

      return http
          .patch(url,
              body: json.encode({
                'title': product.title,
                'price': product.price,
                'description': product.description,
                'imageUrl': product.imageUrl,
              }))
          .then((value) {
        _items[index] = product;
        notifyListeners();
      }).catchError((error) {
        throw error;
      });
    } else {
      print('....');
    }
  }
}
