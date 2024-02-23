import 'package:flutter/material.dart';

class CRUDView extends StatefulWidget {
  const CRUDView({super.key});

  @override
  State<CRUDView> createState() => _CRUDViewState();
}

class _CRUDViewState extends State<CRUDView> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text('CRUDView')),
    );
  }
}
