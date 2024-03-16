import 'package:course_guide/providers/User.dart';
import 'package:course_guide/providers/UserDatabase.dart';
import 'package:course_guide/providers/database.dart';
import 'package:course_guide/providers/user_state.dart';
import 'package:course_guide/widgets/CourseChange.dart';
import 'package:course_guide/widgets/CourseWidget.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  TextEditingController OSIS = TextEditingController();
  TextEditingController firstName = TextEditingController();
  TextEditingController lastName = TextEditingController();
  TextEditingController UID = TextEditingController();
  TextEditingController officialClass = TextEditingController();
  MyUser? user;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    user = UserDatabase().getUser();

    OSIS.text = user?.OSIS ?? '';
    firstName.text = user?.firstName ?? '';
    lastName.text = user?.lastName ?? '';
    UID.text = user?.UID ?? '';
    officialClass.text = user?.officialClass ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      children: [
        TextButton(
            onPressed: () {
              UserState().logout();
            },
            child: Text(
              'Logout',
              style: TextStyle(fontSize: 20),
            )),
        Expanded(
          child: Center(
            child: ListView(
              children: [
                InputHelper(
                  name: 'OSIS',
                  controller: OSIS,
                ),
                InputHelper(
                  name: 'firstName',
                  controller: firstName,
                ),
                InputHelper(
                  name: 'lastName',
                  controller: lastName,
                ),
                InputHelper(
                  name: 'UID',
                  controller: UID,
                ),
                InputHelper(
                  name: 'officialClass',
                  controller: officialClass,
                ),
                TextButton(
                    onPressed: () {
                      MyUser newUser = MyUser(
                        OSIS: OSIS.text,
                        firstName: firstName.text,
                        lastName: lastName.text,
                        UID: UID.text,
                        officialClass: officialClass.text,
                        favorites: user?.favorites,
                      );
                      UserDatabase().updateUser(newUser);
                      UserDatabase().retrieveUser();
                    },
                    child: Text(
                      'Update Profile',
                      style: TextStyle(fontSize: 20),
                    )),
              ],
            ),
          ),
        ),
      ],
    ));
  }
}

class InputHelper extends StatelessWidget {
  const InputHelper({required this.name, required this.controller, super.key});
  final String name;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(0),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          label: Text(
            name,
            style: TextStyle(fontSize: 12),
          ),
        ),
      ),
    );
  }
}
