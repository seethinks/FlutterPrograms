import 'dart:async';
import '../assert.dart';

class NativeInterface {
  static Future<Map> openProgram({Spec spec}) async {
    var specJson = spec.toJson();
    var resp = await Middleman.channel.invokeMethod('openProgram', specJson);
    return resp;
  }

  static Future<String> getAppSpec() async {
    var resp = await Middleman.channel.invokeMethod('getAppSpec');
    var specString = resp['data']['specString'];
    return specString;
  }
}
