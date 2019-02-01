import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'find_page.dart';
import '../spec.dart';

class FindItem extends StatelessWidget {
  const FindItem({this.index, this.lastItem, this.spec});

  final int index;
  final bool lastItem;
  final ProgramSpec spec;

  @override
  Widget build(BuildContext context) {
    final Widget row = GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        showFindPage(context, spec);
      },
      child: SafeArea(
        top: false,
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.only(left: 16.0, top: 8.0, bottom: 8.0, right: 8.0),
          child: Row(
            children: <Widget>[
              Container(
                height: 60.0,
                width: 60.0,
                child: Image(
                  image: NetworkImage(spec.iconUrl),
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(spec.name),
                      const Padding(padding: EdgeInsets.only(top: 8.0)),
                      Text(
                        spec.description,
                        style: TextStyle(
                          color: Color(0xFF8E8E93),
                          fontSize: 13.0,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              CupertinoButton(
                padding: EdgeInsets.zero,
                child: const Icon(CupertinoIcons.plus_circled,
                  color: CupertinoColors.activeBlue,
                  semanticLabel: 'Add',
                ),
                onPressed: () { },
              ),
              CupertinoButton(
                padding: EdgeInsets.zero,
                child: const Icon(CupertinoIcons.share,
                  color: CupertinoColors.activeBlue,
                  semanticLabel: 'Share',
                ),
                onPressed: () { },
              ),
            ],
          ),
        ),
      ),
    );

    if (lastItem) {
      return row;
    }

    return Column(
      children: <Widget>[
        row,
        Container(
          height: 1.0,
          color: const Color(0xFFD9D9D9),
        ),
      ],
    );
  }

  void showFindPage(BuildContext context, ProgramSpec spec) {
    Navigator.push(context, MaterialPageRoute<void>(
      settings: const RouteSettings(name: '/find/page'),
      builder: (BuildContext context) => FindPage(spec: spec),
    ));
  }
}