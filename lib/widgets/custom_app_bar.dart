import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'dart:io';

class CustomAppBar extends StatelessWidget
    implements PreferredSizeWidget, ObstructingPreferredSizeWidget {
  const CustomAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    if (Platform.isIOS) {
      return CupertinoNavigationBar(
        backgroundColor: CupertinoColors.systemBackground,
        middle: const Text(
          'MyDearDiary',
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
        ),
      );
    } else {
      return AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'MyDearDiary',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 18,
            color: Colors.black87,
          ),
        ),
        centerTitle: true,
      );
    }
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  bool shouldFullyObstruct(BuildContext context) {
    return false;
  }
}
