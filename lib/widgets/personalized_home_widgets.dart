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
        'type': 'diary',
      },
      {
        'title': 'İlham Ekle',
        'icon': isCupertino ? CupertinoIcons.plus_circle : Icons.add_circle,
        'action': 'Yeni ilham ekleyin',
        'type': 'inspiration',
      },
      {
        'title': 'Olumlama Ekle',
        'icon': isCupertino ? CupertinoIcons.star_fill : Icons.star,
        'action': 'Yeni olumlama ekleyin',
        'type': 'affirmations',
      },
      {
        'title': 'Hatırlatıcı',
        'icon': isCupertino ? CupertinoIcons.bell : Icons.notifications,
        'action': 'Günlük hatırlatıcısı',
        'type': 'reminder',
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
                      onTap: () => _handleQuickAction(
                        context,
                        action['type'] as String,
                        action['title'] as String,
                      ),
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

  void _handleQuickAction(BuildContext context, String type, String title) {
    switch (type) {
      case 'inspiration':
        _showAddInspirationDialog(context);
        break;
      case 'diary':
        _showDiaryAction(context);
        break;
      case 'affirmations':
        _showAffirmationsAction(context);
        break;
      case 'reminder':
        _showReminderAction(context);
        break;
      default:
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('$title özelliği yakında eklenecek!')),
        );
    }
  }

  void _showAddInspirationDialog(BuildContext context) {
    final TextEditingController inspirationController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => isCupertino
          ? CupertinoAlertDialog(
              title: const Text('İlham Ekle'),
              content: Column(
                children: [
                  const Text('Bugünkü ilhamınızı paylaşın:'),
                  const SizedBox(height: 12),
                  CupertinoTextField(
                    controller: inspirationController,
                    placeholder: 'İlhamınızı yazın...',
                    maxLines: 3,
                    textInputAction: TextInputAction.done,
                  ),
                ],
              ),
              actions: [
                CupertinoDialogAction(
                  child: const Text('İptal'),
                  onPressed: () => Navigator.pop(context),
                ),
                CupertinoDialogAction(
                  child: const Text('Kaydet'),
                  onPressed: () {
                    if (inspirationController.text.trim().isNotEmpty) {
                      // İlham kaydetme işlemi burada yapılacak
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('İlham başarıyla kaydedildi! ✨'),
                        ),
                      );
                    }
                  },
                ),
              ],
            )
          : AlertDialog(
              title: const Text('İlham Ekle'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('Bugünkü ilhamınızı paylaşın:'),
                  const SizedBox(height: 12),
                  TextField(
                    controller: inspirationController,
                    decoration: const InputDecoration(
                      hintText: 'İlhamınızı yazın...',
                      border: OutlineInputBorder(),
                    ),
                    maxLines: 3,
                    textInputAction: TextInputAction.done,
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('İptal'),
                ),
                TextButton(
                  onPressed: () {
                    if (inspirationController.text.trim().isNotEmpty) {
                      // İlham kaydetme işlemi burada yapılacak
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('İlham başarıyla kaydedildi! ✨'),
                        ),
                      );
                    }
                  },
                  child: const Text('Kaydet'),
                ),
              ],
            ),
    );
  }

  void _showDiaryAction(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Son günlük özelliği yakında eklenecek!')),
    );
  }

  void _showAffirmationsAction(BuildContext context) {
    final TextEditingController affirmationController = TextEditingController();
    String selectedCategory = 'Öz Güven';

    final categories = [
      'Öz Güven',
      'Gelişim',
      'Şükran',
      'Öz Sevgi',
      'Pozitiflik',
      'Sağlık',
    ];

    showDialog(
      context: context,
      builder: (context) => isCupertino
          ? StatefulBuilder(
              builder: (context, setState) => CupertinoAlertDialog(
                title: const Text('Olumlama Ekle'),
                content: Column(
                  children: [
                    const Text('Bugünkü olumlamanızı yazın:'),
                    const SizedBox(height: 12),
                    CupertinoTextField(
                      controller: affirmationController,
                      placeholder: 'Olumlamanızı yazın...',
                      maxLines: 3,
                      textInputAction: TextInputAction.done,
                    ),
                    const SizedBox(height: 12),
                    CupertinoButton.filled(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      onPressed: () {
                        showCupertinoModalPopup(
                          context: context,
                          builder: (context) => CupertinoActionSheet(
                            title: const Text('Kategori Seçin'),
                            actions: categories
                                .map(
                                  (category) => CupertinoActionSheetAction(
                                    onPressed: () {
                                      setState(() {
                                        selectedCategory = category;
                                      });
                                      Navigator.pop(context);
                                    },
                                    child: Text(category),
                                  ),
                                )
                                .toList(),
                            cancelButton: CupertinoActionSheetAction(
                              onPressed: () => Navigator.pop(context),
                              child: const Text('İptal'),
                            ),
                          ),
                        );
                      },
                      child: Text('Kategori: $selectedCategory'),
                    ),
                  ],
                ),
                actions: [
                  CupertinoDialogAction(
                    child: const Text('İptal'),
                    onPressed: () => Navigator.pop(context),
                  ),
                  CupertinoDialogAction(
                    child: const Text('Kaydet'),
                    onPressed: () {
                      if (affirmationController.text.trim().isNotEmpty) {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Olumlama başarıyla kaydedildi! ⭐'),
                          ),
                        );
                      }
                    },
                  ),
                ],
              ),
            )
          : StatefulBuilder(
              builder: (context, setState) => AlertDialog(
                title: const Text('Olumlama Ekle'),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('Bugünkü olumlamanızı yazın:'),
                    const SizedBox(height: 12),
                    TextField(
                      controller: affirmationController,
                      decoration: const InputDecoration(
                        hintText: 'Olumlamanızı yazın...',
                        border: OutlineInputBorder(),
                      ),
                      maxLines: 3,
                      textInputAction: TextInputAction.done,
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<String>(
                      value: selectedCategory,
                      decoration: const InputDecoration(
                        labelText: 'Kategori',
                        border: OutlineInputBorder(),
                      ),
                      items: categories
                          .map(
                            (category) => DropdownMenuItem(
                              value: category,
                              child: Text(category),
                            ),
                          )
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedCategory = value!;
                        });
                      },
                    ),
                  ],
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('İptal'),
                  ),
                  TextButton(
                    onPressed: () {
                      if (affirmationController.text.trim().isNotEmpty) {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Olumlama başarıyla kaydedildi! ⭐'),
                          ),
                        );
                      }
                    },
                    child: const Text('Kaydet'),
                  ),
                ],
              ),
            ),
    );
  }

  void _showReminderAction(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Hatırlatıcı özelliği yakında eklenecek!')),
    );
  }
}

// 6. Günlük Olumlamalar
class DailyAffirmationsWidget extends PersonalizedWidget {
  @override
  String get title => 'Günlük Olumlamalar';

  @override
  String get description => 'Bugünkü olumlamalarınız';

  @override
  IconData get icon => Icons.favorite;

  @override
  Widget build(BuildContext context, {bool isCupertino = false}) {
    return _DailyAffirmationsCard(isCupertino: isCupertino);
  }
}

class _DailyAffirmationsCard extends StatefulWidget {
  final bool isCupertino;

  const _DailyAffirmationsCard({required this.isCupertino});

  @override
  State<_DailyAffirmationsCard> createState() => _DailyAffirmationsCardState();
}

class _DailyAffirmationsCardState extends State<_DailyAffirmationsCard> {
  final List<_Affirmation> _affirmations = [
    const _Affirmation(
      text: 'Ben güçlü ve yetenekliyim',
      category: 'Öz Güven',
      isFavorite: true,
    ),
    const _Affirmation(
      text: 'Her gün daha iyi oluyorum',
      category: 'Gelişim',
      isFavorite: false,
    ),
    const _Affirmation(
      text: 'Kendimi olduğum gibi seviyorum',
      category: 'Öz Sevgi',
      isFavorite: true,
    ),
    const _Affirmation(
      text: 'Hayat bana güzel fırsatlar sunuyor',
      category: 'Pozitiflik',
      isFavorite: false,
    ),
  ];

  @override
  Widget build(BuildContext context) {
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
                  widget.isCupertino
                      ? CupertinoIcons.heart_fill
                      : Icons.favorite,
                  color: widget.isCupertino
                      ? CupertinoColors.systemPink
                      : Theme.of(context).colorScheme.secondary,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  'Günlük Olumlamalar',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: widget.isCupertino ? CupertinoColors.label : null,
                  ),
                ),
                const Spacer(),
                IconButton(
                  icon: Icon(
                    widget.isCupertino
                        ? CupertinoIcons.add_circled
                        : Icons.add_circle_outline,
                    color: widget.isCupertino
                        ? CupertinoColors.activeBlue
                        : Theme.of(context).colorScheme.primary,
                  ),
                  onPressed: _addAffirmation,
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (_affirmations.isEmpty)
              Center(
                child: Column(
                  children: [
                    Icon(
                      widget.isCupertino
                          ? CupertinoIcons.heart
                          : Icons.favorite_border,
                      size: 48,
                      color: widget.isCupertino
                          ? CupertinoColors.inactiveGray
                          : Colors.grey,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Henüz olumlama eklenmemiş',
                      style: TextStyle(
                        color: widget.isCupertino
                            ? CupertinoColors.secondaryLabel
                            : Colors.black54,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Bugünkü olumlamanızı ekleyin',
                      style: TextStyle(
                        fontSize: 12,
                        color: widget.isCupertino
                            ? CupertinoColors.tertiaryLabel
                            : Colors.black38,
                      ),
                    ),
                  ],
                ),
              )
            else
              Column(
                children: _affirmations
                    .map((affirmation) => _buildAffirmationItem(affirmation))
                    .toList(),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildAffirmationItem(_Affirmation affirmation) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: widget.isCupertino
            ? CupertinoColors.systemGrey6
            : Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.3),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  affirmation.text,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: widget.isCupertino ? CupertinoColors.label : null,
                  ),
                ),
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: widget.isCupertino
                        ? CupertinoColors.activeBlue.withOpacity(0.1)
                        : Theme.of(
                            context,
                          ).colorScheme.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    affirmation.category,
                    style: TextStyle(
                      fontSize: 10,
                      color: widget.isCupertino
                          ? CupertinoColors.activeBlue
                          : Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          IconButton(
            icon: Icon(
              affirmation.isFavorite
                  ? (widget.isCupertino
                        ? CupertinoIcons.heart_fill
                        : Icons.favorite)
                  : (widget.isCupertino
                        ? CupertinoIcons.heart
                        : Icons.favorite_border),
              color: affirmation.isFavorite
                  ? (widget.isCupertino
                        ? CupertinoColors.systemPink
                        : Colors.red)
                  : (widget.isCupertino
                        ? CupertinoColors.inactiveGray
                        : Colors.grey),
            ),
            onPressed: () => _toggleFavorite(affirmation),
          ),
          IconButton(
            icon: Icon(
              widget.isCupertino ? CupertinoIcons.delete : Icons.delete_outline,
              color: widget.isCupertino
                  ? CupertinoColors.systemRed
                  : Colors.red,
            ),
            onPressed: () => _deleteAffirmation(affirmation),
          ),
        ],
      ),
    );
  }

  void _addAffirmation() {
    final TextEditingController affirmationController = TextEditingController();
    String selectedCategory = 'Öz Güven';

    final categories = [
      'Öz Güven',
      'Gelişim',
      'Şükran',
      'Öz Sevgi',
      'Pozitiflik',
      'Sağlık',
    ];

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => widget.isCupertino
            ? CupertinoAlertDialog(
                title: const Text('Olumlama Ekle'),
                content: Column(
                  children: [
                    const Text('Bugünkü olumlamanızı yazın:'),
                    const SizedBox(height: 12),
                    CupertinoTextField(
                      controller: affirmationController,
                      placeholder: 'Olumlamanızı yazın...',
                      maxLines: 3,
                      textInputAction: TextInputAction.done,
                    ),
                    const SizedBox(height: 12),
                    CupertinoButton.filled(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      onPressed: () {
                        showCupertinoModalPopup(
                          context: context,
                          builder: (context) => CupertinoActionSheet(
                            title: const Text('Kategori Seçin'),
                            actions: categories
                                .map(
                                  (category) => CupertinoActionSheetAction(
                                    onPressed: () {
                                      setState(() {
                                        selectedCategory = category;
                                      });
                                      Navigator.pop(context);
                                    },
                                    child: Text(category),
                                  ),
                                )
                                .toList(),
                            cancelButton: CupertinoActionSheetAction(
                              onPressed: () => Navigator.pop(context),
                              child: const Text('İptal'),
                            ),
                          ),
                        );
                      },
                      child: Text('Kategori: $selectedCategory'),
                    ),
                  ],
                ),
                actions: [
                  CupertinoDialogAction(
                    child: const Text('İptal'),
                    onPressed: () => Navigator.pop(context),
                  ),
                  CupertinoDialogAction(
                    child: const Text('Kaydet'),
                    onPressed: () {
                      if (affirmationController.text.trim().isNotEmpty) {
                        setState(() {
                          _affirmations.add(
                            _Affirmation(
                              text: affirmationController.text.trim(),
                              category: selectedCategory,
                              isFavorite: false,
                            ),
                          );
                        });
                        Navigator.pop(context);
                      }
                    },
                  ),
                ],
              )
            : AlertDialog(
                title: const Text('Olumlama Ekle'),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('Bugünkü olumlamanızı yazın:'),
                    const SizedBox(height: 12),
                    TextField(
                      controller: affirmationController,
                      decoration: const InputDecoration(
                        hintText: 'Olumlamanızı yazın...',
                        border: OutlineInputBorder(),
                      ),
                      maxLines: 3,
                      textInputAction: TextInputAction.done,
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<String>(
                      value: selectedCategory,
                      decoration: const InputDecoration(
                        labelText: 'Kategori',
                        border: OutlineInputBorder(),
                      ),
                      items: categories
                          .map(
                            (category) => DropdownMenuItem(
                              value: category,
                              child: Text(category),
                            ),
                          )
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedCategory = value!;
                        });
                      },
                    ),
                  ],
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('İptal'),
                  ),
                  TextButton(
                    onPressed: () {
                      if (affirmationController.text.trim().isNotEmpty) {
                        setState(() {
                          _affirmations.add(
                            _Affirmation(
                              text: affirmationController.text.trim(),
                              category: selectedCategory,
                              isFavorite: false,
                            ),
                          );
                        });
                        Navigator.pop(context);
                      }
                    },
                    child: const Text('Kaydet'),
                  ),
                ],
              ),
      ),
    );
  }

  void _toggleFavorite(_Affirmation affirmation) {
    setState(() {
      final index = _affirmations.indexOf(affirmation);
      _affirmations[index] = _Affirmation(
        text: affirmation.text,
        category: affirmation.category,
        isFavorite: !affirmation.isFavorite,
      );
    });
  }

  void _deleteAffirmation(_Affirmation affirmation) {
    showDialog(
      context: context,
      builder: (context) => widget.isCupertino
          ? CupertinoAlertDialog(
              title: const Text('Olumlamayı Sil'),
              content: const Text(
                'Bu olumlamayı silmek istediğinizden emin misiniz?',
              ),
              actions: [
                CupertinoDialogAction(
                  child: const Text('İptal'),
                  onPressed: () => Navigator.pop(context),
                ),
                CupertinoDialogAction(
                  isDestructiveAction: true,
                  child: const Text('Sil'),
                  onPressed: () {
                    setState(() {
                      _affirmations.remove(affirmation);
                    });
                    Navigator.pop(context);
                  },
                ),
              ],
            )
          : AlertDialog(
              title: const Text('Olumlamayı Sil'),
              content: const Text(
                'Bu olumlamayı silmek istediğinizden emin misiniz?',
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('İptal'),
                ),
                TextButton(
                  onPressed: () {
                    setState(() {
                      _affirmations.remove(affirmation);
                    });
                    Navigator.pop(context);
                  },
                  child: const Text('Sil'),
                ),
              ],
            ),
    );
  }
}

class _Affirmation {
  final String text;
  final String category;
  final bool isFavorite;

  const _Affirmation({
    required this.text,
    required this.category,
    required this.isFavorite,
  });
}

// Widget yöneticisi
class PersonalizedWidgetManager {
  static final List<PersonalizedWidget> _availableWidgets = [
    DailyMotivationWidget(),
    QuickStatsWidget(),
    EmotionalSummaryWidget(),
    SmartSuggestionsWidget(),
    DailyAffirmationsWidget(),
    QuickAccessWidget(),
  ];

  static List<PersonalizedWidget> get availableWidgets => _availableWidgets;
}
