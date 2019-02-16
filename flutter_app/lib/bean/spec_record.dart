import 'package:json_annotation/json_annotation.dart';

part 'spec_record.g.dart';

@JsonSerializable()

class SpecRecord {
  SpecRecord(
    this.specProgramId,
    this.sepcLocalPath,
    );

  String specProgramId;
  String sepcLocalPath;

  factory SpecRecord.fromJson(Map<String, dynamic> json) => _$SpecRecordFromJson(json);

  Map<String, dynamic> toJson() => _$SpecRecordToJson(this);
}