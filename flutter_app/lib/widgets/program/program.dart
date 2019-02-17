import 'package:flutter/material.dart';
import '../base/base_page.dart';
import './find.dart';
import './favorite.dart';

class Program extends StatefulWidget {
  String title = "程序";
  static const String routeName = '/Program';
  var tabViews = <BasePage>[Find(), Favorite()];

  ProgramState createState() => ProgramState();
}

class ProgramState extends State<Program> with SingleTickerProviderStateMixin {
  TabController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TabController(vsync: this, length: widget.tabViews.length);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TabBar(
          controller: _controller,
          isScrollable: true,
          labelStyle: TextStyle(
            fontSize: 20,
          ),
          indicator: ShapeDecoration(
            shape: const StadiumBorder(
                  side: BorderSide(
                    color: Colors.white24,
                    width: 2.0,
                  ),
                ) +
                const StadiumBorder(
                  side: BorderSide(
                    color: Colors.transparent,
                    width: 4.0,
                  ),
                ),
          ),
          tabs: widget.tabViews.map((f) => Tab(text: f.title)).toList(),
        ),
      ),
      body: TabBarView(
        controller: _controller,
        children: widget.tabViews,
      ),
    );
  }
}
