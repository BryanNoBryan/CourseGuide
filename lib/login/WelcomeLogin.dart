import 'dart:developer';

import 'package:course_guide/navigation/MyNavigator.dart';
import 'package:firebase_auth/firebase_auth.dart' hide EmailAuthProvider;
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    log('happened?');

    if (FirebaseAuth.instance.currentUser != null) {
      MyNavigator.router.pushReplacement(MyNavigator.verifyEmailPath);
    }

    //CHANGE LOGIC HERE SO THAT IF CURRENTUSER NO EXIST -> AUTO ANONYMOUS SIGN IN
    //ADD A BUTTON TO LOWEST TIER TO SIGN IN

    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return SignInScreen(
            providers: [
              EmailAuthProvider(),
            ],
            actions: [
              ForgotPasswordAction(((context, email) {
                final uri = Uri(
                  path: MyNavigator.forgotPasswordPath,
                  queryParameters: <String, String?>{
                    'email': email,
                  },
                );
                context.push(uri.toString());
              })),
              AuthStateChangeAction(((context, state) {
                final user = switch (state) {
                  SignedIn state => state.user,
                  UserCreated state => state.credential.user,
                  _ => null
                };
                if (user == null) {
                  return;
                }
                if (state is UserCreated) {
                  user.updateDisplayName(user.email!.split('@')[0]);
                }
                if (FirebaseAuth.instance.currentUser!.emailVerified == true) {
                  MyNavigator.router
                      .pushReplacement(MyNavigator.CRUDViewAdminPath);
                }
                MyNavigator.router.pushReplacement(MyNavigator.verifyEmailPath);
              })),
            ],
            headerBuilder: (context, constraints, shrinkOffset) {
              return Padding(
                padding: const EdgeInsets.all(10),
                child: AspectRatio(
                  aspectRatio: 1.647,
                  child: Image.asset('images/icon.png'),
                ),
              );
            },
            subtitleBuilder: (context, action) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: action == AuthAction.signIn
                    ? const Text(
                        'Welcome to BxSci Course Guide, please sign in!')
                    : const Text(
                        'Welcome to BxSci Course Guide, please sign up!'),
              );
            },
            footerBuilder: (context, action) {
              return const Padding(
                padding: EdgeInsets.only(top: 16),
                child: Text(
                  'By signing in, you agree to our terms and conditions.',
                  style: TextStyle(color: Colors.grey),
                ),
              );
            },
            sideBuilder: (context, shrinkOffset) {
              return Padding(
                padding: const EdgeInsets.all(20),
                child: AspectRatio(
                  aspectRatio: 1.647,
                  child: Image.asset('images/icon.png'),
                ),
              );
            },
          );
        }

        return const Placeholder();
      },
    );
  }
}
