import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavourite;

  Product(
      {@required this.id,
      @required this.title,
      @required this.description,
      @required this.price,
      @required this.imageUrl,
      this.isFavourite = false});

  Future<void> toggleFavourite(String token, String userId) {
    bool oldStatus = isFavourite;
    isFavourite = !isFavourite;
    notifyListeners();
    final url = Uri.parse(
        'https://shopping-app-c8efa-default-rtdb.firebaseio.com/userFavorites/$userId/$id.json?auth=$token');

    return http
        .put(url,
            body: json.encode(
              isFavourite,
            ))
        .catchError((error) {
      isFavourite = oldStatus;
      notifyListeners();
      throw error;
    });
  }
}
