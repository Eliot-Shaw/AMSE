import 'package:flutter/material.dart';

class LikesProvider extends ChangeNotifier {
  final List<Map<String, dynamic>> likes = [];

  void addProduct(Map<String, dynamic> product) {
    likes.add(product);
    notifyListeners();
  }

  void removeProduct(Map<String, dynamic> product) {
    likes.remove(product);
    notifyListeners();
  }
}
