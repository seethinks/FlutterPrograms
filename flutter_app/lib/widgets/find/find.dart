import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'find_page.dart';
import '../../common/spec.dart';
import '../../common/common.dart';
import 'package:dio/dio.dart';
import 'dart:io';
import '../../tools/network.dart';

class Find extends StatefulWidget {
  String title = "发现";
  static const String routeName = '/Find';

  // https://raw.githubusercontent.com/FlutterPrograms/Specs/master/specs/specs.json


  _FindState createState() => _FindState();
}

class _FindState extends State<Find> {

  

  List<Spec> specs = <Spec>[];
  var version = "0.0.0";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchSpecs();
  }

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
                  lastItem: index == specs.length - 1,
                  spec: specs[index],
                );
              }, childCount: specs.length),
            )
          ],
        ));
  }

  void fetchSpecs() {
    Network.fetchSpecsList().then((respData) {
      specs.clear();
      setState(() {
        version = respData["version"];
        var specsJson = respData["specs"] as List;
        specsJson.forEach((s){
          var spec = Spec.fromJson(s);
          specs.add(spec);
        });
      });
    }).catchError((e) {

    });
  }
}

class FindItem extends StatefulWidget {
  FindItem({this.index, this.lastItem, this.spec});

  final int index;
  final bool lastItem;
  final Spec spec;

  String _process = "";

  _FindItemState createState() => _FindItemState();
}

class _FindItemState extends State<FindItem> {

  @override
  Widget build(BuildContext context) {
    final Widget row = GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          showFindPage(context, widget.spec);
        },
        child: Container(
          padding: EdgeInsets.only(top: 8, bottom: 8),
          child: SizedBox(
            height: 90,
            child: Row(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(left: 15),
                ),
                // icon 图片
                Container(
                  width: 80,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image(
                      image: NetworkImage(widget.spec.iconUrl),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(right: 12),
                ),
                // 应用名称、描述
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(padding: EdgeInsets.only(top: 8.0)),
                      Text(widget.spec.name),
                      Padding(padding: EdgeInsets.only(top: 8.0)),
                      Expanded(
                        child: Text(
                          widget.spec.description,
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: Color(0xFF8E8E93),
                            fontSize: 13.0,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                      ),
                      Padding(padding: EdgeInsets.only(top: 8.0)),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(right: 12),
                ),
                RaisedButton(
                  shape: StadiumBorder(),
                  child: Text(
                    '添加' + widget._process,
                    style: TextStyle(
                      fontSize: 14.0,
                      fontWeight: FontWeight.w700,
                      letterSpacing: -0.28,
                    ),
                  ),
                  onPressed: () {
                    
                    // debugPrint("test");
                    // showFindPage(context, spec);
                    // downFlutterAsserts();
                   fetchSpecs();
                  },
                ),
                Padding(
                  padding: EdgeInsets.only(right: 15),
                ),
              ],
            ),
          ),
        ));

    if (widget.lastItem) {
      return row;
    }

    return Column(
      children: <Widget>[
        row,
        Container(
          padding: EdgeInsets.only(left: 15),
          child: Separator(),
        ),
      ],
    );
  }

  void fetchSpecs() {
    
  }

  void showFindPage(BuildContext context, Spec spec) {
    // Navigator.push(
    //     context,
    //     MaterialPageRoute<void>(
    //       settings: const RouteSettings(name: '/find/page'),
    //       builder: (BuildContext context) => FindPage(spec: spec),
    //     ));
  }

  void downFlutterAsserts() async {
    var dio = new Dio();

    (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
        (HttpClient client) {
      client.idleTimeout = new Duration(seconds: 0);
    };

    // This is big file(about 200M)
    // var url = "http://download.dcloud.net.cn/HBuilder.9.0.2.macosx_64.dmg";

    // This is a image, about 4KB
    var url =
        "https://flutter.io/assets/flutter-lockup-4cb0ee072ab312e59784d9fbf4fb7ad42688a7fdaea1270ccf6bbf4f34b7e03f.svg";
    String dir = (await getApplicationDocumentsDirectory()).path;
    //var url = "https://github.com/wendux/tt"; //404
    try {
      Response response = await dio.download(
        url,
        "$dir/flutter.svg",
        onProgress: (received, total) {
          if (total != -1) {
            debugPrint((received / total * 100).toStringAsFixed(0) + "%");
            setState(() {
              widget._process = (received / total * 100).toStringAsFixed(0) + "%";
            });
          }
          
        },
        cancelToken: CancelToken(),
        options: Options(
          //receiveDataWhenStatusError: false,
          headers: {HttpHeaders.acceptEncodingHeader: "*"},
        ),
      );
      debugPrint("download succeed!");
    } catch (e) {
      debugPrint(e.response.data);
    }
  }
}
