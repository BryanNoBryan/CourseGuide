import 'package:course_guide/navigation/MyNavigator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class CourseView extends StatefulWidget {
  const CourseView({super.key});

  @override
  State<CourseView> createState() => _CourseViewState();
}

class _CourseViewState extends State<CourseView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Column(
        children: [
          Text('CourseView'),
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
