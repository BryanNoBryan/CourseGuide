import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AdminPage extends StatefulWidget {
  const AdminPage({super.key, required this.child});

  final StatefulNavigationShell child;

  @override
  State<AdminPage> createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Course Guide'),
        centerTitle: true,
        elevation: 0,
        actions: [],
      ),
      body: SafeArea(
        child: widget.child,
      ),
    );
  }
}
