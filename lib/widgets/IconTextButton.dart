import 'package:flutter/material.dart';

class IconTextButton extends StatefulWidget {
  const IconTextButton(
      {required this.icon,
      required this.onPressed,
      required this.label,
      super.key});

  final Icon icon;
  final Function() onPressed;
  final String label;

  @override
  State<IconTextButton> createState() => _IconTextButtonState();
}

class _IconTextButtonState extends State<IconTextButton> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(10),
      // padding: EdgeInsets.all(5),
      child: TextButton.icon(
        onPressed: widget.onPressed,
        icon: widget.icon,
        label: Text(
          widget.label,
          style: TextStyle(fontSize: 20),
        ),
        style: TextButton.styleFrom(
          backgroundColor: const Color.fromARGB(255, 201, 238, 255),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
          ),
        ),
      ),
    );
  }
}
