import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:course_guide/firebase_options.dart';
import 'package:course_guide/providers/UserDatabase.dart';
import 'package:course_guide/providers/app_state.dart';
import 'package:course_guide/providers/database.dart';
import 'package:firebase_auth/firebase_auth.dart'
    hide EmailAuthProvider, PhoneAuthProvider;
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'navigation/MyNavigator.dart';
import 'providers/user_state.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FirebaseUIAuth.configureProviders([
    EmailAuthProvider(),
  ]);

  MyNavigator();

  // if (kDebugMode) {
  //   try {
  //     FirebaseFirestore.instance.useFirestoreEmulator('localhost', 8080);

  //     //NEVER FORGOT - THIS LINE WAS 8 HOURS OF DEBUGGING
  //     FirebaseFunctions.instance.useFunctionsEmulator('localhost', 5001);
  //     //

  //     await FirebaseAuth.instance.useAuthEmulator('localhost', 9099);
  //   } catch (e) {
  //     // ignore: avoid_print
  //     print(e);
  //   }
  // }

  UserState();
  AppState();
  UserDatabase();
  await Database().retrieveCourses();

  //calculate after initializing providers
  MyNavigator.calculateNavigation();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) {
            return AppState();
          },
        ),
        ChangeNotifierProvider(
          create: (context) {
            return UserState();
          },
        ),
      ],
      child: MaterialApp.router(
        theme: ThemeData(
            fontFamily: 'OpenSans',
            primarySwatch: Colors.blue,
            colorScheme: const ColorScheme(
              brightness: Brightness.light,
              primary: Color(0xFF202020),
              onPrimary: Color(0xFF505050),
              secondary: Color(0xFFBBBBBB),
              onSecondary: Color.fromARGB(255, 66, 69, 73),
              error: Color(0xFFF32424),
              onError: Color(0xFFF32424),
              background: Color.fromARGB(255, 118, 125, 134),
              onBackground: Color.fromARGB(37, 114, 137, 218),
              surface: Color.fromARGB(255, 255, 255, 255),
              onSurface: Color.fromARGB(255, 0, 0, 0),
            )),
        debugShowCheckedModeBanner: false,
        routerConfig: MyNavigator.router,
        title: 'Course Guide',
      ),
    );
  }
}
