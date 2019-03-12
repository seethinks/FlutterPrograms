import 'package:flutter/material.dart';
import '../../assert.dart';

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
          log.info('program item tap');
        },
        child: Container(
          color: Colors.white,
          padding: EdgeInsets.only(top: 12, bottom: 12),
          child: SizedBox(
            height: 75,
            child: Row(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(left: 20),
                ),
                // icon 图片, 应用名称
                Container(
                  width: 74,
                  child:  Stack(
                  children: <Widget>[
                    //icon 图片
                    Align(
                      alignment: Alignment.topCenter,
                      child: Container(
                        width: 54,
                        height: 54,
                        decoration: BoxDecoration(
                          shape: BoxShape.rectangle,
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(
                            color: Colors.grey,
                            width: 0.5,
                          ),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(18),
                          child: Image(
                            image: NetworkImage(widget.info.spec.iconUrl),
                          ),
                        ),
                      ),
                    ),
                    // 应用名称
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        child: Text(
                          widget.info.spec.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: Color(0xFF3333333),
                            fontSize: 11.0,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                ),
                Padding(
                  padding: EdgeInsets.only(right: 12),
                ),
                // 作者，应用描述
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(padding: EdgeInsets.only(top: 6.0)),
                      // 作者
                      Text(
                        '作者：' + widget.info.spec.author,
                        style: TextStyle(
                          color: Color(0xFF3333333),
                          fontSize: 11.0,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Padding(padding: EdgeInsets.only(top: 4.0)),
                      // 描述
                      Expanded(
                        child: Text(
                          '简介：' + widget.info.spec.description,
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: Color(0xFF6F6F6F),
                            fontSize: 11.0,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                      ),
                      Padding(padding: EdgeInsets.only(top: 6.0)),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(right: 12),
                ),
                // 按钮
                Container(
                  width: 74,
                  height: 32,
                  child: DownloadButton(
                    title: widget.info.buttonTitle,
                    showProcess: widget.info.showProcess,
                    progressValue: widget.info.processValue,
                    onPressed: buttonOnPressed,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(right: 20),
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
          padding: EdgeInsets.only(left: 20, right: 20),
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
}
