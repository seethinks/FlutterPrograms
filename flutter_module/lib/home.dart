import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  String title = "首页";
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title)
      ),
      body: Text("find"),
    );
  }
}