import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'dart:io';

class CustomAppBar extends StatelessWidget
    implements PreferredSizeWidget, ObstructingPreferredSizeWidget {
  final VoidCallback? onPersonalizePressed;

  const CustomAppBar({super.key, this.onPersonalizePressed});

  @override
  Widget build(BuildContext context) {
    if (Platform.isIOS) {
      return CupertinoNavigationBar(
        backgroundColor: CupertinoColors.systemBackground,
        middle: const Text(
          'MyDearDiary',
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
        ),
        trailing: onPersonalizePressed != null
            ? CupertinoButton(
                padding: EdgeInsets.zero,
                onPressed: onPersonalizePressed,
                child: const Icon(
                  CupertinoIcons.settings,
                  color: CupertinoColors.activeBlue,
                ),
              )
            : null,
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
        actions: onPersonalizePressed != null
            ? [
                IconButton(
                  onPressed: onPersonalizePressed,
                  icon: const Icon(Icons.settings, color: Color(0xFF6B46C1)),
                ),
              ]
            : null,
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
