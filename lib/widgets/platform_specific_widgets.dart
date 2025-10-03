import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'dart:io';

/// Platform-specific widget base class
abstract class PlatformSpecificWidget extends StatelessWidget {
  const PlatformSpecificWidget({super.key});

  Widget buildIOS(BuildContext context);
  Widget buildAndroid(BuildContext context);

  @override
  Widget build(BuildContext context) {
    if (Platform.isIOS) {
      return buildIOS(context);
    } else {
      return buildAndroid(context);
    }
  }
}

/// Platform-specific button
class PlatformButton extends PlatformSpecificWidget {
  final String text;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool isFullWidth;
  final Color? backgroundColor;
  final Color? textColor;

  const PlatformButton({
    super.key,
    required this.text,
    this.onPressed,
    this.icon,
    this.isFullWidth = false,
    this.backgroundColor,
    this.textColor,
  });

  @override
  Widget buildIOS(BuildContext context) {
    Widget button = CupertinoButton(
      onPressed: onPressed,
      color: backgroundColor ?? CupertinoColors.systemBlue,
      borderRadius: BorderRadius.circular(16),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Row(
        mainAxisSize: isFullWidth ? MainAxisSize.max : MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (icon != null) ...[
            Icon(icon, color: textColor ?? CupertinoColors.white, size: 20),
            const SizedBox(width: 8),
          ],
          Text(
            text,
            style: TextStyle(
              color: textColor ?? CupertinoColors.white,
              fontWeight: FontWeight.w600,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );

    if (isFullWidth) {
      button = SizedBox(width: double.infinity, child: button);
    }

    return button;
  }

  @override
  Widget buildAndroid(BuildContext context) {
    Widget button = ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor:
            backgroundColor ?? const Color(0xFFD2691E), // Sonbahar turuncu
        foregroundColor: textColor ?? Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        elevation: 0,
        shadowColor: Colors.transparent,
      ),
      child: icon != null
          ? Row(
              mainAxisSize: isFullWidth ? MainAxisSize.max : MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, size: 20),
                const SizedBox(width: 8),
                Text(
                  text,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            )
          : Text(
              text,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
    );

    if (isFullWidth) {
      button = SizedBox(width: double.infinity, child: button);
    }

    return button;
  }
}

/// Platform-specific card
class PlatformCard extends PlatformSpecificWidget {
  final Widget child;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final Color? backgroundColor;

  const PlatformCard({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.backgroundColor,
  });

  @override
  Widget buildIOS(BuildContext context) {
    return Container(
      margin: margin ?? const EdgeInsets.all(12),
      child: Container(
        padding: padding ?? const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: backgroundColor ?? CupertinoColors.systemBackground,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: CupertinoColors.separator.withOpacity(0.3),
            width: 0.5,
          ),
          boxShadow: [
            BoxShadow(
              color: CupertinoColors.systemGrey.withOpacity(0.08),
              blurRadius: 20,
              offset: const Offset(0, 8),
              spreadRadius: 0,
            ),
            BoxShadow(
              color: CupertinoColors.systemGrey.withOpacity(0.04),
              blurRadius: 40,
              offset: const Offset(0, 16),
              spreadRadius: 0,
            ),
          ],
        ),
        child: child,
      ),
    );
  }

  @override
  Widget buildAndroid(BuildContext context) {
    return Container(
      margin: margin ?? const EdgeInsets.all(12),
      child: Card(
        elevation: 0,
        color: backgroundColor ?? Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Container(
          padding: padding ?? const EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.grey.shade100, width: 1),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 20,
                offset: const Offset(0, 8),
                spreadRadius: 0,
              ),
              BoxShadow(
                color: Colors.black.withOpacity(0.02),
                blurRadius: 40,
                offset: const Offset(0, 16),
                spreadRadius: 0,
              ),
            ],
          ),
          child: child,
        ),
      ),
    );
  }
}

/// Platform-specific text field
class PlatformTextField extends PlatformSpecificWidget {
  final String? placeholder;
  final String? initialValue;
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final int? maxLines;
  final bool obscureText;

  const PlatformTextField({
    super.key,
    this.placeholder,
    this.initialValue,
    this.controller,
    this.onChanged,
    this.maxLines = 1,
    this.obscureText = false,
  });

  @override
  Widget buildIOS(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: CupertinoColors.systemGrey6.withOpacity(0.3),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: CupertinoColors.separator.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: CupertinoTextField(
        placeholder: placeholder,
        controller: controller,
        onChanged: onChanged,
        maxLines: maxLines,
        obscureText: obscureText,
        style: const TextStyle(color: CupertinoColors.label, fontSize: 16),
        decoration: const BoxDecoration(),
      ),
    );
  }

  @override
  Widget buildAndroid(BuildContext context) {
    return TextField(
      controller: controller,
      onChanged: onChanged,
      maxLines: maxLines,
      obscureText: obscureText,
      style: const TextStyle(fontSize: 16),
      decoration: InputDecoration(
        hintText: placeholder,
        hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 16),
        filled: true,
        fillColor: Colors.grey.shade50,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: Colors.grey.shade200, width: 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: Colors.grey.shade200, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(
            color: Color(0xFFD2691E),
            width: 2,
          ), // Sonbahar turuncu
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
      ),
    );
  }
}

/// Platform-specific switch
class PlatformSwitch extends PlatformSpecificWidget {
  final bool value;
  final ValueChanged<bool>? onChanged;

  const PlatformSwitch({super.key, required this.value, this.onChanged});

  @override
  Widget buildIOS(BuildContext context) {
    return CupertinoSwitch(
      value: value,
      onChanged: onChanged,
      activeColor: CupertinoColors.systemGreen,
    );
  }

  @override
  Widget buildAndroid(BuildContext context) {
    return Switch(
      value: value,
      onChanged: onChanged,
      activeColor: const Color(0xFFD2691E), // Sonbahar turuncu
    );
  }
}

/// Platform-specific alert dialog
class PlatformAlertDialog extends PlatformSpecificWidget {
  final String title;
  final String content;
  final List<PlatformDialogAction> actions;

  const PlatformAlertDialog({
    super.key,
    required this.title,
    required this.content,
    required this.actions,
  });

  @override
  Widget buildIOS(BuildContext context) {
    return CupertinoAlertDialog(
      title: Text(title),
      content: Text(content),
      actions: actions
          .map(
            (action) => CupertinoDialogAction(
              child: Text(action.text),
              onPressed: action.onPressed,
              isDefaultAction: action.isDefault,
              isDestructiveAction: action.isDestructive,
            ),
          )
          .toList(),
    );
  }

  @override
  Widget buildAndroid(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: Text(content),
      actions: actions
          .map(
            (action) => TextButton(
              onPressed: action.onPressed,
              child: Text(
                action.text,
                style: TextStyle(
                  color: action.isDestructive ? Colors.red : null,
                  fontWeight: action.isDefault ? FontWeight.bold : null,
                ),
              ),
            ),
          )
          .toList(),
    );
  }

  static Future<T?> show<T>({
    required BuildContext context,
    required String title,
    required String content,
    required List<PlatformDialogAction> actions,
  }) {
    if (Platform.isIOS) {
      return showCupertinoDialog<T>(
        context: context,
        builder: (context) => PlatformAlertDialog(
          title: title,
          content: content,
          actions: actions,
        ),
      );
    } else {
      return showDialog<T>(
        context: context,
        builder: (context) => PlatformAlertDialog(
          title: title,
          content: content,
          actions: actions,
        ),
      );
    }
  }
}

/// Platform dialog action model
class PlatformDialogAction {
  final String text;
  final VoidCallback? onPressed;
  final bool isDefault;
  final bool isDestructive;

  const PlatformDialogAction({
    required this.text,
    this.onPressed,
    this.isDefault = false,
    this.isDestructive = false,
  });
}
