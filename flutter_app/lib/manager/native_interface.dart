import 'dart:async';
import '../assert.dart';

class NativeInterface {
  static Future<Map> openProgram({Spec spec}) async {
    var specJson = spec.toJson();
    var resp = await Middleman.channel.invokeMethod('openProgram', specJson);
    log.info('Flutter NativeInterface' + 'openProgram' + '$resp');
    return resp;
  }

  static Future<String> getAppSpec() async {
    var resp = await Middleman.channel.invokeMethod('getAppSpec');
    log.info('Flutter NativeInterface' + 'getAppSpec' + '$resp');
    var specString = resp['data']['specString'];
    return specString;
  }
}
