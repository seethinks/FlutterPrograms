import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'dart:async';
import '../base/base_page.dart';
import '../base/update_state_mixin.dart';
import '../../tools/logging.dart';
import '../../bean/spec.dart';
import '../../manager/programs_manager.dart';
import '../common/empty_widget.dart';
import '../../tools/event_bus.dart';

enum HomePageIndex { empty, list }

class Home extends BasePage {
  Home() : super(title: '首页');
  static const String routeName = '/Home';

  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final GlobalKey<EmptyWidgetState> _emptyWidgetKey =
      GlobalKey<EmptyWidgetState>();

  List<Spec> _specs = <Spec>[];

  HomePageIndex get _widgetIndex {
    return (_specs.length == 0) ? HomePageIndex.empty : HomePageIndex.list;
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _emptyWidgetKey.currentState.loading();
    });
    bus.on(EventTypes.localProgramChanged, (f) {
      _fetchSpecs();
    });
  }

  @override
  Widget build(BuildContext context) {
    var index = _widgetIndex.index;
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: IndexedStack(
        index: index,
        children: <Widget>[
          // 空白页
          EmptyWidget(
            key: _emptyWidgetKey,
            icon: Icons.error,
            message: "还没有收藏应用，去发现中添加吧~",
            onRefresh: _handlePullRefresh,
          ),
          Container(
            padding: EdgeInsets.only(top: 18, left: 18, right: 18),
            child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4, childAspectRatio: 0.8),
                itemCount: _specs.length,
                itemBuilder: (context, index) {
                  return HomeItem(
                    index: index,
                    lastItem: index == _specs.length - 1,
                    spec: _specs[index],
                    onPressed: () {
                      _handleItemPressed();
                    },
                  );
                }),
          ),
        ],
      ),
    );
  }

  Future<void> _fetchSpecs({bool fromRemote = false}) async {
    var completer = new Completer();
    ProgramsManager().fetchFavoriteList(fromRemote: fromRemote).then((specs) {
      setState(() {
        _specs.clear();
        _specs = specs;
      });
      completer.complete();
    }).catchError((e) {
      setState(() {});
      completer.complete();
    });
    return completer.future;
  }

  Future<void> _handlePullRefresh() async {
    return _fetchSpecs();
  }

  void _handleItemPressed() {
    log.info('message');
  }

  @override
  void dispose() {
    bus.off(EventTypes.localProgramChanged);
    super.dispose();
  }
}

class HomeItem extends StatefulWidget {
  HomeItem({this.index, this.lastItem, this.spec, this.onPressed});

  final int index;
  final bool lastItem;
  final Spec spec;
  final VoidCallback onPressed;

  _HomeItemState createState() => _HomeItemState();
}

class _HomeItemState extends State<HomeItem> with UpdateStateMixin<HomeItem> {
  double _downloadProcess = 0.0;

  @override
  Widget build(BuildContext context) {
    final Widget item = GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        widget.onPressed();
      },
      child: Container(
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(top: 12),
            ),
            Container(
              width: 65,
              height: 65,
              decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: Colors.grey,
                  width: 0.5,
                ),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image(
                  fit: BoxFit.cover,
                  image: NetworkImage(widget.spec.iconUrl),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 10),
            ),
            // 应用名称
            Text(
              widget.spec.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: Color(0xFF3333333),
                fontSize: 16.0,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
    return item;
  }
}
