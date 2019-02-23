import 'package:flutter/material.dart';
import 'dart:async';
import '../../../assert.dart';

enum FavoritePageIndex { empty, list }

class Favorite extends BasePage {
  Favorite() : super(title: '收藏');
  static const String routeName = '/Find';

  _FavoriteState createState() => _FavoriteState();
}

class _FavoriteState extends State<Favorite>
    with AutomaticKeepAliveClientMixin {
  final GlobalKey<EmptyWidgetState> _emptyWidgetKey =
      GlobalKey<EmptyWidgetState>();

  var _itemsInfo = <ProgramItemInfo>[];
  List<Spec> _specList = <Spec>[];

  List<Spec> get _specs => _specList;
  set _specs(List<Spec> specs) {
    _specList = specs;
    _trimProgramItems(spec: _specList);
  }

  FavoritePageIndex get _widgetIndex {
    return (_itemsInfo.length == 0)
        ? FavoritePageIndex.empty
        : FavoritePageIndex.list;
  }

  @override
  void initState() {
    super.initState();
    log.info('Favorite initState');
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _emptyWidgetKey.currentState.loading();
    });
    eventBus.on<EventLocalProgramChanged>().listen((onData){
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
            child: ListView.builder(
              padding: EdgeInsets.only(top: 12, bottom: 12),
              itemBuilder: (BuildContext context, int index) {
                var item = _itemsInfo[index];
                return ProgramItemWidget(info: item);
              },
              itemCount: _itemsInfo.length,
            ),
          ),
        ],
      ),
    );
  }

  List<ProgramItemInfo> _trimProgramItems({List<Spec> spec}) {
    var specMap = <String, Spec>{};
    _specs.forEach((f) => specMap[f.id] = f);
    var delItems = <ProgramItemInfo>[];
    for (var item in _itemsInfo) {
      if (specMap.keys.contains(item.spec.id) == false) {
        delItems.add(item);
      }
    }

    var itemMap = <String, ProgramItemInfo>{};
    _itemsInfo.forEach((f) => itemMap[f.spec.id] = f);
    var addSpecs = <Spec>[];
    for (var spec in _specs) {
      if (itemMap.keys.contains(spec.id) == false) {
        addSpecs.add(spec);
      }
    }

    for (var delItem in delItems) {
      _itemsInfo.remove(delItem);
    }

    for (var spec in addSpecs) {
      var index = _specs.indexOf(spec);
      var item = ProgramItemInfo(
        index: index,
        spec: _specs[index],
        showProcess: false,
        processValue: 0.0,
        buttonTitle: spec.canUpdate ? '升级' : '打开',
        buttonOnPressed: (ProgramItemInfo info) {
          if (info.spec.canUpdate == true) {
            downloadProgram(info);
          } else {
            openProgram(info);
          }
        },
        itemOnPressed: (ProgramItemInfo info) {
          openProgram(info);
        },
        isLastItem: index == _specs.length - 1,
      );
      _itemsInfo.add(item);
    }
    return _itemsInfo;
  }

  Future<void> _fetchSpecs({bool fromRemote = false}) async {
    try {
      var specs =
          await ProgramsManager().fetchFavoriteList(fromRemote: fromRemote);
      setState(() {
        _specs = specs;
      });
    } catch (e) {
      setState(() {});
    }
  }

  Future<void> _handlePullRefresh() async {
    return _fetchSpecs();
  }

  void _handleDownloadComplate() {
    eventBus.fire(EventLocalProgramChanged());
  }

  Future<void> downloadProgram(ProgramItemInfo itemInfo) async {
    try {
      await ProgramsManager().downloadProgram(itemInfo.spec,
          onProgress: (received, total) {
        if (total != -1) {
          setState(() {
            var _itemInfo = _itemsInfo[_itemsInfo.indexOf(itemInfo)];
            _itemInfo.processValue = (received / total);
            _itemInfo.showProcess = true;
          });
        }
      });
      if (mounted) {
        _itemsInfo.remove(itemInfo);
        setState(() {});
        _handleDownloadComplate();
      }
    } catch (e) {
      setState(() {
        var _itemInfo = _itemsInfo[_itemsInfo.indexOf(itemInfo)];
        _itemInfo.showProcess = false;
      });
      if (mounted) {
        _handleDownloadComplate();
      }
    }
  }

  void openProgram(ProgramItemInfo info) {
    log.info('open' + info.spec.id);
  }

  @override
  void dispose() {
    log.info('dispose: ' + '$this.runtimeType');
    super.dispose();
  }
}