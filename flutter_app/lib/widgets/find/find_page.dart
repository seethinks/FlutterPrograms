import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import '../../bean/spec.dart';
import '../../common/separator.dart';

// Program 详情页面
class FindPage extends StatefulWidget {
  
  const FindPage({this.spec});
  static const String routeName = '/find/page';
  final Spec spec;

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
            Padding(padding: EdgeInsets.only(top: 16.0)),
            FindPageHeader(widget.spec),
            Padding(padding: EdgeInsets.symmetric(vertical: 8.0)),
            FindPageIntroduce(widget.spec),
            Padding(padding: EdgeInsets.symmetric(vertical: 8.0)),
            FindPagePreview(widget.spec),
          ],
        ),
      ),
    );
  }
}

// Program 详情页 Header
class FindPageHeader extends StatefulWidget {
  FindPageHeader(
    this.spec,
  );
  final Spec spec;
  _FindPageHeaderState createState() => _FindPageHeaderState();
}

class _FindPageHeaderState extends State<FindPageHeader> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        Padding(padding: EdgeInsets.only(left: 25)),
        Container(
          height: 110.0,
          width: 110.0,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(26),
            child: Image(
              image: NetworkImage(widget.spec.iconUrl),
            ),
          ),
        ),
        Padding(padding: EdgeInsets.only(left: 18.0)),
        Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                widget.spec.name,
                style: const TextStyle(
                    fontSize: 24.0, fontWeight: FontWeight.bold),
              ),
              Padding(padding: EdgeInsets.only(top: 6.0)),
              Text(
                widget.spec.author,
                style: const TextStyle(
                  color: Color(0xFF8E8E93),
                  fontSize: 16.0,
                  fontWeight: FontWeight.w100,
                ),
              ),
              Padding(padding: EdgeInsets.only(top: 20.0)),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  CupertinoButton(
                    color: CupertinoColors.activeBlue,
                    minSize: 30.0,
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
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
        Padding(padding: EdgeInsets.only(right: 25)),
      ],
    );
  }
}

// Program 详情页 图片预览
class FindPagePreview extends StatefulWidget {
  FindPagePreview(
    this.spec,
  );
  final Spec spec;
  _FindPagePreviewState createState() => _FindPagePreviewState();
}

class _FindPagePreviewState extends State<FindPagePreview> {
  @override
  Widget build(BuildContext context) {
    return FindPageItem(
      title: "预览",
      child: Container(
        height: (MediaQuery.of(context).size.width / 3 * 2),
        child: ListView.builder(
          padding: EdgeInsets.only(left: 16, right: 16),
          scrollDirection: Axis.horizontal,
          itemCount: widget.spec.images.length,
          itemBuilder: (BuildContext context, int index) {
            return Padding(
                padding: EdgeInsets.only(left: 8.0, right: 8.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: Image(
                    image: NetworkImage(widget.spec.images[index]),
                  ),
                ));
          },
        ),
      ),
    );
  }
}

// Program 详情页 介绍
class FindPageIntroduce extends StatefulWidget {
  FindPageIntroduce(
    this.spec,
  );
  final Spec spec;
  _FindPageIntroduceState createState() => _FindPageIntroduceState();
}

class _FindPageIntroduceState extends State<FindPageIntroduce> {
  @override
  Widget build(BuildContext context) {
    return FindPageItem(
      title: "介绍",
      child: Container(
        padding: EdgeInsets.only(left: 25, right: 25),
        child: Text(widget.spec.description),
      ),
    );
  }
}

// Program 详情页 Item
class FindPageItem extends StatelessWidget {
  FindPageItem({Key key, this.title, this.child}) : super(key: key);
  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(left: 25, right: 25),
            child: Separator(),
          ),
          Container(
              padding: EdgeInsets.only(left: 25, right: 25, top: 10, bottom: 10),
              child: Text(
                title,
                style: const TextStyle(
                    fontSize: 20.0, fontWeight: FontWeight.bold),
              )),
          child
        ],
      ),
    );
  }
}
