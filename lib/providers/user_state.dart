import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class UserState extends ChangeNotifier {
  UserState() {
    _init();
  }

  bool _loggedIn = false;
  bool get loggedIn => _loggedIn;

  bool _verified = false;
  bool get verified => _verified;

  Future<void> _init() async {
    FirebaseAuth.instance.userChanges().listen((user) {
      if (user != null) {
        _loggedIn = true;
        if (user.emailVerified) {
          _verified = true;
          log('verified');
        } else {
          _verified = false;
        }
      } else {
        _loggedIn = false;
      }
      notifyListeners();
    });
  }
}
