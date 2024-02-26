import 'dart:developer';

import 'package:cloud_functions/cloud_functions.dart';
import 'package:course_guide/navigation/MyNavigator.dart';
import 'package:course_guide/providers/user_state.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
                log('1');
                await context.read<UserState>().logout();
                log('2');
                MyNavigator.calculateNavigation();
              },
              child: Text("logout")),
          ElevatedButton(
            onPressed: () async {
              final result = await FirebaseFunctions.instance
                  .httpsCallable('getuid')
                  .call();
              log(result.data.toString());
            },
            child: Text("getuid"),
          ),
          ElevatedButton(
            onPressed: () async {
              final result = await FirebaseFunctions.instance
                  .httpsCallable('returnemail')
                  .call();
              log(result.data.toString());
            },
            child: Text("returnemail"),
          ),
          FutureBuilder(
            future: context.watch<UserState>().currentUserClaims,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done &&
                  snapshot.hasData) {
                return Text(
                  'Role: ' + snapshot.data!['role'],
                  style: TextStyle(fontSize: 32),
                );
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            },
          ),
        ],
      )),
    );
  }
}
