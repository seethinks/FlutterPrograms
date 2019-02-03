library flutter_app;

import 'package:flutter/material.dart';
import 'common/themes.dart';
import 'app.dart';

class ProgramsApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: kLightGalleryTheme.data,
      home: Main(title: 'Flutter Demo Home Page'),
    );
  }
}
