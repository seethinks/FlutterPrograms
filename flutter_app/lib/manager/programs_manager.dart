import 'dart:io';
import 'dart:convert';
import 'dart:async';
import 'package:path/path.dart' as path;
import '../bean/spec.dart';
import '../bean/spec_record.dart';
import '../network/network.dart';
import '../tools/utils.dart';

class ProgramsManager {
  static final ProgramsManager _singleton = new ProgramsManager._internal();

  factory ProgramsManager() {
    return _singleton;
  }

  ProgramsManager._internal();

  String _specVersion = '0.0.0';
  List<Spec> _specList = List<Spec>();
  List<Spec> _localSpecList = List<Spec>();

  String get specVersion => _specVersion;
  List<Spec> get specList => _specList;
  List<Spec> get localSpecList => _localSpecList;

  // 获取 program spec 列表
  Future<List<Spec>> fetchSpecList() async {
    var respData = await Network.fetchSpecsList();
    _specVersion = respData["version"];
    _specList =
        (respData["specs"] as List)?.map((s) => Spec.fromJson(s))?.toList();
    return _specList;
  }

  // 获取本地 program spec 列表
  Future<List<Spec>> loadLocalSpecList() async {
    var specRecordList = await _loadLocalSpecRecord();
    var specsList = List<Spec>();
    for (var r in specRecordList) {
      var specFilePath = r.sepcLocalPath;
      try {
        File file = File(specFilePath);
        var specString = await file.readAsString();
        var specJson = (json.decode(specString) as Map);
        var spec = Spec.fromJson(specJson);
        specsList.add(spec);
      } catch (e) {}
    }
    _localSpecList = specsList;
    return _localSpecList;
  }

  // 删除本地 program
  Future<FileSystemEntity> deleteProgram(Spec spec) async {
    // 删除 program
    var assertPath = await spec.localProgramPath;
    Directory assertDir = Directory(assertPath);
    var entity = assertDir.delete(recursive: true);
    // 删除本地记录
    SpecRecord specRecord = SpecRecord(spec.id, await spec.localSpecPath);
    _deleteSpecRecord(specRecord);
    return entity;
  }

  // 下载 program
  Future<void> downloadProgram(Spec spec, {OnProgress progress}) async {
    try {
      var tempAssertFilePath =
          await Network.downloadProgramAssert(spec, progress: progress);

      // 删除旧版 program assert
      await deleteProgram(spec);
      var assertPath = await spec.localProgramPath;
      await Directory(assertPath).create();

      // 拷贝新版 program assert
      var tempAssertFile = File(tempAssertFilePath);
      await tempAssertFile.copy(assertPath);
      // 删除新版 program assert 缓存
      await tempAssertFile.parent.delete(recursive: true);

      // 保存新版 program assert sepc 到本地
      var specString = spec.toString();
      var specFilePath = path.join(assertPath, 'spec.json');
      var specFile = File(specFilePath);
      await specFile.writeAsString(specString);

      // 更新本地 spec record
      var specProgramId = spec.id;
      SpecRecord specRecord = SpecRecord(specProgramId, specFilePath);
      _addSpecRecord(specRecord);
    } catch (e) {
      throw (e);
    }
  }

// {
//   'specRecord' : [
//     {
//       'specProgramId' : 'com.xxx.xxx',
//       'specLocalPath' : 'path/local_path/version/spec.json',
//     },
//     {
//       'specProgramId' : 'com.xxx.xxx',
//       'specLocalPath' : 'path/local_path/version/spec.json',
//     },
//     ...
//   ]
// }

// 增加一条本地已经下载的 spec 记录文件
  Future<int> _addSpecRecord(SpecRecord specRecord) async {
    try {
      // 如果存在先删除
      await _deleteSpecRecord(specRecord);
      var specRecordList = await _loadLocalSpecRecord();
      specRecordList.add(specRecord);
      await _updateLocalSpecRecord(specRecordList);
      return 0;
    } catch (e) {
      return -1;
    }
  }

// 删除一条本地已经下载的 spec 记录文件
  Future<int> _deleteSpecRecord(SpecRecord specRecord) async {
    try {
      var specRecordList = await _loadLocalSpecRecord();
      specRecordList.removeWhere((r) {
        var isEqual = r.specProgramId == specRecord.specProgramId;
        return isEqual;
      });
      await _updateLocalSpecRecord(specRecordList);
      return 0;
    } catch (e) {
      return -1;
    }
  }

// 加载本地已经下载的 spec 记录文件
  Future<List<SpecRecord>> _loadLocalSpecRecord() async {
    try {
      String path = await Utils.getLocalSpecRecordFilePath();
      File file = File(path);
      String contents = await file.readAsString();
      var specRecord = json.decode(contents);
      var specRecordList = (specRecord["specRecord"] as List)
          ?.map((s) => SpecRecord.fromJson(s))
          ?.toList();
      return specRecordList;
    } catch (e) {
      return List();
    }
  }

// 更新本地已经下载的 spec 记录文件
  Future<int> _updateLocalSpecRecord(List<SpecRecord> specRecordList) async {
    try {
      var specRecord = Map();
      specRecord['specRecord'] = specRecordList;
      String contents = json.encode(specRecord);

      // 保存文件
      String path = await Utils.getLocalSpecRecordFilePath();
      File file = File(path);
      // 清空文件内容
      await file.writeAsString('');
      // 写入文件
      await file.writeAsString(contents);
      return 0;
    } catch (e) {
      return -1;
    }
  }
}
