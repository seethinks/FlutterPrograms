import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'dart:async';
import '../../bean/spec.dart';
import '../../manager/programs_manager.dart';
import '../common/separator.dart';
import '../common/empty_widget.dart';
import '../common/download_button.dart';
import '../../tools/logging.dart';
import '../base/base_page.dart';
import '../base/update_state_mixin.dart';
import '../../tools/event_bus.dart';
import '../common/program_item.dart';

enum FavoritePageIndex { empty, list }

class Favorite extends BasePage {
  Favorite() : super(title: '收藏');
  static const String routeName = '/Find';
  List<Spec> specs = <Spec>[];

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
    bus.emit(EventTypes.localProgramChanged);
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
    } catch (e) {}
  }

  void openProgram(ProgramItemInfo info) {
    log.info('open' + info.spec.id);
  }

  @override
  void dispose() {
    bus.off(EventTypes.localProgramChanged);
    super.dispose();
  }
}

// class FavoriteItem extends StatefulWidget {
//   FavoriteItem({this.index, this.lastItem, this.spec, this.onComplate});

//   final int index;
//   final bool lastItem;
//   final Spec spec;
//   final void Function(bool isComplate) onComplate;

//   _FavoriteItemState createState() => _FavoriteItemState();
// }

// class _FavoriteItemState extends State<FavoriteItem>
//     with UpdateStateMixin<FavoriteItem> {
//   double _downloadProcess = 0.0;

//   @override
//   Widget build(BuildContext context) {
//     final Widget row = GestureDetector(
//         behavior: HitTestBehavior.opaque,
//         onTap: () {
//           // showFindPage(context, widget.spec);
//           log.info('favorite item tap');
//         },
//         child: Container(
//           padding: EdgeInsets.only(top: 8, bottom: 8),
//           child: SizedBox(
//             height: 90,
//             child: Row(
//               children: <Widget>[
//                 Padding(
//                   padding: EdgeInsets.only(left: 15),
//                 ),
//                 // icon 图片
//                 Container(
//                   width: 80,
//                   height: 80,
//                   decoration: BoxDecoration(
//                     shape: BoxShape.rectangle,
//                     borderRadius: BorderRadius.circular(20),
//                     border: Border.all(
//                       color: Colors.grey,
//                       width: 0.5,
//                     ),
//                   ),
//                   child: ClipRRect(
//                     borderRadius: BorderRadius.circular(20),
//                     child: Image(
//                       image: NetworkImage(widget.spec.iconUrl),
//                     ),
//                   ),
//                 ),
//                 Padding(
//                   padding: EdgeInsets.only(right: 12),
//                 ),
//                 // 应用名称、描述
//                 Expanded(
//                   child: Column(
//                     mainAxisSize: MainAxisSize.max,
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: <Widget>[
//                       Padding(padding: EdgeInsets.only(top: 12.0)),
//                       // 应用名称
//                       Text(
//                         widget.spec.name,
//                         style: TextStyle(
//                           color: Color(0xFF3333333),
//                           fontSize: 18.0,
//                           fontWeight: FontWeight.w600,
//                         ),
//                       ),
//                       Padding(padding: EdgeInsets.only(top: 8.0)),
//                       // 描述
//                       Expanded(
//                         child: Text(
//                           widget.spec.description,
//                           maxLines: 2,
//                           overflow: TextOverflow.ellipsis,
//                           style: TextStyle(
//                             color: Color(0xFF8E8E93),
//                             fontSize: 16.0,
//                             fontWeight: FontWeight.w300,
//                           ),
//                         ),
//                       ),
//                       Padding(padding: EdgeInsets.only(top: 12.0)),
//                     ],
//                   ),
//                 ),
//                 Padding(
//                   padding: EdgeInsets.only(right: 12),
//                 ),
//                 // 按钮
//                 Container(
//                   width: 80,
//                   height: 40,
//                   child: DownloadButton(
//                     progressValue: _downloadProcess,
//                     title: _itemButtonTitle,
//                     onPressed: _itemButtonOnPressed,
//                   ),
//                 ),
//                 Padding(
//                   padding: EdgeInsets.only(right: 15),
//                 ),
//               ],
//             ),
//           ),
//         ));

//     if (widget.lastItem) {
//       return row;
//     }

//     return Column(
//       children: <Widget>[
//         row,
//         Container(
//           padding: EdgeInsets.only(left: 15),
//           child: Separator(),
//         ),
//       ],
//     );
//   }

//   Future<void> downloadProgram() async {
//     try {
//       await ProgramsManager().downloadProgram(widget.spec,
//           onProgress: (received, total) {
//         if (total != -1) {
//           updateState(() {
//             _downloadProcess = (received / total);
//           });
//         }
//       });
//       if (mounted) {
//         updateState(() {
//           _downloadProcess = 0.0;
//         });
//       }
//       widget.onComplate(true);
//     } catch (e) {}
//   }

//   String get _itemButtonTitle {
//     if (widget.spec.canUpdate == true) {
//       return '升级';
//     } else {
//       return '打开';
//     }
//   }

//   Future<void> _itemButtonOnPressed() async {
//     if (widget.spec.canUpdate == true) {
//       await downloadProgram();
//     }
//   }
// }
