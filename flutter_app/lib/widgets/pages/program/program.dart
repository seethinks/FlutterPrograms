import 'package:flutter/material.dart';
import '../../../assert.dart';
import './find.dart';
import './favorite.dart';

class Program extends BasePage {
  Program() : super(title: '发现');
  static const String routeName = '/Program';
  final tabViews = <BasePage>[Find(), Favorite()];

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
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(44),
        child: AppBar(
          title: TabBar(
            controller: _controller,
            isScrollable: true,
            labelStyle: TextStyle(
              fontSize: 16,
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
      ),
      body: TabBarView(
        controller: _controller,
        children: widget.tabViews,
      ),
    );
  }
}
