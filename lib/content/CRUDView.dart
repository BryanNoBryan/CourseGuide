import 'dart:developer';

import 'package:course_guide/navigation/MyNavigator.dart';
import 'package:course_guide/providers/user_state.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:provider/provider.dart';

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
                log('1');
                await context.read<UserState>().logout();
                log('2');
                MyNavigator.calculateNavigation();
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
                  .httpsCallable('makeAdmin')
                  .call(<String, dynamic>{
                'emailToElevate': text1.text,
                'role': 'super-admin',
              });

              log(result.data.toString());
            },
            child: Text("addAdmin"),
          ),
          IconButton(
              onPressed: () {
                AlertDialog alert = AlertDialog(
                  title: Text("Add Course"),
                  content: ListView(
                    children: [TextButton(onPressed: onPressed, child: child)],
                  ),
                  actions: [
                    TextButton(
                      onPressed: () {},
                      child: Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () {},
                      child: Text('Submit'),
                    ),
                  ],
                );

                // show the dialog
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return alert;
                  },
                );
              },
              icon: Icon(Icons.add)),
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
