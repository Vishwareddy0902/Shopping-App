import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_complete_guide/providers/product.dart';
import 'package:http/http.dart' as http;

class Products with ChangeNotifier {
  List<Product> _items = [
    // Product(
    //   id: 'p1',
    //   title: 'Apple iPhone 14',
    //   description:
    //       '[1]]15.40 cm (6.1-inch) Super Retina XDR display \n[2]Advanced camera system for better photos in any light \n[3]Cinematic mode now in 4K Dolby Vision up to 30 fps \n[4]Action mode for smooth, steady, handheld videos \n[5]Vital safety technology — Crash Detection calls for help when you can’t',
    //   price: 89900.00,
    //   imageUrl: 'https://m.media-amazon.com/images/I/618Bb+QzCmL._SL1500_.jpg',
    // ),
    // Product(
    //   id: 'p2',
    //   title: 'Redmi 9 Activ ',
    //   description:
    //       'Redmi 9 Activ (Carbon Black, 4GB RAM, 64GB Storage) | Octa-core Helio G35 | 5000 mAh Battery',
    //   price: 8099.00,
    //   imageUrl: 'https://m.media-amazon.com/images/I/911TJ1CDbLL._SL1500_.jpg',
    // ),
    // Product(
    //   id: 'p3',
    //   title: 'Smart Watch',
    //   description:
    //       'Noise ColorFit Pulse Grand Smart Watch with 1.69"(4.29cm) HD Display, 60 Sports Modes, 150 Watch Faces, Fast Charge, Spo2, Stress, Sleep, Heart Rate Monitoring & IP68 Waterproof (Jet Black)',
    //   price: 1499.00,
    //   imageUrl: 'https://m.media-amazon.com/images/I/61Q0R5cdxWL._SL1500_.jpg',
    // ),
    // Product(
    //   id: 'p4',
    //   title: 'Backpack',
    //   description:
    //       'Safari Tribe 35 Ltrs Large Laptop Backpack With 3 Compartments, Water Resistant Fabric - Black (TRIBE19CBBLK)',
    //   price: 49.99,
    //   imageUrl: 'https://m.media-amazon.com/images/I/71aWnXcav9L._SL1500_.jpg',
    // ),
    // Product(
    //   id: 'p5',
    //   title: 'Pendrive',
    //   description:
    //       'SanDisk Ultra Dual Drive Go USB Type C Pendrive for Mobile (Black, 128 GB, 5Y - SDDDC3-128G-I35)',
    //   price: 1099.00,
    //   imageUrl: 'https://m.media-amazon.com/images/I/71qOWNxv4jL._SL1500_.jpg',
    // ),
    // Product(
    //   id: 'p6',
    //   title: 'Milton Thermosteel',
    //   description:
    //       'Double walled Vacuum insulated technology keeps beverages hot or cold for 24 hours, Inner copper coating for better temperature retention. A unique flip lid that makes pouring completely hassle-free and spill-free, the lid of this bottle doubles up as a cup for drinking, simple threaded lid for easy use',
    //   price: 1029.00,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
    // ),
    // Product(
    //   id: 'p7',
    //   title: 'Liquid Detergent ',
    //   description:
    //       'Surf Excel Matic Front Load Liquid Detergent 2 L Refill, Designed For Tough Stain Removal on Laundry in Washing Machines - Super Saver Offer Pack, (EAMA100)',
    //   price: 430.00,
    //   imageUrl: 'https://m.media-amazon.com/images/I/71AfKPJFjoL._SL1000_.jpg',
    // ),
    // Product(
    //   id: 'p8',
    //   title: 'Wireless Earbuds',
    //   description:
    //       'realme TechLife Buds T100 True Wireless Earbuds with AI ENC for Calls, Google Fast Pair, 28 Hours Total Playback with Fast Charging and Low Latency Gaming Mode (Black)',
    //   price: 1499.99,
    //   imageUrl: 'https://m.media-amazon.com/images/I/61aasAbKvvL._SL1500_.jpg',
    // ),
    // Product(
    //   id: 'p9',
    //   title: 'Headphones',
    //   description:
    //       'EKSA E900 Wired Stereo Gaming Headset-Over Ear Headphones with Noise Canceling Mic, Detachable Headset Compatible with PS4, PS5, PC, Laptop (Red)',
    //   price: 1499.00,
    //   imageUrl: 'https://m.media-amazon.com/images/I/71rhFZZIH3L._SL1500_.jpg',
    // ),
    // Product(
    //   id: 'p10',
    //   title: 'Gaming Laptop',
    //   description:
    //       'ASUS TUF Gaming A15, 15.6-inch (39.62 cms) FHD 144Hz, AMD Ryzen 5 4600H, 4GB NVIDIA GeForce GTX 1650, Gaming Laptop (8GB/512GB SSD/90WHrs Battery/Windows 11/Black/2.3 Kg), FA506IHRB-HN079W.',
    //   price: 51699.00,
    //   imageUrl: 'https://m.media-amazon.com/images/I/91zVSkGGZbS._SL1500_.jpg',
    // ),
  ];

  List<Product> get items {
    return [..._items];
  }

  List<Product> get favoriteList {
    return items.where((element) => element.isFavourite).toList();
  }

  Future<void> fetchAndSetData() async {
    final url = Uri.parse(
        'https://shopping-app-c8efa-default-rtdb.firebaseio.com/products.json');
    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      List<Product> loadedProducts = [];
      extractedData.forEach((prodID, prodData) {
        final product = Product(
            id: prodID,
            title: prodData['title'],
            description: prodData['description'],
            price: prodData['price'],
            imageUrl: prodData['imageUrl'],
            isFavourite: prodData['isFavorite']);
        loadedProducts.add(product);
      });
      _items = loadedProducts;
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> addNewItem(Product product) {
    final url = Uri.parse(
        'https://shopping-app-c8efa-default-rtdb.firebaseio.com/products.json');

    return http
        .post(url,
            body: json.encode({
              'title': product.title,
              'price': product.price,
              'description': product.description,
              'imageUrl': product.imageUrl,
              'isFavorite': product.isFavourite,
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
          'https://shopping-app-c8efa-default-rtdb.firebaseio.com/products/$Id.json');

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
          'https://shopping-app-c8efa-default-rtdb.firebaseio.com/products/${product.id}.json');

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
