import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'dart:async';
import '../base/base_page.dart';
import '../base/update_state_mixin.dart';
import '../../bean/spec.dart';
import '../../common/separator.dart';
import '../../manager/programs_manager.dart';
import '../../common/empty_widget.dart';
import '../../common/download_button.dart';
import '../../tools/event_bus.dart';
import '../../tools/logging.dart';

enum FindPageIndex { empty, list }

class Find extends BasePage {
  String title = "发现";
  static const String routeName = '/Find';
  List<Spec> specs = <Spec>[];

  _FindState createState() => _FindState();
}

class _FindState extends State<Find> with AutomaticKeepAliveClientMixin {
  final GlobalKey<EmptyWidgetState> _emptyWidgetKey =
      GlobalKey<EmptyWidgetState>();
  FindPageIndex get _widgetIndex =>
      (widget.specs.length == 0) ? FindPageIndex.empty : FindPageIndex.list;

  Map<String, Widget> _cache = <String, Widget>{};

  @override
  void initState() {
    super.initState();
    log.info('Find initState');
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _emptyWidgetKey.currentState.loading();
    });
    bus.on(EventTypes.localProgramChanged, (f) {
      _fetchSpecs();
    });
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    var index = _widgetIndex.index;
    return Scaffold(
      // appBar: AppBar(title: Text(widget.title)),
      body: IndexedStack(
        index: index,
        children: <Widget>[
          // 空白页
          EmptyWidget(
            key: _emptyWidgetKey,
            icon: Icons.camera,
            message: "没有可添加应用，试试点击刷新~",
            onRefresh: _handlePullRefresh,
          ),
          // 列表页
          RefreshIndicator(
            onRefresh: _handlePullRefresh,
            child: CustomScrollView(
              key: PageStorageKey('value'),
              slivers: <Widget>[
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                      (BuildContext context, int index) {
                    return _findItem(index: index);
                    // return FindItem(
                    //   index: index,
                    //   lastItem: index == widget.specs.length - 1,
                    //   spec: widget.specs[index],
                    //   onComplate: (int index, Spec spec, bool isComplate) {
                    //     _handleProgramDownloadComplate(spec);
                    //   },
                    // );
                  }, childCount: widget.specs.length),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _findItem({int index}) {
    Spec spec = widget.specs[index];

    if (_cache.containsKey(spec.id)) {
      return _cache[spec.id];
    } else {
      var item = FindItem(
        index: index,
        lastItem: index == widget.specs.length - 1,
        spec: widget.specs[index],
        onComplate: (int index, Spec spec, bool isComplate) {
          _handleProgramDownloadComplate(spec);
        },
      );
      _cache[spec.id] = item;
      return item;
    }
  }

  Future<void> _fetchSpecs({bool fromRemote = true}) async {
    var completer = new Completer();
    ProgramsManager().fetchFindList(fromRemote: fromRemote).then((specs) {
      setState(() {
        widget.specs.clear();
        widget.specs = specs;
      });
      completer.complete();
    }).catchError((e) {
      // log.info(e);
      setState(() {});
      completer.complete();
    });
    return completer.future;
  }

  Future<void> _handlePullRefresh() async {
    return _fetchSpecs();
  }

  Future<void> _handleProgramDownloadComplate(Spec spec) async {
    _cache.remove(spec.id);
    bus.emit(EventTypes.localProgramChanged);
    return _fetchSpecs(fromRemote: false);
  }

  @override
  void dispose() {
    bus.off(EventTypes.localProgramChanged);
    super.dispose();
  }
}

class FindItem extends StatefulWidget {
  FindItem({this.index, this.lastItem, this.spec, this.onComplate});

  final int index;
  final bool lastItem;
  final Spec spec;
  final void Function(int index, Spec spec, bool isComplate) onComplate;

  _FindItemState createState() => _FindItemState();
}

class _FindItemState extends State<FindItem> with UpdateStateMixin<FindItem> {
  double _downloadProcess = 0.0;
  String _itemButtonTitle = '添加';

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
                  height: 80,
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
                      Padding(padding: EdgeInsets.only(top: 12.0)),
                      // 应用名称
                      Text(
                        widget.spec.name,
                        style: TextStyle(
                          color: Color(0xFF3333333),
                          fontSize: 18.0,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Padding(padding: EdgeInsets.only(top: 8.0)),
                      // 描述
                      Expanded(
                        child: Text(
                          widget.spec.description,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: Color(0xFF8E8E93),
                            fontSize: 16.0,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                      ),
                      Padding(padding: EdgeInsets.only(top: 12.0)),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(right: 12),
                ),
                // 按钮
                Container(
                  width: 80,
                  height: 40,
                  child: DownloadButton(
                    progress: _downloadProcess,
                    title: _itemButtonTitle,
                    onPressed: downloadProgram,
                  ),
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

  Future<void> downloadProgram() async {
    try {
      await ProgramsManager().downloadProgram(widget.spec,
          onProgress: (received, total) {
        if (total != -1) {
          updateState(() {
            _downloadProcess = (received / total);
          });
        }
      });
      updateState(() {
        _downloadProcess = 0.0;
      });
      widget.onComplate(widget.index, widget.spec, true);
    } catch (e) {}
  }

  @override
  void dispose() {
    log.info('find item dispose');
    super.dispose();
  }

  void showFindPage(BuildContext context, Spec spec) {
    // Navigator.push(
    //     context,
    //     MaterialPageRoute<void>(
    //       settings: const RouteSettings(name: '/find/page'),
    //       builder: (BuildContext context) => FindPage(spec: spec),
    //     ));
  }
}
