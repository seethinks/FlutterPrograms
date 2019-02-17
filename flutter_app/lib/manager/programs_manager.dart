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
    var respData = await Network.fetchSpecList();
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
        if (await file.exists()) {
          var specString = await file.readAsString();
          var specJson = (json.decode(specString) as Map);
          var spec = Spec.fromJson(specJson);
          specsList.add(spec);
        }
      } catch (e) {
        throw (e);
      }
    }
    _localSpecList = specsList;
    return _localSpecList;
  }

  // 获取发现页 program spec 类表
  Future<List<Spec>> fetchFindList({bool fromRemote}) async {
    var remoteSpecList = <Spec>[];
    if (fromRemote) {
      remoteSpecList = await fetchSpecList();
    } else {
      remoteSpecList = _specList;
    }
    var localSpecList = await loadLocalSpecList();

    var remoteSpecMap = <String, Spec>{};
    remoteSpecList.forEach((f) => remoteSpecMap[f.id] = f);

    localSpecList.forEach((f) => remoteSpecMap.remove(f.id));
    var fetchFindList = remoteSpecMap.values.toList();

    return fetchFindList;
  }

  // 获取收藏页 program spec 类表
  Future<List<Spec>> fetchFavoriteList({bool fromRemote}) async {
    var remoteSpecList = <Spec>[];
    if (fromRemote) {
      remoteSpecList = await fetchSpecList();
    } else {
      remoteSpecList = _specList;
    }
    var localSpecList = await loadLocalSpecList();

    var localSpecMap = <String, Spec>{};
    localSpecList.forEach((f) => localSpecMap[f.id] = f);

    remoteSpecList.forEach((f) {
      if (localSpecMap.containsKey(f.id)) {
        if (f.version.compareTo(localSpecMap[f.id].version) > 0) {
          localSpecMap[f.id] = f;
          localSpecMap[f.id].canUpdate = true;
        }
      }
    });

    var fetchFavoriteList = localSpecMap.values.toList();

    return fetchFavoriteList;
  }

  // 下载 program
  Future<void> downloadProgram(Spec spec, {OnProgress onProgress}) async {
    try {
      // 下载新版 program assert
      var tempAssertFilePath =
          await Network.downloadProgramAssert(spec, onProgress: onProgress);

      // 删除旧版 program assert
      await deleteProgram(spec);

      // 拷贝新版 program assert
      var assertPath = await spec.localProgramVersionDirectory;
      await assertPath.create(recursive: true);
      var tempAssertFile = File(tempAssertFilePath);
      await tempAssertFile.copy(await spec.localAssertFilePath);

      // 保存新版 program assert sepc 到本地
      var specString = json.encode(spec.toJson());
      var specFilePath = await spec.localSpecFilePath;
      var specFile = File(specFilePath);
      await specFile.writeAsString(specString);

      // 更新本地 spec record
      SpecRecord specRecord = SpecRecord(spec.id, specFilePath);
      await _addSpecRecord(specRecord);

      // 删除新版 program assert 缓存
      Directory tempAssertFileDirectory = tempAssertFile.parent;
      if (await tempAssertFileDirectory.exists()) {
        await tempAssertFile.parent.delete(recursive: true);
      }
    } catch (e) {
      throw (e);
    }
  }

  // 删除本地 program
  Future<void> deleteProgram(Spec spec) async {
    // 删除 program
    var assertDirectory = await spec.localProgramIdDirectory;
    if (await assertDirectory.exists()) {
      await assertDirectory.delete(recursive: true);
    }
    // 删除本地记录
    SpecRecord specRecord = SpecRecord(spec.id, await spec.localSpecFilePath);
    _deleteSpecRecord(specRecord);
    return;
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
    var specRecordList = <SpecRecord>[];
    try {
      String path = await Utils.getLocalSpecRecordFilePath();
      File file = File(path);
      if (await file.exists()) {
        String contents = await file.readAsString();
        var specRecord = json.decode(contents);
        specRecordList = (specRecord["specRecord"] as List)
            ?.map((s) => SpecRecord.fromJson(s))
            ?.toList();
      }
      return specRecordList;
    } catch (e) {
      return specRecordList;
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
