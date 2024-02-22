import 'package:course_guide/navigation/MyNavigator.dart';
import 'package:course_guide/providers/app_state.dart';
import 'package:course_guide/providers/user_state.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class temptest extends StatefulWidget {
  const temptest({super.key});

  @override
  State<temptest> createState() => _temptestState();
}

class _temptestState extends State<temptest> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(centerTitle: true, title: Text('SUPER IDOL')),
      body: Column(
        children: [
          Consumer<AppState>(
            builder: (context, value, child) => TextButton(
              onPressed: () {
                value.counter = 3;
                value.increment(x: 1);
              },
              child: Text(value.counter.toString()),
            ),
          ),
          Text(context.watch<AppState>().counter.toString()),
          ElevatedButton(
              onPressed: () {
                context.read<AppState>().increment(x: 1);
              },
              child: Text("inc")),
          ElevatedButton(
              onPressed: () {
                context.read<AppState>().decrement(x: 1);
              },
              child: Text("dec")),
          ElevatedButton(
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
                MyNavigator.shell.goBranch(0);
              },
              child: Text("logout")),
        ],
      ),
    );
  }
}
