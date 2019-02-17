import 'package:logging/logging.dart';
import 'package:flutter/material.dart';

void setupLogger() {
  Logger.root.level = Level.ALL;
  Logger.root.onRecord.listen((record) {
    debugPrint('${record.level.name}: ${record.time}: ${record.message}');
  });
}

final Logger log = new Logger('Flutter Programs');
