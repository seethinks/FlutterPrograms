import 'package:flutter/material.dart';

class ThinnerAppBar extends StatefulWidget {
  ThinnerAppBar({
    this.title,
  });
  final String title;
  _ThinnerAppBarState createState() => _ThinnerAppBarState();
}

class _ThinnerAppBarState extends State<ThinnerAppBar> {
  @override
  Widget build(BuildContext context) {
    return PreferredSize(
      child: AppBar(
        title: Text(
          widget.title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.normal,
          ),
        ),
      ),
      preferredSize: Size.fromHeight(44),
    );
  }
}