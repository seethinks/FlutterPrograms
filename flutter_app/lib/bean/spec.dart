import 'package:json_annotation/json_annotation.dart';

part 'spec.g.dart';

@JsonSerializable()

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
}