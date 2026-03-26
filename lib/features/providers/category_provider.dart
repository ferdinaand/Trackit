import 'package:flutter/foundation.dart';

class CategoryProvider with ChangeNotifier {
  final List<String> _categories = [
    'Food',
    'Transportation',
    'Entertainment',
    'Shopping',
    'Bills',
    'healthcare',
    'education',
    'travel',
    'savings',
    'Other'
  ];

  List<String> get categories => [..._categories];

  void addCategory(String category) {
    if (!_categories.contains(category)) {
      _categories.add(category);
      notifyListeners();
    }
  }

  void removeCategory(String category) {
    _categories.remove(category);
    notifyListeners();
  }
}
