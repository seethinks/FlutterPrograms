
class ProgramSpec {
  const ProgramSpec({
    this.name,
    this.author,
    this.description,
    this.iconUrl,
    this.version,
    this.images = const [""],
    this.flutterAssertUrl,
    this.github,
    this.feature = "",
    this.versionRecord = const [""],

  });

  final String name;
  final String author;
  final String description;
  final String iconUrl;
  final String version;
  final List<String> images;
  final String flutterAssertUrl;
  final String github;
  final String feature;
  final List<String> versionRecord;
}