import 'package:flutter/material.dart';
import 'tools/utils.dart';
import 'tools/logging.dart';

import 'package:flutter/foundation.dart' show defaultTargetPlatform;
import 'package:url_launcher/url_launcher.dart';

import 'widgets/home/home.dart';
import 'widgets/program/program.dart';
import 'widgets/mine/mine.dart';



class Main extends StatefulWidget {
  Main({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MainState createState() => _MainState();
}

class _MainState extends State<Main> {

  int _selectedIndex = 0;
  var _home = Home();
  var _program = Program();
  var _mine = Mine();
  List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [_home, _program, _mine];
    var rootPath = 
    Utils.getProgramRootPath().then((p) => log.info('Programs Path: ' + p));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar( // 底部导航
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), title: Text(_home.title)),
          BottomNavigationBarItem(icon: Icon(Icons.camera), title: Text(_program.title)),
          BottomNavigationBarItem(icon: Icon(Icons.person), title: Text(_mine.title)),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
      body: IndexedStack(
        children: _pages,
        index: _selectedIndex,
      )
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
}

