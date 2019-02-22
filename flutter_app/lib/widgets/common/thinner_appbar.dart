import 'package:flutter/material.dart';

class ThinnerAppBar extends PreferredSize {
  ThinnerAppBar({
    String title,
  }) : super(
          child: AppBar(
            title: Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.normal,
              ),
            ),
          ),
          preferredSize: const Size.fromHeight(44),
        );
}
