import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'dart:io';

class CustomAppBar extends StatelessWidget
    implements PreferredSizeWidget, ObstructingPreferredSizeWidget {
  final VoidCallback? onAddInspirationPressed;

  const CustomAppBar({super.key, this.onAddInspirationPressed});

  @override
  Widget build(BuildContext context) {
    if (Platform.isIOS) {
      return CupertinoNavigationBar(
        backgroundColor: const Color(0xFFF2F2F2), // 242,242,242
        middle: const Text(
          'MyDearDiary',
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
        ),
        trailing: onAddInspirationPressed != null
            ? CupertinoButton(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                onPressed: onAddInspirationPressed,
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      CupertinoIcons.lightbulb,
                      size: 14,
                      color: CupertinoColors.systemYellow,
                    ),
                    SizedBox(width: 4),
                    Text(
                      'Yeni İlham Ekle',
                      style: TextStyle(
                        color: CupertinoColors.systemGrey,
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              )
            : null,
      );
    } else {
      return AppBar(
        backgroundColor: const Color(0xFFF2F2F2), // 242,242,242
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
        actions: onAddInspirationPressed != null
            ? [
                TextButton.icon(
                  onPressed: onAddInspirationPressed,
                  icon: const Icon(
                    Icons.lightbulb_outline,
                    size: 16,
                    color: Color(0xFF6B46C1),
                  ),
                  label: const Text(
                    'Yeni İlham Ekle',
                    style: TextStyle(
                      color: Colors.black54,
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
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
