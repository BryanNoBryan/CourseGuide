import 'package:flutter/material.dart';

class PermissionsView extends StatefulWidget {
  const PermissionsView({super.key});

  @override
  State<PermissionsView> createState() => _PermissionsViewState();
}

class _PermissionsViewState extends State<PermissionsView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text('PermissionsView')),
    );
  }
}
