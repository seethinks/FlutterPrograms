import 'package:flutter/widgets.dart';

mixin UpdateStateMixin<T extends StatefulWidget> on State<T> {

  void updateState(VoidCallback fn) {
    if (mounted) {
      setState(fn);
    }
  }
}
