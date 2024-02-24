import 'dart:developer';

import 'package:course_guide/navigation/MyNavigator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_functions/cloud_functions.dart';

class CRUDView extends StatefulWidget {
  const CRUDView({super.key});

  @override
  State<CRUDView> createState() => _CRUDViewState();
}

class _CRUDViewState extends State<CRUDView> {
  TextEditingController text1 = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Column(
        children: [
          Text('CRUDView'),
          ElevatedButton(
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
                MyNavigator.shell.goBranch(0);
              },
              child: Text("logout")),
          TextField(
            controller: text1,
            textAlign: TextAlign.center,
          ),
          ElevatedButton(
            onPressed: () async {
              // final result = await FirebaseFunctions.instance
              //     .httpsCallable('makeadmin')
              //     .call(<String, dynamic>{
              //   'emailToElevate': text1.text,
              // });

              final result = await FirebaseFunctions.instance
                  .httpsCallable('makeadmin')
                  .call(<String, dynamic>{
                'emailToElevate': 'h@gmail.com',
              });

              log(result.data.toString());
            },
            child: Text("addAdmin"),
          ),
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
        ],
      )),
    );
  }
}
