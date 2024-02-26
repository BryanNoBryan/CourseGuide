import 'package:course_guide/navigation/MyNavigator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Favorites extends StatefulWidget {
  const Favorites({super.key});

  @override
  State<Favorites> createState() => _FavoritesState();
}

class _FavoritesState extends State<Favorites> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Column(
        children: [
          Text('Favorites'),
          ElevatedButton(
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
                MyNavigator.shell.goBranch(0);
              },
              child: Text("logout")),
        ],
      )),
    );
  }
}
