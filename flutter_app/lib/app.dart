import 'package:flutter/material.dart';
import 'tools/utils.dart';
import 'tools/logging.dart';

import 'package:flutter/foundation.dart' show defaultTargetPlatform;
import 'package:url_launcher/url_launcher.dart';

import 'widgets/pages/home/home.dart';
import 'widgets/pages/program/program.dart';
import 'widgets/pages/about/about.dart';
import 'widgets/base/base_page.dart';

class Main extends StatefulWidget {
  Main({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MainState createState() => _MainState();
}

class _MainState extends State<Main> {
  int _activeIndex = 0;
  var _home = Home();
  var _program = Program();
  var _about = About();
  List<BasePage> get _pages {
    return [_home, _program, _about];
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: BottomNavigationBar(
          // 底部导航
          items:buildBarItems(context),
          currentIndex: _activeIndex,
          onTap: _onItemTapped,
        ),
        body: IndexedStack(
          children: _pages,
          index: _activeIndex,
        ));
  }

  void _onItemTapped(int index) {
    setState(() {
      _activeIndex = index;
    });
  }

  List<BottomNavigationBarItem> buildBarItems(BuildContext context) {
    var items = [
      BottomNavigationBarItem(icon: Icon(Icons.home), title: Text(_home.title)),
      BottomNavigationBarItem(
          icon: Icon(Icons.camera), title: Text(_program.title)),
      BottomNavigationBarItem(
          icon: Icon(Icons.error), title: Text(_about.title)),
    ];
    return items;
  }
}
