import 'dart:io';
import 'dart:convert';
import 'package:logging/logging.dart';
import 'package:dio/dio.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import './api.dart';
import '../bean/spec.dart';
import '../tools/utils.dart';

final Logger log = new Logger('Network');

final String assertPath = "Programs";

typedef void OnProgress(int received, int total);

class Network {
  static Future<Map> fetchSpecsList() async {
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

  static Future<String> downloadProgramAssert(
      Spec spec, {OnProgress progress}) async {
    var dio = new Dio();

    (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
        (HttpClient client) {
      client.idleTimeout = new Duration(seconds: 0);
    };

    var url = spec.flutterAssertUrl;
    String dir = await spec.localTempAssertPath;
    String assertFile = path.join(dir, 'flutter_assets.zip');
    try {
      var respData = await dio.download(
        url,
        assertFile,
        onProgress: progress,
        cancelToken: CancelToken(),
        options: Options(
          headers: {HttpHeaders.acceptEncodingHeader: "*"},
        ),
      );
      if (respData.statusCode == 200) {
        return assertFile;
      }
      else {
        throw HttpException("下载失败");
      }
    } catch (e) {
        throw HttpException("下载失败");
    }
  }
}
