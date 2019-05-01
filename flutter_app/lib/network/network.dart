import 'dart:io';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:path/path.dart' as path;
import '../tools/logging.dart';
import './api.dart';
import '../bean/spec.dart';

final String assertPath = "Programs";

typedef void OnProgress(int received, int total, double process);

class Network {
  static Future<Map> fetchSpecList() async {
    try {
      var httpClient = HttpClient();
      var req = await httpClient.getUrl(Api.specsList);
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
        assertUrl,
        // "http://issuecdn.baidupcs.com/issue/netdisk/MACguanjia/BaiduNetdisk_mac_2.2.2.dmg",
        // "https://image.baidu.com/search/down?tn=download&word=download&ie=utf8&fr=detail&url=https%3A%2F%2Ftimgsa.baidu.com%2Ftimg%3Fimage%26quality%3D80%26size%3Db9999_10000%26sec%3D1550762369582%26di%3Da15999d317acb0f4347b15afdbb5c224%26imgtype%3D0%26src%3Dhttp%253A%252F%252Fgss0.baidu.com%252F-vo3dSag_xI4khGko9WTAnF6hhy%252Fzhidao%252Fpic%252Fitem%252Fc995d143ad4bd1131ecafc3c58afa40f4bfb05bc.jpg&thumburl=https%3A%2F%2Fss1.bdstatic.com%2F70cFvXSh_Q1YnxGkpoWK1HF6hhy%2Fit%2Fu%3D3098148356%2C897195335%26fm%3D26%26gp%3D0.jpg",
        assertFile,
        onReceiveProgress: (received, total) {
          var process = 0.0;
          if (total != -1) {
            process = (received / total);
          }
          // log.info('downloading:' + ' ' + spec.id + ' ' + '/--$process--/');
          onProgress(received, total, process);
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
