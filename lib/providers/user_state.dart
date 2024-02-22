import 'dart:developer';

import 'package:course_guide/firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart'
    hide EmailAuthProvider, PhoneAuthProvider;
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
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
    await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform);

    FirebaseUIAuth.configureProviders([
      EmailAuthProvider(),
    ]);

    log('PROCCED');
    FirebaseAuth.instance.userChanges().listen((user) {
      log('PROCCED INSIDE');
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
    notifyListeners();
  }
}
