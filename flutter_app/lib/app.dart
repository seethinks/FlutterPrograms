import 'dart:async';

import 'package:flutter/foundation.dart' show defaultTargetPlatform;
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart' show timeDilation;

import 'package:url_launcher/url_launcher.dart';

import 'widgets/home/home.dart';
import 'widgets/find/find.dart';
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
  var _find = Find();
  var _mine = Mine();
  List<Widget> _pages;

  @override
  void initState() {
    _pages = [_home, _find, _mine];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar( // 底部导航
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), title: Text(_home.title)),
          BottomNavigationBarItem(icon: Icon(Icons.list), title: Text(_find.title)),
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

