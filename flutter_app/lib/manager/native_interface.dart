import 'dart:async';
import '../assert.dart';

class NativeInterface {
  static Future<bool> openProgram({Spec spec}) async {
    var specJson = spec.toJson();
    var resp = await Middleman.channel.invokeMethod('openProgram', specJson);
    if (resp is int) {
      return resp == 1;
    } else {
      return false;
    }
  }

  static Future<String> getAppSpec() async {
    var resp = await Middleman.channel.invokeMethod('getAppSpec');
    if (resp is String) {
      return resp;
    }
    else {
      return '';
    }
  }
}
