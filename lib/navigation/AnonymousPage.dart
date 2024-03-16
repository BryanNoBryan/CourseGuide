import 'package:course_guide/MyColors.dart';
import 'package:course_guide/navigation/MyNavigator.dart';
import 'package:course_guide/widgets/IconTextButton.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AnonymousPage extends StatefulWidget {
  const AnonymousPage({super.key, required this.child});

  final StatefulNavigationShell child;

  @override
  State<AnonymousPage> createState() => _AnonymousPageState();
}

class _AnonymousPageState extends State<AnonymousPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Guest'),
        surfaceTintColor: MyColors.lightYellow,
        elevation: 5,
        actions: [
          IconTextButton(
            icon: Icon(Icons.person),
            onPressed: () {
              MyNavigator.shell.goBranch(0);
              MyNavigator.router.go(MyNavigator.loginPath);
            },
            label: 'Sign In / Sign Up',
          ),
        ],
      ),
      body: SafeArea(
        child: widget.child,
      ),
    );
  }
}
