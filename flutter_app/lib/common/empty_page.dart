import 'package:flutter/material.dart';
import './loading_page.dart';

class EmptyPage extends StatefulWidget {
  EmptyPage(this.icon, this.message, this.onRefresh);

  final IconData icon;
  final String message;
  final RefreshCallback onRefresh;

  _EmptyPageState createState() => _EmptyPageState();
}

class _EmptyPageState extends State<EmptyPage> {

  var _indexPage = 0;

  @override
  Widget build(BuildContext context) {
    return IndexedStack(
      index: _indexPage,
      children: <Widget>[
        InkWell(
          onTap: onTap,
          child: Container(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(
                    widget.icon,
                    color: Colors.lightBlue,
                    size: 80,
                  ),
                  Padding(padding: EdgeInsets.only(top: 12),),
                  Text(
                    widget.message,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16.0,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        LoadingPage(),
      ],
    );
  }

  void onTap() {
    widget.onRefresh();
    // setState(() {
    //   _indexPage = 0;
    // });
    // widget.onRefresh().then((v) {
    //   setState(() {
    //     _indexPage = 0;
    //   });
    // });
  }
}
