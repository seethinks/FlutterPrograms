import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'dart:async';
import '../../bean/spec.dart';
import '../../common/separator.dart';
import '../../manager/programs_manager.dart';
import '../../common/empty_widget.dart';
import '../../common/download_button.dart';
import '../../tools/logging.dart';
import '../base/base_page.dart';
import '../base/update_state_mixin.dart';
import '../../tools/event_bus.dart';

enum FavoritePageIndex { empty, list }

class Favorite extends BasePage {
  Favorite({Key key}) : super(key: key);
  String title = "收藏";
  static const String routeName = '/Find';
  List<Spec> specs = <Spec>[];

  _FavoriteState createState() => _FavoriteState();
}

class _FavoriteState extends State<Favorite>
    with AutomaticKeepAliveClientMixin {
  final GlobalKey<EmptyWidgetState> _emptyWidgetKey =
      GlobalKey<EmptyWidgetState>();
  FavoritePageIndex get _widgetIndex => (widget.specs.length == 0)
      ? FavoritePageIndex.empty
      : FavoritePageIndex.list;

  @override
  void initState() {
    super.initState();
    log.info('Favorite initState');
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
            icon: Icons.error,
            message: "还没有收藏应用，去发现中添加吧~",
            onRefresh: _handlePullRefresh,
          ),
          // 列表页
          RefreshIndicator(
            onRefresh: _handlePullRefresh,
            child: CustomScrollView(
              slivers: <Widget>[
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                      (BuildContext context, int index) {
                    return FavoriteItem(
                      index: index,
                      lastItem: index == widget.specs.length - 1,
                      spec: widget.specs[index],
                      onComplate: (bool isComplate) {
                        _handleProgramDownloadComplate();
                      },
                    );
                  }, childCount: widget.specs.length),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _fetchSpecs({bool fromRemote = false}) async {
    var completer = new Completer();
    ProgramsManager().fetchFavoriteList(fromRemote: fromRemote).then((specs) {
      setState(() {
        widget.specs.clear();
        widget.specs = specs;
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

  Future<void> _handleProgramDownloadComplate() async {
    bus.emit(EventTypes.localProgramChanged);
    return _fetchSpecs(fromRemote: false);
  }

  @override
  void dispose() {
    bus.off(EventTypes.localProgramChanged);
    super.dispose();
  }
}

class FavoriteItem extends StatefulWidget {
  FavoriteItem({this.index, this.lastItem, this.spec, this.onComplate});

  final int index;
  final bool lastItem;
  final Spec spec;
  final void Function(bool isComplate) onComplate;

  _FavoriteItemState createState() => _FavoriteItemState();
}

class _FavoriteItemState extends State<FavoriteItem>
    with UpdateStateMixin<FavoriteItem> {
  double _downloadProcess = 0.0;

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
                    onPressed: _itemButtonOnPressed,
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
      if (mounted) {
        updateState(() {
          _downloadProcess = 0.0;
        });
      }
      widget.onComplate(true);
    } catch (e) {}
  }

  String get _itemButtonTitle {
    if (widget.spec.canUpdate == true) {
      return '升级';
    } else {
      return '打开';
    }
  }

  Future<void> _itemButtonOnPressed() async {
    if (widget.spec.canUpdate == true) {
      await downloadProgram();
    }
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
