import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'dart:io';
import '../utils/responsive_helper.dart';

/// ✨ ADAPTIVE APP BAR
///
/// ÖNCEKİ SORUNLAR:
/// ❌ Manuel platform kontrolleri (if Platform.isIOS)
/// ❌ Sabit boyutlar ve padding
/// ❌ Kod tekrarı (iOS ve Android için ayrı kod)
///
/// YENİ ÖZELLİKLER:
/// ✅ ResponsiveHelper ile dinamik boyutlar
/// ✅ Modüler action button widget'ı
/// ✅ Platform-specific otomatik rendering
/// ✅ Responsive font size ve padding
///
/// KULLANIM:
/// ```dart
/// CustomAppBar(
///   onAddInspirationPressed: () {
///     // İlham ekleme işlemi
///   },
/// )
/// ```

class CustomAppBar extends StatelessWidget
    implements PreferredSizeWidget, ObstructingPreferredSizeWidget {
  final VoidCallback? onAddInspirationPressed;

  const CustomAppBar({super.key, this.onAddInspirationPressed});

  @override
  Widget build(BuildContext context) {
    if (Platform.isIOS) {
      return _buildIOSAppBar(context);
    } else {
      return _buildAndroidAppBar(context);
    }
  }

  /// ✅ iOS (Cupertino) AppBar - Sade ikon
  Widget _buildIOSAppBar(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).padding.top + 44, // Status bar + AppBar height
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 8,
        right: 16,
      ),
      decoration: const BoxDecoration(
        color: Colors.white, // ✅ Tam ekran beyaz
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          if (onAddInspirationPressed != null)
            _AdaptiveActionButton(
              onPressed: onAddInspirationPressed!,
              isIOS: true,
              isIconOnly: true, // ✅ Sadece ikon
            ),
        ],
      ),
    );
  }

  /// ✅ Android (Material) AppBar - Sade ikon
  Widget _buildAndroidAppBar(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).padding.top + 56, // Status bar + AppBar height
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 8,
        right: 16,
      ),
      decoration: const BoxDecoration(
        color: Colors.white, // ✅ Tam ekran beyaz
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          if (onAddInspirationPressed != null)
            _AdaptiveActionButton(
              onPressed: onAddInspirationPressed!,
              isIOS: false,
              isIconOnly: true, // ✅ Sadece ikon
            ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(100); // Sabit yükseklik

  @override
  bool shouldFullyObstruct(BuildContext context) {
    return false;
  }
}

/// ✅ MODÜLER WIDGET: Adaptive Action Button
///
/// Ne İşe Yarar: AppBar'daki action button'u (İlham Ekle butonu)
/// Neden Modüler: iOS ve Android için aynı mantık, farklı görünüm
/// Adaptive Özellikleri:
///   - Platform-specific tasarım
///   - Responsive font size
///   - Responsive padding
///   - Responsive icon size
class _AdaptiveActionButton extends StatelessWidget {
  final VoidCallback onPressed;
  final bool isIOS;
  final bool isIconOnly;

  const _AdaptiveActionButton({
    required this.onPressed,
    required this.isIOS,
    this.isIconOnly = false,
  });

  @override
  Widget build(BuildContext context) {
    if (isIOS) {
      return _buildIOSButton(context);
    } else {
      return _buildAndroidButton(context);
    }
  }

  /// iOS stili buton - Sade ikon
  Widget _buildIOSButton(BuildContext context) {
    return CupertinoButton(
      padding: EdgeInsets.zero,
      onPressed: onPressed,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          CupertinoIcons.lightbulb_fill,
          size: 24,
          color: Colors.black87,
        ),
      ),
    );
  }

  /// Android stili buton - Sade ikon
  Widget _buildAndroidButton(BuildContext context) {
    return IconButton(
      onPressed: onPressed,
      style: IconButton.styleFrom(
        backgroundColor: Colors.grey.shade100,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        padding: const EdgeInsets.all(12),
      ),
      icon: Icon(
        Icons.lightbulb,
        size: 24,
        color: Colors.black87,
      ),
    );
  }
}
