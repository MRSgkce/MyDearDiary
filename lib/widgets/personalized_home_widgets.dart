import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'dart:io';
import 'platform_specific_widgets.dart';

// Ana sayfa widget'ları için base sınıf
abstract class PersonalizedWidget {
  String get title;
  String get description;
  IconData get icon;
  Widget build(BuildContext context, {bool isCupertino = false});
}

// 1. Günlük Motivasyon Kartı
class DailyMotivationWidget extends PersonalizedWidget {
  @override
  String get title => 'Günlük Hedef';

  @override
  String get description => 'Bugünkü hedefinizi belirleyin';

  @override
  IconData get icon => Icons.flag;

  @override
  Widget build(BuildContext context, {bool isCupertino = false}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                icon,
                color: Platform.isIOS
                    ? CupertinoColors.systemBlue
                    : const Color(0xFFA68A38),
                size: 24,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            description,
            style: TextStyle(
              fontSize: 15,
              color: Platform.isIOS
                  ? CupertinoColors.secondaryLabel
                  : Colors.grey[600],
            ),
          ),
          const SizedBox(height: 24),
          PlatformTextField(
            placeholder: 'Bugünkü hedefinizi yazın...',
            maxLines: 2,
          ),
          const SizedBox(height: 20),
          PlatformButton(
            text: 'Hedefi Kaydet',
            icon: Icons.flag,
            onPressed: () {
              // Hedef kaydetme işlemi
            },
          ),
        ],
      ),
    );
  }
}

// 2. Hızlı İstatistikler
class QuickStatsWidget extends PersonalizedWidget {
  @override
  String get title => 'Hızlı İstatistikler';

  @override
  String get description => 'Yazma alışkanlıklarınızın özeti';

  @override
  IconData get icon => Icons.analytics;

  @override
  Widget build(BuildContext context, {bool isCupertino = false}) {
    return PlatformCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                icon,
                color: Platform.isIOS
                    ? CupertinoColors.systemGreen
                    : const Color(0xFF059669),
              ),
              const SizedBox(width: 12),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            childAspectRatio: 1.2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            children: [
              _buildStatItem('Toplam Olumlamar', '12', Icons.psychology),
              _buildStatItem('Kaydedilen İlham', '8', Icons.favorite),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Platform.isIOS
            ? CupertinoColors.systemGrey6
            : const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Platform.isIOS
              ? CupertinoColors.separator
              : const Color(0xFFE2E8F0),
          width: 1,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 20,
            color: Platform.isIOS
                ? CupertinoColors.systemBlue
                : const Color(0xFFA68A38),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: Platform.isIOS
                  ? CupertinoColors.secondaryLabel
                  : Colors.grey[600],
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

// 3. Duygusal Özet
class EmotionalSummaryWidget extends PersonalizedWidget {
  @override
  String get title => 'Duygusal Özet';

  @override
  String get description => 'Bu haftaki duygusal durumunuz';

  @override
  IconData get icon => Icons.emoji_emotions;

  @override
  Widget build(BuildContext context, {bool isCupertino = false}) {
    return PlatformCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                icon,
                color: Platform.isIOS
                    ? CupertinoColors.systemOrange
                    : const Color(0xFFEA580C),
              ),
              const SizedBox(width: 12),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            description,
            style: TextStyle(
              fontSize: 14,
              color: Platform.isIOS
                  ? CupertinoColors.secondaryLabel
                  : Colors.grey[600],
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              _buildMoodItem('😊', 'Mutlu', 60),
              const SizedBox(width: 16),
              _buildMoodItem('😌', 'Sakin', 40),
              const SizedBox(width: 16),
              _buildMoodItem('😔', 'Üzgün', 20),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMoodItem(String emoji, String label, int percentage) {
    return Expanded(
      child: Column(
        children: [
          Text(emoji, style: const TextStyle(fontSize: 24)),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: Platform.isIOS
                  ? CupertinoColors.secondaryLabel
                  : Colors.grey[600],
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '$percentage%',
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}

// 4. Akıllı Öneriler
class SmartSuggestionsWidget extends PersonalizedWidget {
  @override
  String get title => 'Akıllı Öneriler';

  @override
  String get description => 'Size özel öneriler';

  @override
  IconData get icon => Icons.lightbulb;

  @override
  Widget build(BuildContext context, {bool isCupertino = false}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                icon,
                color: Platform.isIOS
                    ? CupertinoColors.systemPurple
                    : const Color(0xFF7C3AED),
                size: 24,
              ),
              const SizedBox(width: 12),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            description,
            style: TextStyle(
              fontSize: 15,
              color: Platform.isIOS
                  ? CupertinoColors.secondaryLabel
                  : Colors.grey[600],
            ),
          ),
          const SizedBox(height: 24),
          _buildSuggestion('Bugün için 10 dakika meditasyon yapın'),
          const SizedBox(height: 16),
          _buildSuggestion('Yeni bir ilham kaydedin'),
          const SizedBox(height: 16),
          _buildSuggestion('Günlük hedefinizi güncelleyin'),
        ],
      ),
    );
  }

  Widget _buildSuggestion(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      decoration: BoxDecoration(
        color: Platform.isIOS
            ? CupertinoColors.systemGrey6.withOpacity(0.3)
            : Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(
            Icons.check_circle_outline,
            size: 20,
            color: Platform.isIOS
                ? CupertinoColors.systemGreen
                : const Color(0xFF059669),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Platform.isIOS ? CupertinoColors.label : Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// 5. İlham Ekleme Butonu
class AddInspirationWidget extends PersonalizedWidget {
  @override
  String get title => 'İlham Ekle';

  @override
  String get description => 'Yeni ilhamınızı paylaşın';

  @override
  IconData get icon => Icons.lightbulb_outline;

  @override
  Widget build(BuildContext context, {bool isCupertino = false}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                icon,
                color: Platform.isIOS
                    ? CupertinoColors.systemYellow
                    : const Color(0xFFF59E0B),
                size: 24,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            description,
            style: TextStyle(
              fontSize: 15,
              color: Platform.isIOS
                  ? CupertinoColors.secondaryLabel
                  : Colors.grey[600],
            ),
          ),
          const SizedBox(height: 24),
          PlatformButton(
            text: 'İlham Ekle',
            icon: Icons.lightbulb_outline,
            isFullWidth: true,
            onPressed: () => _showAddInspirationDialog(context),
          ),
        ],
      ),
    );
  }

  void _showAddInspirationDialog(BuildContext context) {
    PlatformAlertDialog.show(
      context: context,
      title: 'İlham Ekle',
      content: 'Bugünkü ilhamınızı paylaşın',
      actions: [
        PlatformDialogAction(
          text: 'İptal',
          onPressed: () => Navigator.pop(context),
        ),
        PlatformDialogAction(
          text: 'Kaydet',
          isDefault: true,
          onPressed: () async {
            Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('İlham başarıyla kaydedildi! ✨')),
            );
          },
        ),
      ],
    );
  }
}

// Widget yöneticisi
class PersonalizedWidgetManager {
  static final List<PersonalizedWidget> availableWidgets = [
    DailyMotivationWidget(),
    QuickStatsWidget(),
    EmotionalSummaryWidget(),
    SmartSuggestionsWidget(),
    AddInspirationWidget(),
  ];
}
