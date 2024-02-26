import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class NavigationLoginPage extends StatefulWidget {
  const NavigationLoginPage({super.key, required this.child});

  final StatefulNavigationShell child;

  @override
  State<NavigationLoginPage> createState() => _NavigationLoginPageState();
}

class _NavigationLoginPageState extends State<NavigationLoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: widget.child,
      ),
    );
  }
}
