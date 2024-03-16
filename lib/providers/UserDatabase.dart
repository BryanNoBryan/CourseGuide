import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:course_guide/providers/Course.dart';
import 'package:course_guide/providers/User.dart';
import 'package:course_guide/providers/user_state.dart';

class UserDatabase {
  static final UserDatabase _state = UserDatabase._init();
  factory UserDatabase() {
    return _state;
  }
  UserDatabase._init();

  MyUser? user;

  FirebaseFirestore database = FirebaseFirestore.instance;

  String? checkUID(MyUser user) {
    String? s = user.UID ?? UserState.user?.uid;
    print('checkUID: $s');
    return s;
  }

  MyUser? getUser() {
    log('got user ${user?.firstName}  ${user?.UID}');
    return user;
  }

  Future<MyUser?> retrieveUser() async {
    print(UserState.user?.uid);
    user = MyUser.fromFirestore(
        await FirebaseFirestore.instance
            .collection('Users')
            .doc(UserState.user?.uid)
            .get(),
        null);

    log('retrieved user');
    log('retrieved user ${user?.firstName}  ${user?.UID}');
    return user;
  }

  Future<void> addToFavorite(String code) async {
    if (user == null) {
      print('user NULL1');
      return;
    }
    String? UID = checkUID(user!);
    if (UID == null) {
      print('UID NULL1');
      return;
    }
    FirebaseFirestore.instance.collection('Users').doc(UID).update({
      'favorites': FieldValue.arrayUnion([code])
    }).onError((error, stackTrace) => print('$error'));
    print('add favorite');
  }

  Future<void> removeFromFavorite(String code) async {
    if (user == null) {
      print('user NULL1');
      return;
    }
    String? UID = checkUID(user!);
    if (UID == null) {
      print('UID NULL1');
      return;
    }
    FirebaseFirestore.instance.collection('Users').doc(UID).update({
      'favorites': FieldValue.arrayRemove([code])
    }).onError((error, stackTrace) => print('$error'));
    print('add favorite');
  }

  Future<void> updateUser(MyUser user) async {
    String? UID = checkUID(user);
    if (UID == null) {
      print('UID NULL1');
      return;
    }

    FirebaseFirestore.instance
        .collection('Users')
        .doc(UID)
        .set(user.toFirestore())
        .onError((error, stackTrace) => print('$error'));
    print('update user');
  }

  Future<List<String>?> getFavorites(MyUser? user) async {
    if (user == null) return user?.favorites;
    String? UID = checkUID(user);
    if (UID == null) {
      print('UID NULL1');
      return null;
    }

    print('favorite error? $UID');

    var snapshot =
        await FirebaseFirestore.instance.collection('Users').doc(UID).get();
    MyUser userForFavs = MyUser.fromFirestore(snapshot, null);
    print('get favorites ${userForFavs.favorites}');
    return userForFavs.favorites;
  }
}
