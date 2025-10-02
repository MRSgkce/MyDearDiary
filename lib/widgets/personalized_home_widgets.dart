import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

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
    return _DailyMotivationCard(isCupertino: isCupertino);
  }
}

class _DailyMotivationCard extends StatefulWidget {
  final bool isCupertino;

  const _DailyMotivationCard({required this.isCupertino});

  @override
  State<_DailyMotivationCard> createState() => _DailyMotivationCardState();
}

class _DailyMotivationCardState extends State<_DailyMotivationCard> {
  final TextEditingController _goalController = TextEditingController();
  bool _isCompleted = false;
  String _dailyGoal = 'Bugün 1 günlük yazmayı hedefle';

  @override
  void initState() {
    super.initState();
    _goalController.text = _dailyGoal;
  }

  @override
  void dispose() {
    _goalController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = widget.isCupertino
        ? CupertinoColors.activeBlue
        : Theme.of(context).colorScheme.primary;

    return Card(
      elevation: widget.isCupertino ? 0 : 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: widget.isCupertino
              ? Border.all(color: CupertinoColors.separator)
              : null,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  widget.isCupertino ? CupertinoIcons.flag : Icons.flag,
                  color: primaryColor,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  'Günlük Hedef',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: widget.isCupertino ? CupertinoColors.label : null,
                  ),
                ),
                const Spacer(),
                if (_isCompleted)
                  Icon(
                    widget.isCupertino
                        ? CupertinoIcons.checkmark_circle_fill
                        : Icons.check_circle,
                    color: Colors.green,
                    size: 20,
                  ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              _dailyGoal,
              style: TextStyle(
                fontSize: 14,
                color: widget.isCupertino
                    ? CupertinoColors.secondaryLabel
                    : Colors.black54,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: widget.isCupertino
                      ? CupertinoButton.filled(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          onPressed: _toggleCompletion,
                          child: Text(_isCompleted ? 'Tamamlandı' : 'Tamamla'),
                        )
                      : ElevatedButton(
                          onPressed: _toggleCompletion,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _isCompleted
                                ? Colors.green
                                : primaryColor,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 8),
                          ),
                          child: Text(_isCompleted ? 'Tamamlandı' : 'Tamamla'),
                        ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: Icon(
                    widget.isCupertino ? CupertinoIcons.pencil : Icons.edit,
                  ),
                  onPressed: _showEditDialog,
                  color: primaryColor,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _toggleCompletion() {
    setState(() {
      _isCompleted = !_isCompleted;
    });
  }

  void _showEditDialog() {
    showDialog(
      context: context,
      builder: (context) => widget.isCupertino
          ? CupertinoAlertDialog(
              title: const Text('Hedef Düzenle'),
              content: CupertinoTextField(
                controller: _goalController,
                placeholder: 'Günlük hedefinizi yazın',
                maxLines: 2,
              ),
              actions: [
                CupertinoDialogAction(
                  child: const Text('İptal'),
                  onPressed: () => Navigator.pop(context),
                ),
                CupertinoDialogAction(
                  child: const Text('Kaydet'),
                  onPressed: () {
                    setState(() {
                      _dailyGoal = _goalController.text;
                    });
                    Navigator.pop(context);
                  },
                ),
              ],
            )
          : AlertDialog(
              title: const Text('Hedef Düzenle'),
              content: TextField(
                controller: _goalController,
                decoration: const InputDecoration(
                  hintText: 'Günlük hedefinizi yazın',
                ),
                maxLines: 2,
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('İptal'),
                ),
                TextButton(
                  onPressed: () {
                    setState(() {
                      _dailyGoal = _goalController.text;
                    });
                    Navigator.pop(context);
                  },
                  child: const Text('Kaydet'),
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
    return _QuickStatsCard(isCupertino: isCupertino);
  }
}

class _QuickStatsCard extends StatelessWidget {
  final bool isCupertino;

  const _QuickStatsCard({required this.isCupertino});

  @override
  Widget build(BuildContext context) {
    // Simulated data - gerçek uygulamada DiaryService'den gelecek
    final stats = {
      'Bu Ay': '12 günlük',
      'En Uzun Seri': '5 gün',
      'Toplam Olumlama': '28',
      'Kaydedilen İlham': '15',
    };

    return Card(
      elevation: isCupertino ? 0 : 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: isCupertino
              ? Border.all(color: CupertinoColors.separator)
              : null,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  isCupertino ? CupertinoIcons.chart_bar : Icons.analytics,
                  color: isCupertino
                      ? CupertinoColors.activeBlue
                      : Theme.of(context).colorScheme.primary,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  'Hızlı İstatistikler',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: isCupertino ? CupertinoColors.label : null,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              childAspectRatio: 1.8,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              children: stats.entries.map((entry) {
                return Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isCupertino
                        ? CupertinoColors.systemGrey6
                        : Theme.of(
                            context,
                          ).colorScheme.surfaceVariant.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        entry.key,
                        style: TextStyle(
                          fontSize: 12,
                          color: isCupertino
                              ? CupertinoColors.secondaryLabel
                              : Colors.black54,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        entry.value,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: isCupertino ? CupertinoColors.label : null,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}

// 3. Duygusal Özet
class EmotionalSummaryWidget extends PersonalizedWidget {
  @override
  String get title => 'Duygusal Özet';

  @override
  String get description => 'Ruh hali trendiniz';

  @override
  IconData get icon => Icons.trending_up;

  @override
  Widget build(BuildContext context, {bool isCupertino = false}) {
    return _EmotionalSummaryCard(isCupertino: isCupertino);
  }
}

class _EmotionalSummaryCard extends StatelessWidget {
  final bool isCupertino;

  const _EmotionalSummaryCard({required this.isCupertino});

  @override
  Widget build(BuildContext context) {
    // Simulated mood data
    final moodData = [3, 4, 3, 5, 4, 2, 3]; // 1-5 arası ruh hali skorları
    final dominantMood = 'İyi';
    final trend = 'Yükseliş';

    return Card(
      elevation: isCupertino ? 0 : 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: isCupertino
              ? Border.all(color: CupertinoColors.separator)
              : null,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  isCupertino ? CupertinoIcons.heart : Icons.trending_up,
                  color: isCupertino
                      ? CupertinoColors.systemRed
                      : Theme.of(context).colorScheme.secondary,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  'Duygusal Özet',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: isCupertino ? CupertinoColors.label : null,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Basit çizgi grafik
            SizedBox(
              height: 60,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: moodData.asMap().entries.map((entry) {
                  final height = (entry.value / 5.0) * 60;
                  return Container(
                    width: 20,
                    height: height,
                    decoration: BoxDecoration(
                      color: isCupertino
                          ? CupertinoColors.activeBlue
                          : Theme.of(context).colorScheme.primary,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildStatItem(
                    'En Çok Hissettiğiniz',
                    dominantMood,
                    '😊',
                  ),
                ),
                Expanded(child: _buildStatItem('Trend', trend, '📈')),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, String value, String emoji) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isCupertino ? CupertinoColors.systemGrey6 : Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(emoji, style: const TextStyle(fontSize: 20)),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              color: isCupertino
                  ? CupertinoColors.secondaryLabel
                  : Colors.black54,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 2),
          Text(
            value,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: isCupertino ? CupertinoColors.label : null,
            ),
            textAlign: TextAlign.center,
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
  String get description => 'Kişiselleştirilmiş öneriler';

  @override
  IconData get icon => Icons.lightbulb;

  @override
  Widget build(BuildContext context, {bool isCupertino = false}) {
    return _SmartSuggestionsCard(isCupertino: isCupertino);
  }
}

class _SmartSuggestionsCard extends StatelessWidget {
  final bool isCupertino;

  const _SmartSuggestionsCard({required this.isCupertino});

  @override
  Widget build(BuildContext context) {
    final suggestions = [
      'Son yazdığınız günlük 3 gün önce',
      'Bugün nasıl hissediyorsunuz?',
      'Hava güneşli! ☀️ Pozitif bir günlük yazın',
    ];

    return Card(
      elevation: isCupertino ? 0 : 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: isCupertino
              ? Border.all(color: CupertinoColors.separator)
              : null,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  isCupertino ? CupertinoIcons.lightbulb : Icons.lightbulb,
                  color: isCupertino
                      ? CupertinoColors.systemYellow
                      : Theme.of(context).colorScheme.tertiary,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  'Akıllı Öneriler',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: isCupertino ? CupertinoColors.label : null,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ...suggestions
                .map(
                  (suggestion) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          isCupertino
                              ? CupertinoIcons.checkmark_circle
                              : Icons.check_circle_outline,
                          color: isCupertino
                              ? CupertinoColors.activeGreen
                              : Colors.green,
                          size: 16,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            suggestion,
                            style: TextStyle(
                              fontSize: 14,
                              color: isCupertino ? CupertinoColors.label : null,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
                .toList(),
          ],
        ),
      ),
    );
  }
}

// 5. Hızlı Erişim
class QuickAccessWidget extends PersonalizedWidget {
  @override
  String get title => 'Hızlı Erişim';

  @override
  String get description => 'Sık kullanılan özellikler';

  @override
  IconData get icon => Icons.speed;

  @override
  Widget build(BuildContext context, {bool isCupertino = false}) {
    return _QuickAccessCard(isCupertino: isCupertino);
  }
}

class _QuickAccessCard extends StatelessWidget {
  final bool isCupertino;

  const _QuickAccessCard({required this.isCupertino});

  @override
  Widget build(BuildContext context) {
    final quickActions = [
      {
        'title': 'Son Günlük',
        'icon': isCupertino ? CupertinoIcons.book : Icons.book,
        'action': 'Son günlüğünüzü okuyun',
      },
      {
        'title': 'Favori Olumlamalar',
        'icon': isCupertino ? CupertinoIcons.star : Icons.star,
        'action': 'Kayıtlı olumlamalarınız',
      },
      {
        'title': 'Hatırlatıcı',
        'icon': isCupertino ? CupertinoIcons.bell : Icons.notifications,
        'action': 'Günlük hatırlatıcısı',
      },
    ];

    return Card(
      elevation: isCupertino ? 0 : 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: isCupertino
              ? Border.all(color: CupertinoColors.separator)
              : null,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  isCupertino ? CupertinoIcons.speedometer : Icons.speed,
                  color: isCupertino
                      ? CupertinoColors.activeOrange
                      : Theme.of(context).colorScheme.primary,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  'Hızlı Erişim',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: isCupertino ? CupertinoColors.label : null,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ...quickActions
                .map(
                  (action) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: InkWell(
                      onTap: () {
                        // Action implementation
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(action['action'] as String)),
                        );
                      },
                      borderRadius: BorderRadius.circular(8),
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: Row(
                          children: [
                            Icon(
                              action['icon'] as IconData,
                              size: 20,
                              color: isCupertino
                                  ? CupertinoColors.activeBlue
                                  : Theme.of(context).colorScheme.primary,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                action['title'] as String,
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: isCupertino
                                      ? CupertinoColors.label
                                      : null,
                                ),
                              ),
                            ),
                            Icon(
                              isCupertino
                                  ? CupertinoIcons.chevron_right
                                  : Icons.arrow_forward_ios,
                              size: 16,
                              color: isCupertino
                                  ? CupertinoColors.inactiveGray
                                  : Colors.black54,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                )
                .toList(),
          ],
        ),
      ),
    );
  }
}

// Widget yöneticisi
class PersonalizedWidgetManager {
  static final List<PersonalizedWidget> _availableWidgets = [
    DailyMotivationWidget(),
    QuickStatsWidget(),
    EmotionalSummaryWidget(),
    SmartSuggestionsWidget(),
    QuickAccessWidget(),
  ];

  static List<PersonalizedWidget> get availableWidgets => _availableWidgets;
}
