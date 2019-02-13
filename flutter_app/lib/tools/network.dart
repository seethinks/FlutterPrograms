import 'dart:io';
import 'dart:convert';
import '../common/spec.dart';
import './api.dart';

class Network {

  static Future<Map> fetchSpecsList() async {
    try {
      var httpClient = HttpClient();
      var request = await httpClient.getUrl(api.specsList);
      var response = await request.close();
      var responseData;
      if (response.statusCode == 200) {
        responseData = await response.transform(utf8.decoder).join();
        responseData = json.decode(responseData);
        return responseData;
      }
      else {
        throw HttpException("请求失败");
      }
    }
    catch (e) {
      throw e;
    }
  }

  // static final Network _singleton = new Network._internal();

  // factory Network() {
  //   return _singleton;
  // }

  // Future<Response> downloadPrograms(
  //   Spec spec, {
  //   OnDownloadProgress onProgress,
  // }) async {
    
  // }

  // Network._internal();
}