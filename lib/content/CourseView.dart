import 'dart:developer';

import 'package:cloud_functions/cloud_functions.dart';
import 'package:course_guide/navigation/MyNavigator.dart';
import 'package:course_guide/providers/Course.dart';
import 'package:course_guide/providers/UserDatabase.dart';
import 'package:course_guide/providers/database.dart';
import 'package:course_guide/providers/user_state.dart';
import 'package:course_guide/widgets/CourseChange.dart';
import 'package:course_guide/widgets/CourseWidget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CourseView extends StatefulWidget {
  const CourseView({super.key});

  @override
  State<CourseView> createState() => _CourseViewState();
}

class _CourseViewState extends State<CourseView> {
  List<Course>? courses;
  final List<String> queryOptions = <String>['Keywords', 'Subject', 'Level'];
  String queryChoice = 'Keywords';

  TextEditingController keywords = TextEditingController();
  TextEditingController subject = TextEditingController();
  TextEditingController level = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    courses = Database().getCourses();
    print(courses);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Center(
            child: Text(
              'Course View',
              style: TextStyle(fontSize: 36),
            ),
          ),
          Expanded(
            child: Row(
              children: [
                //left side
                Expanded(
                  flex: 1,
                  child: Container(
                    margin: EdgeInsets.all(20),
                    child: Column(
                      children: [
                        Text(
                          'Query By: ',
                          style: TextStyle(fontSize: 26),
                        ),
                        Container(
                          height: 70,
                          width: 200,
                          child: DropdownButton<String>(
                            isExpanded: true,
                            value: queryChoice,
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
                                queryChoice = value!;
                              });
                            },
                            items: queryOptions
                                .map<DropdownMenuItem<String>>((String value) {
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
                        switch (queryChoice) {
                          'Keywords' => TextField(
                              controller: keywords,
                              decoration:
                                  InputDecoration(label: Text('Keywords')),
                            ),
                          'Subject' => TextField(
                              controller: subject,
                              decoration:
                                  InputDecoration(label: Text('Subject')),
                            ),
                          'Level' => TextField(
                              controller: level,
                              decoration: InputDecoration(label: Text('Level')),
                            ),
                          _ => TextField(),
                        },
                        Container(
                          margin: EdgeInsets.all(20),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5.0),
                              ),
                            ),
                            onPressed: () async {
                              courses = Database().queryCourses(
                                queryOptions.indexOf(queryChoice),
                                keywords: (queryChoice == queryOptions[0])
                                    ? keywords.text.split(' ')
                                    : null,
                                subject: (queryChoice == queryOptions[1])
                                    ? subject.text
                                    : null,
                                level: (queryChoice == queryOptions[2])
                                    ? level.text
                                    : null,
                              );
                              log('query in crud view');
                              log('$courses');
                              setState(() {});
                            },
                            child: Text(
                              "Query",
                              style: TextStyle(fontSize: 32),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                //right side
                courseView(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Expanded courseView() {
    return Expanded(
      flex: 1,
      child: Container(
        margin: EdgeInsets.all(20),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: courses != null ? courses!.length : 0,
                itemBuilder: (BuildContext context, int index) {
                  print((courses![index].name ?? 'no name error').toString() +
                      '$index');
                  return CourseWidget(
                    course: courses![index],
                    onEdit: () async {
                      await showDialog<String>(
                        context: context,
                        builder: (BuildContext context) => CourseChangeDialog(
                            course: courses![index], isCreate: false),
                      );
                      setState(() {});
                    },
                    onFavorite: () {
                      UserDatabase()
                          .addToFavorite(courses![index].code ?? 'ERROR');
                    },
                    admin: false,
                    hasAccount: UserState().loggedIn && UserState().verified,
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}




// Text('CourseView'),
          // ElevatedButton(
          //     onPressed: () async {
          //       log('1');
          //       await context.read<UserState>().logout();
          //       log('2');
          //       MyNavigator.calculateNavigation();
          //     },
          //     child: Text("logout")),
          // ElevatedButton(
          //   onPressed: () async {
          //     final result = await FirebaseFunctions.instance
          //         .httpsCallable('getuid')
          //         .call();
          //     log(result.data.toString());
          //   },
          //   child: Text("getuid"),
          // ),
          // ElevatedButton(
          //   onPressed: () async {
          //     final result = await FirebaseFunctions.instance
          //         .httpsCallable('returnemail')
          //         .call();
          //     log(result.data.toString());
          //   },
          //   child: Text("returnemail"),
          // ),
          // FutureBuilder(
          //   future: context.watch<UserState>().currentUserClaims,
          //   builder: (context, snapshot) {
          //     if (snapshot.connectionState == ConnectionState.done &&
          //         snapshot.hasData) {
          //       return Text(
          //         'Role: ' + snapshot.data!['role'],
          //         style: TextStyle(fontSize: 32),
          //       );
          //     } else {
          //       return const Center(child: CircularProgressIndicator());
          //     }
          //   },
          // ),