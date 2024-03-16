import 'package:course_guide/MyColors.dart';
import 'package:course_guide/navigation/MyNavigator.dart';
import 'package:course_guide/widgets/IconTextButton.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class RegularUserPage extends StatefulWidget {
  const RegularUserPage({super.key, required this.child});

  final StatefulNavigationShell child;

  @override
  State<RegularUserPage> createState() => _RegularUserPageState();
}

class _RegularUserPageState extends State<RegularUserPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Regular User'),
        surfaceTintColor: MyColors.lightYellow,
        actions: [
          IconTextButton(
            icon: Icon(Icons.favorite),
            onPressed: () {
              MyNavigator.router.go(MyNavigator.CourseViewPath);
            },
            label: 'Courses',
          ),
          IconTextButton(
            icon: Icon(Icons.favorite),
            onPressed: () {
              MyNavigator.router.go(MyNavigator.favoritesPath);
            },
            label: 'Favorites',
          ),
          IconTextButton(
            icon: Icon(Icons.account_circle_outlined),
            onPressed: () {
              MyNavigator.router.go(MyNavigator.profilePath);
            },
            label: 'Profile',
          ),
        ],
      ),
      body: SafeArea(
        child: widget.child,
      ),
    );
  }
}
