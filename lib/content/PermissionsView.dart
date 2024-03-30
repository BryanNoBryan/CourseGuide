import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:cloud_functions/cloud_functions.dart';
import 'package:course_guide/MyColors.dart';
import 'package:course_guide/providers/Course.dart';
import 'package:course_guide/providers/database.dart';
import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
            style: TextStyle(fontSize: 36, color: Colors.white),
          ),
          Container(
            margin: EdgeInsets.all(40),
            child: TextField(
                controller: email,
                textAlign: TextAlign.center,
                decoration: InputDecoration(
                  label: Text('Email to change Permissions on:'),
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: MyColors.lightBlue,
                )),
          ),
          Container(
            height: 70,
            width: 200,
            child: DropdownButton<String>(
              isExpanded: true,
              value: dropdownValue,
              dropdownColor: MyColors.lightBlue,
              icon: const Icon(Icons.arrow_downward,
                  color: Color.fromARGB(255, 201, 238, 255)),
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
                  child: Container(
                    alignment: Alignment.center,
                    color: MyColors.lightBlue,
                    child: Text(
                      value,
                      style: TextStyle(fontSize: 20),
                    ),
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
          // ElevatedButton(
          //   style: ElevatedButton.styleFrom(
          //     shape: RoundedRectangleBorder(
          //       borderRadius: BorderRadius.circular(5.0),
          //     ),
          //   ),
          //   onPressed: () async {
          //     print('await csv');
          //     var thing = await getCSV();
          //     print('gots csv');
          //     for (var course in thing) {
          //       print('tried $course 1');
          //       Course c = Course(
          //         code: course[0],
          //         name: course[1],
          //         description: course[2],
          //         subject: course[3],
          //         timeDesc: course[4],
          //         level: course[5],
          //         prereq: course[6],
          //         tags: (course[7] as String).split('|'),
          //       );
          //       print('tried $course 2');
          //       await Database().addCourse(c);
          //       print('tried $course 3');
          //       // String s = '';
          //       // for (var thing3 in course) {
          //       //   s += '$thing3 ';
          //       // }
          //       // print(s);
          //     }
          //   },
          //   child: Text(
          //     "Print CSV",
          //     style: TextStyle(fontSize: 32),
          //   ),
          // ),
        ],
      ),
    ));
  }

//THIS METHOD BELOW AND WIDGET ABOVE UPDATES THE COURSES AVAILABLE

  // Future<List<List<dynamic>>> getCSV() async {
  //   // final input = File('assets/csv/courses.csv').openRead();
  //   final input = await rootBundle.loadString("assets/csv/courses.csv");
  //   List<List<dynamic>> data = CsvToListConverter().convert(input);
  //   // final fields = await input
  //   //     .transform(utf8.decoder)
  //   //     .transform(CsvToListConverter())
  //   //     .toList();
  //   return data;
  // }
}
