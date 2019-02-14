library flutter_app;

import 'package:flutter/material.dart';
import 'common/themes.dart';
import 'app.dart';
import 'tools/logging.dart';

class ProgramsApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    setupLogger();
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: kLightGalleryTheme.data,
      home: Main(title: 'Flutter Demo Home Page'),
    );
  }
}
