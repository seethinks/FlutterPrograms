import 'package:flutter/material.dart';

class Mine extends StatefulWidget {
  String title = "我的";
  _MineState createState() => _MineState();
}

class _MineState extends State<Mine> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title)
      ),
      body: Text("我的"),
    );
  }
}