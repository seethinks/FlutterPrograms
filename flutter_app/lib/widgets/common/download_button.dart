import 'package:flutter/material.dart';
import '../base/update_state_mixin.dart';

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

class DownloadButtonState extends State<DownloadButton> with UpdateStateMixin<DownloadButton> {

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Container(
          width: 200,
          height: 40,
          child: IndexedStack(
            index: widget.showProcess ? 0 : 1,
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
          value: (widget.progressValue <= 0.1) ? null : widget.progressValue,
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
    widget.onPressed();
  }
}


// class DownloadButton extends StatefulWidget {
//   DownloadButton({
//     Key key,
//     this.progressValue,
//     this.title,
//     this.onPressed,
//   }) : super(key: key);

//   final double progressValue;
//   final String title;
//   final Future<void> Function() onPressed;

//   DownloadButtonState createState() => DownloadButtonState();
// }

// class DownloadButtonState extends State<DownloadButton> with UpdateStateMixin<DownloadButton> {
//   bool _isProgressing = false;
//   double _progress = 0.0;

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       child: Center(
//         child: Container(
//           width: 200,
//           height: 40,
//           child: IndexedStack(
//             index: _isProgressing ? 0 : 1,
//             children: <Widget>[
//               _buildProgressWidget(context),
//               _buildEmptyWidget(context),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildProgressWidget(BuildContext context) {
//     return Container(
//       child: Center(
//         child: CircularProgressIndicator(
//           value: (widget.progressValue <= 0.1) ? null : widget.progressValue,
//         ),
//       ),
//     );
//   }

//   Widget _buildEmptyWidget(BuildContext context) {
//     return Container(
//       child: Center(
//         child: RaisedButton(
//           shape: StadiumBorder(),
//           child: Text(
//             widget.title,
//             style: TextStyle(
//               fontSize: 14.0,
//               fontWeight: FontWeight.w700,
//               letterSpacing: -0.28,
//             ),
//           ),
//           onPressed: onPressed,
//         ),
//       ),
//     );
//   }

//   void onPressed() {
//     updateState(() {
//       _isProgressing = true;
//     });
//     widget.onPressed().then((s) {
//       updateState(() {
//         _isProgressing = false;
//       });
//     });
//   }
// }
