import 'package:json_annotation/json_annotation.dart';
import 'package:path/path.dart' as path;
import '../tools/utils.dart';

part 'spec.g.dart';

@JsonSerializable()

// 注释：
// 序列化命令：
// flutter packages pub run build_runner build
// 或者
// flutter packages pub run build_runner watch

class Spec {
  Spec(
    this.name,
    this.id,
    this.version,
    this.author,
    this.description,
    this.iconUrl,
    this.images,
    this.flutterAssertUrl,
    this.github,
    this.feature,
    this.versionRecord,
  );

  String name;
  String id;
  String version;
  String author;
  String description;
  String iconUrl;
  dynamic images;
  String flutterAssertUrl;
  String github;
  String feature;
  dynamic versionRecord;

  factory Spec.fromJson(Map<String, dynamic> json) => _$SpecFromJson(json);

  Map<String, dynamic> toJson() => _$SpecToJson(this);

  Future<String> get localProgramPath async {
    String localProgramRootPath = await Utils.getProgramRootPath();
    String pathString = path.join(localProgramRootPath, this.id);
    return pathString;
  }

  Future<String> get localSpecPath async {
    String localProgramPath = await this.localProgramPath;
    String pathString = path.join(localProgramPath, this.version, 'spec.json');
    return pathString;
  }

  Future<String> get localAssertPath async {
    String localProgramPath = await this.localProgramPath;
    String pathString =
        path.join(localProgramPath, this.version, 'flutter_assets.zip');
    return pathString;
  }

  Future<String> get localTempAssertPath async {
    String localProgramRootTempPath = await Utils.getProgramRootTempPath();
    String pathString = path.join(localProgramRootTempPath, this.id);
    return pathString;
  }
}
