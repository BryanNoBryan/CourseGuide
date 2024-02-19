import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class UserState extends ChangeNotifier {
  UserState() {
    init();
  }

  bool _loggedIn = false;
  bool get loggedIn => _loggedIn;

  Future<void> init() async {
    FirebaseAuth.instance.userChanges().listen((user) {
      if (user != null) {
        _loggedIn = true;
      } else {
        _loggedIn = false;
      }
      notifyListeners();
    });
  }
}
