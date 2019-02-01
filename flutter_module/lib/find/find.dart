import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'find_item.dart';
import 'find_page.dart';
import '../spec.dart';

class Find extends StatefulWidget {
  String title = "发现";
  static const String routeName = '/Find';

  List<ProgramSpec> specs = <ProgramSpec>[
    ProgramSpec(
      name: "test0",
      author: "author_test0",
      description: "description",
      iconUrl:
          "http://img.zcool.cn/community/01de4b58009420a84a0d304fc9998c.jpg@1280w_1l_2o_100sh.jpg",
      images: [
        "http://img.smzy.com/imges/2017/0522/20170522112924470.jpg",
        "http://img.smzy.com/imges/2017/0522/20170522112924470.jpg",
        "http://img.smzy.com/imges/2017/0522/20170522112924470.jpg",
        "http://img.smzy.com/imges/2017/0522/20170522112924470.jpg",
        "http://img.smzy.com/imges/2017/0522/20170522112924470.jpg"
      ],
      flutterAssertUrl: "",
    ),
    ProgramSpec(
      name: "test0",
      author: "author_test0",
      description: "description",
      iconUrl:
          "http://img.zcool.cn/community/01de4b58009420a84a0d304fc9998c.jpg@1280w_1l_2o_100sh.jpg",
      images: ["http://img.smzy.com/imges/2017/0522/20170522112924470.jpg"],
      flutterAssertUrl: "",
    ),
    ProgramSpec(
      name: "test0",
      author: "author_test0",
      description: "description",
      iconUrl:
          "http://img.zcool.cn/community/01de4b58009420a84a0d304fc9998c.jpg@1280w_1l_2o_100sh.jpg",
      images: ["http://img.smzy.com/imges/2017/0522/20170522112924470.jpg"],
      flutterAssertUrl: "",
    ),
    ProgramSpec(
      name: "test0",
      author: "author_test0",
      description: "description",
      iconUrl:
          "http://img.zcool.cn/community/01de4b58009420a84a0d304fc9998c.jpg@1280w_1l_2o_100sh.jpg",
      images: ["http://img.smzy.com/imges/2017/0522/20170522112924470.jpg"],
      flutterAssertUrl: "",
    )
  ];

  _FindState createState() => _FindState();
}

class _FindState extends State<Find> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text(widget.title)),
        body: CustomScrollView(
          slivers: <Widget>[
            SliverList(
              delegate:
                  SliverChildBuilderDelegate((BuildContext context, int index) {
                return FindItem(
                  index: index,
                  lastItem: index == widget.specs.length - 1,
                  spec: widget.specs[index],
                );
              }, childCount: widget.specs.length),
            )
          ],
        ));
  }
}
