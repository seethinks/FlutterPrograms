import 'package:flutter/material.dart';

class DownloadButton extends StatefulWidget {
  DownloadButton({
    Key key,
    this.progress,
    this.title,
    this.onPressed,
  }) : super(key: key);

  final double progress;
  final String title;
  final Future<void> Function() onPressed;

  DownloadButtonState createState() => DownloadButtonState();
}

class DownloadButtonState extends State<DownloadButton> {
  bool _isProgressing = false;
  double _progress = 0.0;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Container(
          width: 200,
          height: 40,
          child: IndexedStack(
            index: _isProgressing ? 0 : 1,
            children: <Widget>[
              _buildProgressWidget(context),
              _buildEmptyWidget(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProgressWidget(BuildContext context) {
    return Container(
      child: Center(
        child: CircularProgressIndicator(
          value: (widget.progress <= 0.1) ? null : widget.progress,
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
              fontSize: 14.0,
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
    setState(() {
      _isProgressing = true;
    });
    widget.onPressed().then((s) {
      setState(() {
        _isProgressing = false;
      });
    });
  }
}
