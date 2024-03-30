import 'dart:async';
import 'dart:developer';

import 'package:course_guide/content/placeholder.dart';
import 'package:course_guide/navigation/MyNavigator.dart';
import 'package:course_guide/providers/user_state.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';

class VerifyEmail extends StatefulWidget {
  const VerifyEmail({super.key});

  @override
  State<VerifyEmail> createState() => _VerifyEmailState();
}

class _VerifyEmailState extends State<VerifyEmail> {
  Timer? timer;
  bool isEmailVerified = false;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      UserState user = Provider.of<UserState>(context, listen: false);
      if (user.verified) {
        timer?.cancel();
        MyNavigator.calculateNavigation();
      } else {
        sendVerificationEmail();
      }

      timer = Timer.periodic(const Duration(seconds: 3), (_) async {
        await FirebaseAuth.instance.currentUser!.reload();
        setState(() {
          isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;
          log('verified $isEmailVerified');
        });
        checkVerification();
      });
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  void checkVerification() {
    if (isEmailVerified) {
      timer?.cancel();
      log('verification check');
      MyNavigator.calculateNavigation();
    }
  }

  void sendVerificationEmail() async {
    try {
      final user = FirebaseAuth.instance.currentUser!;
      await user.sendEmailVerification();
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(e.toString())));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UserState>(
      builder: (context, value, child) {
        log('verified: ' + value.verified.toString());

        WidgetsBinding.instance.addPostFrameCallback((_) {
          checkVerification();
        });

        return Center(
            child: Column(
          children: [
            const Text(
              "Check your email for verification.",
              style: TextStyle(
                fontSize: 24,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
                onPressed: () {
                  sendVerificationEmail();
                },
                icon: const Icon(Icons.email, size: 32),
                label: const Text(
                  'Resend Email',
                  style: TextStyle(fontSize: 32),
                )),
            SizedBox(
              height: 10,
            ),
            ElevatedButton(
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
                MyNavigator.router.pushReplacement(MyNavigator.loginPath);
              },
              child: Text('Cancel'),
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
          ],
        ));
      },
    );
  }
}
