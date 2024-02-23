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
      body: SafeArea(
        child: widget.child,
      ),
    );
  }
}
