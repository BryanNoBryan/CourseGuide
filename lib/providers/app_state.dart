import 'package:flutter/foundation.dart';

class AppState extends ChangeNotifier {
  int counter = 0;

  AppState() {
    _init();
  }

  Future<void> _init() async {
    counter = 0;
  }

  void increment({required int x}) async {
    counter += x;
    notifyListeners();
  }

  void decrement({required int x}) async {
    counter -= x;
    notifyListeners();
  }
}
