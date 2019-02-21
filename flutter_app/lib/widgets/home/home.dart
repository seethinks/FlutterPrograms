import 'package:flutter/material.dart';
import 'dart:async';
import '../../assert.dart';

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
    eventBus.on<EventLocalProgramChanged>().listen((_) {
      _fetchSpecs();
    });
  }

  @override
  Widget build(BuildContext context) {
    var index = _widgetIndex.index;
    return Scaffold(
      appBar: PreferredSize(
        child: AppBar(
          title: Text(widget.title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.normal, 
          ),),
        ),
        preferredSize: Size.fromHeight(44),
      ),
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
            child: GridView.builder(
                padding: EdgeInsets.only(top: 12, left: 10, right: 10),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  childAspectRatio: 0.8,
                ),
                itemCount: _specs.length,
                itemBuilder: (context, index) {
                  return HomeItem(
                    index: index,
                    lastItem: index == _specs.length - 1,
                    spec: _specs[index],
                    onPressed: ({Spec spec}) {
                      _handleItemPressed(spec: spec);
                    },
                  );
                }),
          ),
        ],
      ),
    );
  }

  Future<void> _fetchSpecs({bool fromRemote = false}) async {
    try {
      var specs =
          await ProgramsManager().fetchFavoriteList(fromRemote: fromRemote);
      setState(() {
        _specs.clear();
        _specs = specs;
      });
    } catch (e) {
      setState(() {});
    }
  }

  Future<void> _handlePullRefresh() async {
    return _fetchSpecs();
  }

  void _handleItemPressed({Spec spec}) async {
    var specJson = spec.toJson();
    var resp = await Middleman.channel.invokeMethod('openProgram', specJson);
    log.info('Flutter Home _handleItemPressed ' + '$resp');
  }

  @override
  void dispose() {
    log.info('dispose: ' + '$this.runtimeType');
    super.dispose();
  }
}

class HomeItem extends StatefulWidget {
  HomeItem({this.index, this.lastItem, this.spec, this.onPressed});

  final int index;
  final bool lastItem;
  final Spec spec;
  final void Function({Spec spec}) onPressed;

  _HomeItemState createState() => _HomeItemState();
}

class _HomeItemState extends State<HomeItem> with UpdateStateMixin<HomeItem> {
  double _downloadProcess = 0.0;

  @override
  Widget build(BuildContext context) {
    final Widget item = GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        widget.onPressed(spec: widget.spec);
      },
      child: Container(
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(top: 12),
            ),
            Container(
              width: 54,
              height: 54,
              decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: Colors.grey,
                  width: 0.5,
                ),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(24),
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
            Container(
              padding: EdgeInsets.only(left: 8, right: 8),
              child: Text(
                widget.spec.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: Color(0xFF3333333),
                  fontSize: 11.0,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
    return item;
  }
}
