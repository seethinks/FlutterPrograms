import 'package:flutter/material.dart';
import '../../assert.dart';

class DownloadButton extends StatefulWidget {
  DownloadButton({
    Key key,
    this.title,
    this.progressValue,
    this.showProcess,
    this.onPressed,
  }) : super(key: key);

  final String title;
  final double progressValue;
  final bool showProcess;
  final VoidCallback onPressed;

  DownloadButtonState createState() => DownloadButtonState();
}

class DownloadButtonState extends State<DownloadButton>
    with UpdateStateMixin<DownloadButton> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: IndexedStack(
          index: widget.showProcess ? 0 : 1,
          children: <Widget>[
            _buildProgressWidget(context),
            _buildEmptyWidget(context),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressWidget(BuildContext context) {
    return Container(
      child: Center(
        child: AspectRatio(
          aspectRatio: 1.0,
          child: CircularProgressIndicator(
            strokeWidth: 2.0,
            value: (widget.progressValue <= 0.1) ? null : widget.progressValue,
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyWidget(BuildContext context) {
    return Container(
      child: Center(
        child: RaisedButton(
          shape: StadiumBorder(),
          child: Text(
            widget.title,
            style: TextStyle(
              fontSize: 13.0,
              fontWeight: FontWeight.w700,
              letterSpacing: -0.28,
            ),
          ),
          onPressed: onPressed,
        ),
      ),
    );
  }

  void onPressed() {
    widget.onPressed();
  }
}
