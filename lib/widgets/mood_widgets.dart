import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import '../utils/responsive_helper.dart';

/// MODÜLER WIDGET 1: Ruh Hali Seçenek Kartı
/// 
/// Ne İşe Yarar: Tek bir ruh hali seçeneğini gösterir
/// Neden Modüler: 5 kere aynı kod tekrarını önler
/// Nasıl Kullanılır: 
///   MoodOptionCard(
///     emoji: '😊',
///     label: 'Mutlu',
///     isSelected: true,
///     onTap: () {},
///   )
class MoodOptionCard extends StatelessWidget {
  final String emoji;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const MoodOptionCard({
    super.key,
    required this.emoji,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // Responsive font size - cihaza göre otomatik ayarlanır
    final emojiFontSize = ResponsiveHelper.responsiveFontSize(
      context,
      mobile: 26,
      tablet: 30,
      desktop: 34,
    );

    final labelFontSize = ResponsiveHelper.responsiveFontSize(
      context,
      mobile: 14,
      tablet: 16,
      desktop: 18,
    );

    return GestureDetector(
      onTap: onTap,
      child: Container(
        // Responsive padding - ekran boyutuna göre
        padding: ResponsiveHelper.responsive(
          context,
          mobile: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
          tablet: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          desktop: const EdgeInsets.symmetric(horizontal: 28, vertical: 24),
        ),
        decoration: BoxDecoration(
          // Platform-specific renkler
          color: isSelected
              ? (Platform.isIOS
                  ? CupertinoColors.systemBlue.withOpacity(0.08)
                  : const Color(0xFFA68A38).withOpacity(0.08))
              : (Platform.isIOS
                  ? CupertinoColors.systemGrey6.withOpacity(0.3)
                  : Colors.grey.shade50),
          borderRadius: BorderRadius.zero, // Düz köşeler
          border: Border.all(
            color: isSelected
                ? (Platform.isIOS
                    ? CupertinoColors.systemBlue.withOpacity(0.3)
                    : const Color(0xFFA68A38).withOpacity(0.3))
                : (Platform.isIOS
                    ? CupertinoColors.separator.withOpacity(0.2)
                    : Colors.grey.shade200),
            width: isSelected ? 2 : 1,
          ),
          // Seçiliyse gölge ekle
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: (Platform.isIOS
                            ? CupertinoColors.systemBlue
                            : const Color(0xFFA68A38))
                        .withOpacity(0.1),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              emoji,
              style: TextStyle(fontSize: emojiFontSize),
            ),
            SizedBox(
              height: ResponsiveHelper.responsive(
                context,
                mobile: 8.0,
                tablet: 10.0,
                desktop: 12.0,
              ),
            ),
            Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: labelFontSize,
                color: Platform.isIOS
                    ? CupertinoColors.label
                    : Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// MODÜLER WIDGET 2: Olumlama Kartı
///
/// Ne İşe Yarar: Tek bir olumlama kaydını gösterir
/// Neden Modüler: Her olumlama için aynı tasarım
/// Adaptive Özellikleri: Responsive padding, platform-specific renkler
class AffirmationCard extends StatelessWidget {
  final String text;
  final String category;
  final bool isFavorite;
  final VoidCallback onToggleFavorite;
  final VoidCallback onDelete;

  const AffirmationCard({
    super.key,
    required this.text,
    required this.category,
    required this.isFavorite,
    required this.onToggleFavorite,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      // Responsive margin
      margin: ResponsiveHelper.responsive(
        context,
        mobile: const EdgeInsets.only(bottom: 12),
        tablet: const EdgeInsets.only(bottom: 16),
        desktop: const EdgeInsets.only(bottom: 20),
      ),
      // Responsive padding
      padding: ResponsiveHelper.responsive(
        context,
        mobile: const EdgeInsets.all(16),
        tablet: const EdgeInsets.all(20),
        desktop: const EdgeInsets.all(24),
      ),
      decoration: BoxDecoration(
        color: Platform.isIOS
            ? CupertinoColors.systemGrey6.withOpacity(0.3)
            : Colors.grey.shade50,
        borderRadius: BorderRadius.zero,
        border: Border.all(
          color: Platform.isIOS
              ? CupertinoColors.separator.withOpacity(0.2)
              : Colors.grey.shade200,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  text,
                  style: TextStyle(
                    // Responsive font size
                    fontSize: ResponsiveHelper.responsiveFontSize(
                      context,
                      mobile: 16,
                      tablet: 17,
                      desktop: 18,
                    ),
                    fontWeight: FontWeight.w500,
                    color: Platform.isIOS
                        ? CupertinoColors.label
                        : Colors.black87,
                  ),
                ),
                SizedBox(
                  height: ResponsiveHelper.responsive(
                    context,
                    mobile: 4.0,
                    tablet: 6.0,
                    desktop: 8.0,
                  ),
                ),
                Text(
                  category,
                  style: TextStyle(
                    fontSize: ResponsiveHelper.responsiveFontSize(
                      context,
                      mobile: 12,
                      tablet: 13,
                      desktop: 14,
                    ),
                    color: Platform.isIOS
                        ? CupertinoColors.secondaryLabel
                        : Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Favori butonu
              GestureDetector(
                onTap: onToggleFavorite,
                child: Icon(
                  isFavorite
                      ? (Platform.isIOS
                          ? CupertinoIcons.heart_fill
                          : Icons.favorite)
                      : (Platform.isIOS
                          ? CupertinoIcons.heart
                          : Icons.favorite_border),
                  color: isFavorite
                      ? (Platform.isIOS
                          ? CupertinoColors.systemRed
                          : Colors.red)
                      : (Platform.isIOS
                          ? CupertinoColors.secondaryLabel
                          : Colors.grey),
                  size: ResponsiveHelper.responsive(
                    context,
                    mobile: 20.0,
                    tablet: 22.0,
                    desktop: 24.0,
                  ),
                ),
              ),
              SizedBox(
                width: ResponsiveHelper.responsive(
                  context,
                  mobile: 8.0,
                  tablet: 12.0,
                  desktop: 16.0,
                ),
              ),
              // Silme butonu
              GestureDetector(
                onTap: onDelete,
                child: Icon(
                  Platform.isIOS ? CupertinoIcons.trash : Icons.delete_outline,
                  color:
                      Platform.isIOS ? CupertinoColors.systemRed : Colors.red,
                  size: ResponsiveHelper.responsive(
                    context,
                    mobile: 20.0,
                    tablet: 22.0,
                    desktop: 24.0,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// MODÜLER WIDGET 3: Sekme Başlık Bölümü
///
/// Ne İşe Yarar: Başlık + ikon kombinasyonunu gösterir
/// Neden Modüler: Her bölüm için aynı tasarım
/// Adaptive Özellikleri: Responsive font size ve spacing
class SectionHeader extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color? iconColor;

  const SectionHeader({
    super.key,
    required this.title,
    required this.icon,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          icon,
          color: iconColor ??
              (Platform.isIOS
                  ? CupertinoColors.systemBlue
                  : const Color(0xFFA68A38)),
          size: ResponsiveHelper.responsive(
            context,
            mobile: 24.0,
            tablet: 28.0,
            desktop: 32.0,
          ),
        ),
        SizedBox(
          width: ResponsiveHelper.responsive(
            context,
            mobile: 12.0,
            tablet: 16.0,
            desktop: 20.0,
          ),
        ),
        Expanded(
          child: Text(
            title,
            style: TextStyle(
              fontSize: ResponsiveHelper.responsiveFontSize(
                context,
                mobile: 18,
                tablet: 20,
                desktop: 22,
              ),
              fontWeight: FontWeight.w600,
              color: Platform.isIOS
                  ? CupertinoColors.label
                  : Colors.black87,
            ),
          ),
        ),
      ],
    );
  }
}

/// MODÜLER WIDGET 4: Kategori Seçici
///
/// Ne İşe Yarar: Kategori seçim widget'ı
/// Neden Modüler: Tekrar kullanılabilir kategori seçici
/// Adaptive Özellikleri: Platform-specific tasarım
class CategorySelector extends StatelessWidget {
  final String selectedCategory;
  final VoidCallback onTap;

  const CategorySelector({
    super.key,
    required this.selectedCategory,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: ResponsiveHelper.responsive(
          context,
          mobile: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          tablet: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          desktop: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        ),
        decoration: BoxDecoration(
          color: Platform.isIOS
              ? CupertinoColors.systemGrey6.withOpacity(0.3)
              : Colors.grey.shade50,
          borderRadius: BorderRadius.zero,
          border: Border.all(
            color: Platform.isIOS
                ? CupertinoColors.separator.withOpacity(0.2)
                : Colors.grey.shade200,
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Text(
              'Kategori: ',
              style: TextStyle(
                color: Platform.isIOS
                    ? CupertinoColors.secondaryLabel
                    : Colors.grey[600],
                fontSize: ResponsiveHelper.responsiveFontSize(
                  context,
                  mobile: 14,
                  tablet: 15,
                  desktop: 16,
                ),
              ),
            ),
            Expanded(
              child: Text(
                selectedCategory,
                style: TextStyle(
                  color: Platform.isIOS ? CupertinoColors.label : Colors.black87,
                  fontWeight: FontWeight.w500,
                  fontSize: ResponsiveHelper.responsiveFontSize(
                    context,
                    mobile: 14,
                    tablet: 15,
                    desktop: 16,
                  ),
                ),
              ),
            ),
            Icon(
              Platform.isIOS ? CupertinoIcons.chevron_down : Icons.arrow_drop_down,
              color: Platform.isIOS
                  ? CupertinoColors.systemBlue
                  : const Color(0xFFA68A38),
              size: ResponsiveHelper.responsive(
                context,
                mobile: 20.0,
                tablet: 22.0,
                desktop: 24.0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// MODÜLER WIDGET 5: Boş Durum Göstergesi
///
/// Ne İşe Yarar: Liste boşken gösterilecek widget
/// Neden Modüler: Farklı listelerde kullanılabilir
/// Adaptive Özellikleri: Responsive padding ve font size
class EmptyStateWidget extends StatelessWidget {
  final String message;
  final IconData? icon;

  const EmptyStateWidget({
    super.key,
    required this.message,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: ResponsiveHelper.responsive(
        context,
        mobile: const EdgeInsets.all(32),
        tablet: const EdgeInsets.all(48),
        desktop: const EdgeInsets.all(64),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (icon != null) ...[
            Icon(
              icon,
              size: ResponsiveHelper.responsive(
                context,
                mobile: 48.0,
                tablet: 64.0,
                desktop: 80.0,
              ),
              color: Platform.isIOS
                  ? CupertinoColors.systemGrey
                  : Colors.grey[400],
            ),
            SizedBox(
              height: ResponsiveHelper.responsive(
                context,
                mobile: 16.0,
                tablet: 20.0,
                desktop: 24.0,
              ),
            ),
          ],
          Text(
            message,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Platform.isIOS
                  ? CupertinoColors.secondaryLabel
                  : Colors.grey[600],
              fontSize: ResponsiveHelper.responsiveFontSize(
                context,
                mobile: 14,
                tablet: 16,
                desktop: 18,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

