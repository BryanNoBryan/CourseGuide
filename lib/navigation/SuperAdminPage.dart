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
      body: SafeArea(
        child: widget.child,
      ),
    );
  }
}
