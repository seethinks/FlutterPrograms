import 'dart:io';
import 'dart:convert';
import 'package:logging/logging.dart';
import 'package:dio/dio.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import '../tools/logging.dart';
import './api.dart';
import '../bean/spec.dart';
import '../tools/utils.dart';

final String assertPath = "Programs";

typedef void OnProgress(int received, int total);

class Network {
  static Future<Map> fetchSpecList() async {
    try {
      var httpClient = HttpClient();
      var req = await httpClient.getUrl(api.specsList);
      var resp = await req.close();
      var respData;
      if (resp.statusCode == 200) {
        respData = await resp.transform(utf8.decoder).join();
        log.info(respData);
        respData = json.decode(respData);
        return respData;
      } else {
        throw HttpException("请求失败");
      }
    } catch (e) {
      throw e;
    }
  }

  static Future<String> downloadProgramAssert(Spec spec,
      {OnProgress onProgress}) async {
    var dio = new Dio();

    (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
        (HttpClient client) {
      client.idleTimeout = new Duration(seconds: 0);
    };

    try {
      var assertUrl = spec.flutterAssertUrl;
      var assertDir = await Directory(await spec.localTempAssertPath);
      if (!(await assertDir.exists())) {
        await assertDir.create(recursive: true);
      }
      String assertFile = path.join(assertDir.path, 'flutter_assets.zip');

      log.info('assertUrl:' + assertUrl);
      log.info('assertFile:' + assertFile);

      var respData = await dio.download(
  "http://issuecdn.baidupcs.com/issue/netdisk/MACguanjia/BaiduNetdisk_mac_2.2.2.dmg",
        assertFile,
        onProgress: (received, total){
          var process = (received / total * 100).toStringAsFixed(0) + "%";
          log.info('downloading:' + ' ' + spec.id + ' ' + '/--$process--/');
          onProgress(received, total);
        },
        cancelToken: CancelToken(),
        options: Options(
          headers: {HttpHeaders.acceptEncodingHeader: "*"},
        ),
      );
      if (respData.statusCode == 200) {
        return assertFile;
      } else {
        throw HttpException('$respData.statusCode', uri: Uri.parse(assertUrl));
      }
    } catch (e) {
      throw e;
    }
  }
}
