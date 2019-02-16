import 'dart:io';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import '../bean/spec.dart';

class Utils {
// 获取 program root 路径
// ProgramsPath = Document/Programs/
  static Future<String> getProgramRootPath() async {
    final String programPath = 'Programs';
    Directory dir = await getApplicationDocumentsDirectory();
    String programsPath = path.join(dir.path, programPath);
    return programsPath;
  }

// 获取本地已经下载的 spec 记录文件
// LocalSpecRecordFilePath = Document/Programs/spec_record.json
  static Future<String> getLocalSpecRecordFilePath() async {
    String localSpecRecordFileName = 'spec_record.json';
    String programsPath = await getProgramRootPath();
    String localSpecRecordFile =
        path.join(programsPath, localSpecRecordFileName);
    return localSpecRecordFile;
  }

// 获取 programs root 临时路径
// ProgramsPath = Temp/Programs
  static Future<String> getProgramRootTempPath() async {
    final String programPath = 'Programs';
    Directory dir = await getTemporaryDirectory();
    String programsPath = path.join(dir.path, programPath);
    return programsPath;
  }
}
