import 'package:flutter/material.dart';
import '../base/update_state_mixin.dart';
import '../common/download_button.dart';
import '../common/separator.dart';
import '../../tools/logging.dart';
import '../../bean/spec.dart';

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
}