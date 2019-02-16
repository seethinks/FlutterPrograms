// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'spec_record.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SpecRecord _$SpecRecordFromJson(Map<String, dynamic> json) {
  return SpecRecord(
      json['specProgramId'] as String, json['sepcLocalPath'] as String);
}

Map<String, dynamic> _$SpecRecordToJson(SpecRecord instance) =>
    <String, dynamic>{
      'specProgramId': instance.specProgramId,
      'sepcLocalPath': instance.sepcLocalPath
    };
