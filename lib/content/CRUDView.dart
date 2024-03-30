import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:course_guide/MyColors.dart';
import 'package:course_guide/navigation/MyNavigator.dart';
import 'package:course_guide/providers/Course.dart';
import 'package:course_guide/providers/UserDatabase.dart';
import 'package:course_guide/providers/database.dart';
import 'package:course_guide/providers/user_state.dart';
import 'package:course_guide/widgets/CourseChange.dart';
import 'package:course_guide/widgets/CourseWidget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
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
      floatingActionButton: FloatingActionButton.large(
          onPressed: () async {
            await showDialog<String>(
              context: context,
              builder: (BuildContext context) =>
                  CourseChangeDialog(isCreate: true),
            );
            courses = Database().courses;
            print('here here $courses');
            setState(() {});
          },
          child: Icon(
            Icons.add,
            color: Colors.white,
          )),
      body: Column(
        children: [
          Center(
            child: Text(
              'Admin View',
              style: TextStyle(fontSize: 36, color: Colors.white),
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
                          style: TextStyle(fontSize: 26, color: Colors.white),
                        ),
                        Container(
                          height: 70,
                          width: 200,
                          child: DropdownButton<String>(
                            isExpanded: true,
                            value: queryChoice,
                            icon: const Icon(
                              Icons.arrow_downward,
                              color: Color.fromARGB(255, 201, 238, 255),
                            ),
                            elevation: 16,
                            dropdownColor: MyColors.lightBlue,
                            style: const TextStyle(color: Colors.black),
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
                        switch (queryChoice) {
                          'Keywords' => TextField(
                              controller: keywords,
                              decoration: InputDecoration(
                                  label: Text('Keywords'),
                                  filled: true,
                                  fillColor: MyColors.lightBlue),
                            ),
                          'Subject' => TextField(
                              controller: subject,
                              decoration: InputDecoration(
                                  label: Text('Subject'),
                                  filled: true,
                                  fillColor: MyColors.lightBlue),
                            ),
                          'Level' => TextField(
                              controller: level,
                              decoration: InputDecoration(
                                  label: Text('Level'),
                                  filled: true,
                                  fillColor: MyColors.lightBlue),
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
                              backgroundColor: MyColors.lightBlue,
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
                        Container(
                          padding: EdgeInsets.all(20),
                          decoration: BoxDecoration(
                              color: MyColors.lightBlue,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: Colors.blueAccent)),
                          child: Text(
                            'Keywords: Enter keywords to be searched by\nSubject: ex: English, research, biology\nLevel: ex: AP, POST AP\n',
                            style: TextStyle(fontSize: 24),
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
                            course: courses![index],
                            onDelete: () async {
                              await Database().deleteCourse(courses![index]);
                              courses = (await Database()
                                  .updateList(courses![index].code!))!;
                              log('on delete inner courses: ${courses}');

                              setState(() {});
                            },
                            isCreate: false),
                      );
                      setState(() {});
                    },
                    onFavorite: () {
                      UserDatabase()
                          .addToFavorite(courses![index].code ?? 'ERROR');
                    },
                    admin: true,
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


// ElevatedButton(
//             onPressed: () async {
//               Course c = Course(
//                   code: 'HFN11XA',
//                   name: 'AP MACRO ECON',
//                   description: '''
// Macroeconomics is the theory of the free market that looks at the economy as a whole. It includes
// national income and price determination, economic performance measures, economic growth
// and international economics. Money, banking, monetary policy and inflation are important topics.
// Additional topics, lessons and assignments will satisfy the requirements for Participation in
// Government.
// Students who take the course may take the AP Exam in May.
// ''',
//                   timeDesc:
//                       '(5 periods per week for 1 year - Qualified Entry Required)',
//                   level: 'AP',
//                   prereq: ['test1'],
//                   coreq: ['test1'],
//                   tags: ['test1']);

//               await Database().addCourse(c);
//               Database().retrieveCourses();

//               print(
//                   'courses:' + courses.toString() + courses!.length.toString());
//               print(courses != null ? courses!.length : 0);
//               setState(() {});
//             },
//             child: Text("add course"),
//           ),


// final RegExp _emailRegex = RegExp(r'^\S+@\S+$');

//   GlobalKey<FormState> _formKey = GlobalKey<FormState>();

//   TextEditingController emailController = TextEditingController();

//   TextEditingController text1 = TextEditingController();
//   TextEditingController text2 = TextEditingController();
//   TextEditingController text3 = TextEditingController();

//   QuerySnapshot<Map<String, dynamic>>? datum;

// Scaffold(
//       body: Center(
//           child: Column(
//         children: [
//           Text('CRUDView'),
//           ElevatedButton(
//               onPressed: () async {
//                 log('1');
//                 await context.read<UserState>().logout();
//                 log('2');
//                 MyNavigator.calculateNavigation();
//               },
//               child: Text("logout")),
//           TextField(
//             controller: text1,
//             textAlign: TextAlign.center,
//           ),
//           ElevatedButton(
//             onPressed: () async {
//               // final result = await FirebaseFunctions.instance
//               //     .httpsCallable('makeadmin')
//               //     .call(<String, dynamic>{
//               //   'emailToElevate': text1.text,
//               // });

//               final result = await FirebaseFunctions.instance
//                   .httpsCallable('makeAdmin')
//                   .call(<String, dynamic>{
//                 'emailToElevate': text1.text,
//                 'role': 'super-admin',
//               });

//               log(result.data.toString());
//             },
//             child: Text("addAdmin"),
//           ),
//           IconButton(
//               onPressed: () {
//                 AlertDialog alert = AlertDialog(
//                   title: Text("Add Course"),
//                   content: ListView(
//                     children: [
//                       Form(
//                           key: _formKey,
//                           child: Column(
//                             children: [
//                               TextFormField(
//                                 controller: emailController,
//                                 validator: (value) {
//                                   if (_emailRegex.hasMatch(value!)) {
//                                     emailController.text = 'wrong format';
//                                   }
//                                 },
//                               )
//                             ],
//                           ))
//                     ],
//                   ),
//                   actions: [
//                     TextButton(
//                       onPressed: () {},
//                       child: Text('Cancel'),
//                     ),
//                     TextButton(
//                       onPressed: () {
//                         _formKey.currentState!.validate();
//                       },
//                       child: Text('Submit'),
//                     ),
//                   ],
//                 );

//                 // show the dialog
//                 showDialog(
//                   context: context,
//                   builder: (BuildContext context) {
//                     return alert;
//                   },
//                 );
//               },
//               icon: Icon(Icons.add)),
//           ElevatedButton(
//             onPressed: () async {
//               final result = await FirebaseFunctions.instance
//                   .httpsCallable('getuid')
//                   .call();
//               log(result.data.toString());
//             },
//             child: Text("getuid"),
//           ),
//           ElevatedButton(
//             onPressed: () async {
//               final result = await FirebaseFunctions.instance
//                   .httpsCallable('returnemail')
//                   .call();
//               log(result.data.toString());
//             },
//             child: Text("returnemail"),
//           ),
//           FutureBuilder(
//             future: context.watch<UserState>().currentUserClaims,
//             builder: (context, snapshot) {
//               if (snapshot.connectionState == ConnectionState.done &&
//                   snapshot.hasData) {
//                 return Text(
//                   'Role: ' + snapshot.data!['role'],
//                   style: TextStyle(fontSize: 32),
//                 );
//               } else {
//                 return const Center(child: CircularProgressIndicator());
//               }
//             },
//           ),
//           TextField(
//             controller: text2,
//             textAlign: TextAlign.center,
//           ),
//           TextField(
//             controller: text3,
//             textAlign: TextAlign.center,
//           ),
//           ElevatedButton(
//             onPressed: () async {
//               final db = FirebaseFirestore.instance;
//               final data = <String, String>{
//                 "data1": text2.text,
//                 "data2": text3.text,
//               };

//               db
//                   .collection("cities")
//                   // .doc("LA")
//                   .add(data);
//             },
//             child: Text("test firestore test1"),
//           ),

//           //well teechnically works but it diappears instantly
//           ElevatedButton(
//             onPressed: () async {
//               print('udpate1');
//               final db = FirebaseFirestore.instance;
//               await db
//                   .collection('cities')
//                   .where('data1', isNull: false)
//                   .get()
//                   .then((querySnapshot) => datum = querySnapshot);
//               print('second');
//               print(datum!.docs.length);
//               print(datum == null ? 0 : datum!.docs.length);
//               setState(() {});
//             },
//             child: Text("update test1"),
//           ),
//           Container(
//             height: 200,
//             child: ListView.builder(
//               itemCount: datum == null ? 0 : datum!.docs.length,
//               itemBuilder: (context, index) {
//                 print(datum!.docs[index].data()['data1']);
//                 return Text(datum!.docs[index].data()['data1']);
//               },
//             ),
//           )
//         ],
//       )),
//     );