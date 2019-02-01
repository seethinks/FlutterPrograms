import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import '../spec.dart';

class FindPage extends StatefulWidget {
  const FindPage({this.spec});
  static const String routeName = '/find/page';
  final ProgramSpec spec;

  @override
  State<StatefulWidget> createState() => FindPageState();
}

class FindPageState extends State<FindPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        top: false,
        bottom: false,
        child: ListView(
          children: <Widget>[
            const Padding(padding: EdgeInsets.only(top: 16.0)),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Container(
                    height: 128.0,
                    width: 128.0,
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(28.0),
                        child: Image(
                          image: NetworkImage(widget.spec.iconUrl),
                        )),
                  ),
                  const Padding(padding: EdgeInsets.only(left: 18.0)),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Text(
                          widget.spec.name,
                          style: const TextStyle(
                              fontSize: 24.0, fontWeight: FontWeight.bold),
                        ),
                        const Padding(padding: EdgeInsets.only(top: 6.0)),
                        Text(
                          widget.spec.author,
                          style: const TextStyle(
                            color: Color(0xFF8E8E93),
                            fontSize: 16.0,
                            fontWeight: FontWeight.w100,
                          ),
                        ),
                        const Padding(padding: EdgeInsets.only(top: 20.0)),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            CupertinoButton(
                              color: CupertinoColors.activeBlue,
                              minSize: 30.0,
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 24.0),
                              borderRadius: BorderRadius.circular(32.0),
                              child: const Text(
                                '添加',
                                style: TextStyle(
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: -0.28,
                                ),
                              ),
                              onPressed: () {},
                            ),
                            CupertinoButton(
                              color: CupertinoColors.activeBlue,
                              minSize: 30.0,
                              padding: EdgeInsets.zero,
                              borderRadius: BorderRadius.circular(32.0),
                              child: const Icon(CupertinoIcons.ellipsis,
                                  color: CupertinoColors.white),
                              onPressed: () {},
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
            ),
            SizedBox(
              height: (MediaQuery.of(context).size.width / 3 * 2),
              // width: (MediaQuery.of(context).size.width / 3 * 2) * 0.56,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: widget.spec.images.length,
                itemBuilder: (BuildContext context, int index) {
                  return Padding(
                      padding: const EdgeInsets.only(left: 16.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(6),
                        child: Image(
                          image: NetworkImage(widget.spec.images[index]),
                        ),
                      ));
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
