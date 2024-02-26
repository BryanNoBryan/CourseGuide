import 'package:course_guide/MyColors.dart';
import 'package:course_guide/navigation/MyNavigator.dart';
import 'package:course_guide/widgets/IconTextButton.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SuperAdminPage extends StatefulWidget {
  const SuperAdminPage({super.key, required this.child});

  final StatefulNavigationShell child;

  @override
  State<SuperAdminPage> createState() => _SuperAdminPageState();
}

class _SuperAdminPageState extends State<SuperAdminPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Super Admin'),
        surfaceTintColor: MyColors.lightYellow,
        actions: [
          IconTextButton(
            icon: Icon(Icons.favorite),
            onPressed: () {
              MyNavigator.router.go(MyNavigator.favoritesPath);
            },
            label: 'Favorites',
          ),
          IconTextButton(
            icon: Icon(Icons.badge),
            onPressed: () {
              MyNavigator.router.go(MyNavigator.permissionsViewPath);
            },
            label: 'Perms',
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
