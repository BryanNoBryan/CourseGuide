import 'dart:developer';

import 'package:course_guide/firebase_options.dart';
import 'package:course_guide/navigation/MyNavigator.dart';
import 'package:firebase_auth/firebase_auth.dart'
    hide EmailAuthProvider, PhoneAuthProvider;
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/foundation.dart';

class UserState extends ChangeNotifier {
  static final UserState _userState = UserState._init();

  factory UserState() {
    return _userState;
  }

  static const String SUPERADMIN = 'super-admin';
  static const String ADMIN = 'admin';
  static const String REGULAR = 'regular';

  static User? _user;
  static User? get user => _user;

  bool _loggedIn = false;
  bool get loggedIn => _loggedIn;

  bool _verified = false;
  bool get verified => _verified;

  UserState._init() {
    //I need this information immediately
    _loggedIn = FirebaseAuth.instance.currentUser != null;
    _verified =
        (_loggedIn && FirebaseAuth.instance.currentUser!.emailVerified == true);
    log('info initialized in init');
    FirebaseAuth.instance.userChanges().listen((user) {
      log('PROCCED INSIDE');
      if (user != null) {
        _user = user;
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

  //maybe it doesn't listen to verify changes -> add a method

  Future<Map<String, dynamic>?> get currentUserClaims async {
    log('got claims');
    if (_user == null) return null;
    final idTokenResult = await _user!.getIdTokenResult(true);

    return idTokenResult.claims;
  }

  Future<void> logout() async {
    log('logged out');
    await FirebaseAuth.instance.signOut();
    _verified = false;
    _user = null;
    MyNavigator.router.go(MyNavigator.CourseViewPath);
  }
}
