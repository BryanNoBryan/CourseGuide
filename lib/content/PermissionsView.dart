import 'dart:developer';

import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/material.dart';

class PermissionsView extends StatefulWidget {
  const PermissionsView({super.key});

  @override
  State<PermissionsView> createState() => _PermissionsViewState();
}

class _PermissionsViewState extends State<PermissionsView> {
  final List<String> list = <String>['super-admin', 'admin', 'regular'];
  String dropdownValue = 'super-admin';

  TextEditingController email = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Column(
        children: [
          Text(
            'Change Permissions',
            style: TextStyle(fontSize: 36),
          ),
          Container(
            margin: EdgeInsets.all(40),
            child: TextField(
                controller: email,
                textAlign: TextAlign.center,
                decoration: InputDecoration(
                  label: Text('Email to change Permissions on:'),
                  border: OutlineInputBorder(),
                )),
          ),
          Container(
            height: 70,
            width: 200,
            child: DropdownButton<String>(
              isExpanded: true,
              value: dropdownValue,
              icon: const Icon(Icons.arrow_downward),
              elevation: 16,
              style: const TextStyle(color: Colors.deepPurple),
              underline: Container(
                height: 2,
                color: Colors.deepPurpleAccent,
              ),
              onChanged: (String? value) {
                // This is called when the user selects an item.
                setState(() {
                  dropdownValue = value!;
                });
              },
              items: list.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(
                    value,
                    style: TextStyle(fontSize: 20),
                  ),
                );
              }).toList(),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5.0),
              ),
            ),
            onPressed: () async {
              final result = await FirebaseFunctions.instance
                  .httpsCallable('makeAdmin')
                  .call(<String, dynamic>{
                'emailToElevate': email.text,
                'role': dropdownValue,
              });

              log(result.data.toString());
            },
            child: Text(
              "Update Permission",
              style: TextStyle(fontSize: 32),
            ),
          ),
        ],
      ),
    ));
  }
}
