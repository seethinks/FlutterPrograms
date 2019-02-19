import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'dart:async';
import '../base/base_page.dart';
import '../base/update_state_mixin.dart';
import '../../bean/spec.dart';
import '../../manager/programs_manager.dart';
import '../common/separator.dart';
import '../common/empty_widget.dart';
import '../common/download_button.dart';
import '../../tools/event_bus.dart';
import '../../tools/logging.dart';

enum FindPageIndex { empty, list }

class Find extends BasePage {
  String title = "发现";
  static const String routeName = '/Find';
  List<Spec> specs = <Spec>[];

  _FindState createState() => _FindState();
}

class _FindState extends State<Find>
    with AutomaticKeepAliveClientMixin, UpdateStateMixin<Find> {
  final GlobalKey<EmptyWidgetState> _emptyWidgetKey =
      GlobalKey<EmptyWidgetState>();
  FindPageIndex get _widgetIndex =>
      (_itemsInfo.length == 0) ? FindPageIndex.empty : FindPageIndex.list;

  var _itemsInfo = <ProgramItemInfo>[];

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
              slivers: <Widget>[
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (BuildContext context, int index) {
                      var item = _itemsInfo[index];
                      return ProgramItemWidget(info: item);
                    },
                    childCount: _itemsInfo.length,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<ProgramItemInfo> _getProgramItems() {
    var specMap = <String, Spec>{};
    widget.specs.forEach((f) => specMap[f.id] = f);

    var delItems = <ProgramItemInfo>[];
    for (var item in _itemsInfo) {
      if (specMap.keys.contains(item.spec.id) == false) {
        delItems.add(item);
      }
    }

    var itemMap = <String, ProgramItemInfo>{};
    _itemsInfo.forEach((f) => itemMap[f.spec.id] = f);

    var addSpecs = <Spec>[];
    for (var spec in widget.specs) {
      if (itemMap.keys.contains(spec.id) == false) {
        addSpecs.add(spec);
      }
    }

    for (var delItem in delItems) {
      _itemsInfo.remove(delItem);
    }

    for (var spec in addSpecs) {
      var index = widget.specs.indexOf(spec);
      var item = ProgramItemInfo(
        index: index,
        spec: widget.specs[index],
        showProcess: false,
        processValue: 0.0,
        buttonTitle: '添加',
        buttonOnPressed: (ProgramItemInfo info) {
          downloadProgram(info);
        },
        itemOnPressed: (ProgramItemInfo info) {
          // downloadProgram(info);
        },
        isLastItem: index == widget.specs.length - 1,
      );
      _itemsInfo.add(item);
    }
    return _itemsInfo;
  }

  Future<void> _fetchSpecs({bool fromRemote = true}) async {
    var completer = new Completer();
    ProgramsManager().fetchFindList(fromRemote: fromRemote).then((specs) {
      setState(() {
        widget.specs.clear();
        widget.specs = specs;
        _getProgramItems();
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

  Future<void> _handleProgramDownloadComplate(Spec spec) async {
    bus.emit(EventTypes.localProgramChanged);
    return _fetchSpecs(fromRemote: false);
  }

  Future<void> downloadProgram(ProgramItemInfo itemInfo) async {
    try {
      await ProgramsManager().downloadProgram(itemInfo.spec,
          onProgress: (received, total) {
        if (total != -1) {
          updateState(() {
            var _itemInfo = _itemsInfo[_itemsInfo.indexOf(itemInfo)];
            _itemInfo.processValue = (received / total);
            _itemInfo.showProcess = true;
          });
        }
      });
      if (mounted) {
        _itemsInfo.remove(itemInfo);
        updateState(() {});
      }
    } catch (e) {}
  }

  @override
  void dispose() {
    bus.off(EventTypes.localProgramChanged);
    super.dispose();
  }
}

class ProgramItemInfo {
  ProgramItemInfo({
    this.index,
    this.spec,
    this.showProcess,
    this.processValue,
    this.buttonTitle,
    this.buttonOnPressed,
    this.itemOnPressed,
    this.isLastItem,
  });

  int index;
  Spec spec;
  bool showProcess;
  double processValue;
  String buttonTitle;
  void Function(ProgramItemInfo info) buttonOnPressed;
  void Function(ProgramItemInfo info) itemOnPressed;
  bool isLastItem;
}

class ProgramItemWidget extends StatefulWidget {
  ProgramItemWidget({
    Key key,
    this.info,
  }) : super(key: key);

  final ProgramItemInfo info;

  _ProgramItemWidgetState createState() => _ProgramItemWidgetState();
}

class _ProgramItemWidgetState extends State<ProgramItemWidget>
    with UpdateStateMixin<ProgramItemWidget> {
  @override
  Widget build(BuildContext context) {
    final Widget row = GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          showFindPage(context, widget.info.spec);
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
                      image: NetworkImage(widget.info.spec.iconUrl),
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
                        widget.info.spec.name,
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
                          widget.info.spec.description,
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
                  child: DownloadButton2(
                    title: widget.info.buttonTitle,
                    showProcess: widget.info.showProcess,
                    progressValue: widget.info.processValue,
                    onPressed: buttonOnPressed,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(right: 15),
                ),
              ],
            ),
          ),
        ));

    if (widget.info.isLastItem) {
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

  void buttonOnPressed() {
    widget.info.buttonOnPressed(widget.info);
  }

  @override
  void dispose() {
    log.info('find item dispose' + widget.info.spec.id);
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
