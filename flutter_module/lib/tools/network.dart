import 'package:dio/dio.dart';
import 'package:flutter_module/spec.dart';

class Network {
  static final Network _singleton = new Network._internal();

  factory Network() {
    return _singleton;
  }

  Future<Response> downloadPrograms(
    ProgramSpec spec, {
    OnDownloadProgress onProgress,
  }) async {
    
  }

  Network._internal();
}