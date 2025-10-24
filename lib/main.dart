import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'firebase_options.dart';
import 'services/mood_service.dart';
import 'models/mood_entry.dart';
import 'services/inspiration_service.dart';
import 'providers/inspiration_provider.dart';
import 'models/inspiration_entry.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Firebase'i başlat
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Production Firebase kullan (emulator kaldırıldı)
  print('🔥 Production Firebase bağlandı');

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MyDearDiary',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
        scaffoldBackgroundColor: Colors.white,
        fontFamily: 'Inter',
      ),
      home: const InspirationScreen(),
    );
  }
}

class InspirationScreen extends ConsumerWidget {
  const InspirationScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final inspirations = ref.watch(inspirationsProvider);

    return _InspirationScreenContent(inspirations: inspirations);
  }
}

class _InspirationScreenContent extends ConsumerStatefulWidget {
  final List<InspirationEntry> inspirations;

  const _InspirationScreenContent({required this.inspirations});

  @override
  ConsumerState<_InspirationScreenContent> createState() =>
      _InspirationScreenState();
}

class _InspirationScreenState extends ConsumerState<_InspirationScreenContent> {
  int _selectedIndex = 0;
  String? _selectedMood;
  String? _selectedEmoji;
  final TextEditingController _prompt1Controller = TextEditingController();
  final TextEditingController _prompt2Controller = TextEditingController();
  final TextEditingController _newQuoteController = TextEditingController();
  final TextEditingController _newAuthorController = TextEditingController();
  final TextEditingController _newCategoryController = TextEditingController();
  final TextEditingController _newTagsController = TextEditingController();
  final PageController _pageController = PageController();
  int _currentPageIndex = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _prompt1Controller.dispose();
    _prompt2Controller.dispose();
    _newQuoteController.dispose();
    _newAuthorController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  // Mood için emoji mapping
  String _getEmojiForMood(String mood) {
    switch (mood) {
      case 'Mutlu':
        return '😊';
      case 'Sevgi Dolu':
        return '❤️';
      case 'Enerjik':
        return '✨';
      case 'Normal':
        return '😌';
      case 'Hüzünlü':
        return '😢';
      case 'Stresli':
        return '😰';
      case 'Yorgun':
        return '😴';
      case 'Huzurlu':
        return '😌';
      default:
        return '😊';
    }
  }

  // Ay ismi döndür
  String _getMonthName(int month) {
    const months = [
      'Oca',
      'Şub',
      'Mar',
      'Nis',
      'May',
      'Haz',
      'Tem',
      'Ağu',
      'Eyl',
      'Eki',
      'Kas',
      'Ara',
    ];
    return months[month - 1];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // ✅ Top App Bar
          SafeArea(bottom: false, child: _buildTopBar(context)),

          // ✅ Main Content
          Expanded(child: _buildContentForTab(context, _selectedIndex)),

          // ✅ Bottom Navigation
          _buildBottomNavigation(context),
        ],
      ),
    );
  }

  /// ✅ Tab içeriği
  Widget _buildContentForTab(BuildContext context, int index) {
    switch (index) {
      case 0:
        return _buildMainContent(context); // İlham
      case 1:
        return _buildMoodContent(context); // Ruh Hali
      case 2:
        return _buildMeditationContent(context); // Meditasyon
      case 3:
        return _buildProfileContent(context); // Profil
      default:
        return _buildMainContent(context);
    }
  }

  /// ✅ Mood Content - Resimdeki gibi
  Widget _buildMoodContent(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),

          // ✅ Başlık
          Text(
            'Bugün Nasıl Hissediyorsun?',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade800,
            ),
          ),

          const SizedBox(height: 8),

          Text(
            'halini seç ve kaydet',
            style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
          ),

          const SizedBox(height: 30),

          // ✅ Mood Grid
          _buildMoodGrid(context),

          const SizedBox(height: 40),

          // ✅ Journal Prompts
          _buildJournalPrompts(context),

          const SizedBox(height: 30),

          // ✅ Save Button
          _buildSaveButton(context),

          const SizedBox(height: 40),

          // ✅ Past Records
          _buildPastRecords(context),

          const SizedBox(height: 100), // Bottom padding
        ],
      ),
    );
  }

  /// ✅ Meditation Content
  Widget _buildMeditationContent(BuildContext context) {
    return const Center(
      child: Text(
        'Meditasyon Sayfası',
        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
      ),
    );
  }

  /// ✅ Profile Content
  Widget _buildProfileContent(BuildContext context) {
    return const Center(
      child: Text(
        'Profil Sayfası',
        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
      ),
    );
  }

  /// ✅ Mood Grid - Resimdeki gibi
  Widget _buildMoodGrid(BuildContext context) {
    final moods = [
      {
        'icon': Icons.wb_sunny,
        'label': 'Mutlu',
        'color': Colors.yellow.shade300,
      },
      {
        'icon': Icons.favorite_border,
        'label': 'Sevgi Dolu',
        'color': Colors.pink.shade300,
      },
      {
        'icon': Icons.auto_awesome,
        'label': 'Enerjik',
        'color': Colors.purple.shade300,
      },
      {
        'icon': Icons.sentiment_neutral,
        'label': 'Normal',
        'color': Colors.grey.shade200,
      },
      {'icon': Icons.cloud, 'label': 'Hüzünlü', 'color': Colors.blue.shade300},
      {
        'icon': Icons.sentiment_dissatisfied,
        'label': 'Stresli',
        'color': Colors.red.shade300,
      },
      {
        'icon': Icons.nightlight_round,
        'label': 'Yorgun',
        'color': Colors.indigo.shade300,
      },
      {
        'icon': Icons.sentiment_satisfied,
        'label': 'Huzurlu',
        'color': Colors.green.shade300,
      },
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 0.8,
      ),
      itemCount: moods.length,
      itemBuilder: (context, index) {
        final mood = moods[index];
        return GestureDetector(
          onTap: () {
            setState(() {
              _selectedMood = mood['label'] as String;
              _selectedEmoji = _getEmojiForMood(mood['label'] as String);
            });
          },
          child: Container(
            decoration: BoxDecoration(
              color: mood['color'] as Color,
              borderRadius: BorderRadius.circular(12),
              border: _selectedMood == mood['label']
                  ? Border.all(color: Colors.black, width: 3)
                  : null,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(mood['icon'] as IconData, size: 30, color: Colors.white),
                const SizedBox(height: 8),
                Text(
                  mood['label'] as String,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  /// ✅ Journal Prompts - Resimdeki gibi
  Widget _buildJournalPrompts(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ✅ İlk prompt
        Text(
          'Bugün neyi iyi yaptım? ✨',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.grey.shade800,
          ),
        ),

        const SizedBox(height: 12),

        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey.shade50,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: TextField(
            controller: _prompt1Controller,
            decoration: InputDecoration(
              hintText: 'Bugün başardığın şeyleri yaz...',
              hintStyle: TextStyle(fontSize: 14, color: Colors.grey.shade500),
              border: InputBorder.none,
            ),
            maxLines: 3,
          ),
        ),

        const SizedBox(height: 24),

        // ✅ İkinci prompt
        Text(
          'Neyi geliştirebilirim? 💭',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.grey.shade800,
          ),
        ),

        const SizedBox(height: 12),

        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey.shade50,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: TextField(
            controller: _prompt2Controller,
            decoration: InputDecoration(
              hintText: 'Geliştirebileceğin alanları düşün...',
              hintStyle: TextStyle(fontSize: 14, color: Colors.grey.shade500),
              border: InputBorder.none,
            ),
            maxLines: 3,
          ),
        ),
      ],
    );
  }

  /// ✅ Save Button - Firebase ile kaydet
  Widget _buildSaveButton(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        if (_selectedMood == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Lütfen bir ruh hali seçin'),
              backgroundColor: Colors.red,
            ),
          );
          return;
        }

        try {
          final moodEntry = MoodEntry(
            id: MoodService.generateId(),
            mood: _selectedMood!,
            emoji: _selectedEmoji!,
            journalPrompt1: _prompt1Controller.text.isNotEmpty
                ? _prompt1Controller.text
                : null,
            journalPrompt2: _prompt2Controller.text.isNotEmpty
                ? _prompt2Controller.text
                : null,
            date: DateTime.now(),
            createdAt: DateTime.now(),
          );

          await MoodService.saveMood(moodEntry);

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Ruh haliniz başarıyla kaydedildi!'),
              backgroundColor: Colors.green,
            ),
          );

          // Formu temizle
          _prompt1Controller.clear();
          _prompt2Controller.clear();
          setState(() {
            _selectedMood = null;
            _selectedEmoji = null;
          });
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Kayıt sırasında hata oluştu: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      child: Container(
        width: double.infinity,
        height: 50,
        decoration: BoxDecoration(
          color: Colors.grey.shade900,
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Center(
          child: Text(
            'Kaydet',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  /// ✅ Past Records - Firebase'den dinamik
  Widget _buildPastRecords(BuildContext context) {
    return FutureBuilder<List<MoodEntry>>(
      future: MoodService.getAllMoods(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Text('Hata: ${snapshot.error}');
        }

        final records = snapshot.data ?? [];
        final recentRecords = records.take(5).toList(); // Son 5 kayıt

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Geçmiş Kayıtlar',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade800,
              ),
            ),

            const SizedBox(height: 16),

            if (recentRecords.isEmpty)
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  'Henüz kayıt yok. İlk kaydınızı oluşturun!',
                  style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                ),
              )
            else
              ...recentRecords
                  .map(
                    (record) => Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          Text(
                            record.emoji,
                            style: const TextStyle(fontSize: 24),
                          ),
                          const SizedBox(width: 12),
                          Text(
                            record.mood,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey.shade800,
                            ),
                          ),
                          const Spacer(),
                          Text(
                            '${record.date.day} ${_getMonthName(record.date.month)}',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                  .toList(),
          ],
        );
      },
    );
  }

  // Adaptive alert dialog helper
  Future<void> _showAdaptiveDialog({
    required BuildContext context,
    required String title,
    required String content,
    required String confirmText,
    required String cancelText,
    required VoidCallback onConfirm,
    VoidCallback? onCancel,
    bool isDestructive = false,
  }) async {
    if (Theme.of(context).platform == TargetPlatform.iOS) {
      // iOS Cupertino Alert
      await showCupertinoDialog(
        context: context,
        builder: (BuildContext context) {
          return CupertinoAlertDialog(
            title: Text(title),
            content: Text(content),
            actions: [
              CupertinoDialogAction(
                child: Text(cancelText),
                onPressed: () {
                  Navigator.of(context).pop();
                  onCancel?.call();
                },
              ),
              CupertinoDialogAction(
                isDestructiveAction: isDestructive,
                child: Text(confirmText),
                onPressed: () {
                  Navigator.of(context).pop();
                  onConfirm();
                },
              ),
            ],
          );
        },
      );
    } else {
      // Android Material Alert
      await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(title),
            content: Text(content),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  onCancel?.call();
                },
                child: Text(cancelText),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  onConfirm();
                },
                style: isDestructive
                    ? ElevatedButton.styleFrom(backgroundColor: Colors.red)
                    : null,
                child: Text(confirmText),
              ),
            ],
          );
        },
      );
    }
  }

  // Yeni ilham ekleme dialog'u - Adaptive
  void _showAddInspirationDialog(BuildContext context, WidgetRef ref) {
    print('📱 Dialog açılıyor...');
    if (Theme.of(context).platform == TargetPlatform.iOS) {
      showCupertinoDialog(
        context: context,
        builder: (BuildContext context) {
          return CupertinoAlertDialog(
            title: const Text('Yeni İlham Ekle'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 16),
                CupertinoTextField(
                  controller: _newQuoteController,
                  placeholder: 'İlham verici bir söz yazın...',
                  maxLines: 3,
                  padding: const EdgeInsets.all(12),
                ),
                const SizedBox(height: 16),
                CupertinoTextField(
                  controller: _newAuthorController,
                  placeholder: '— Sen veya — Anonim',
                  padding: const EdgeInsets.all(12),
                ),
                const SizedBox(height: 16),
                CupertinoTextField(
                  controller: _newCategoryController,
                  placeholder: 'Kategori (Genel, Motivasyon, Başarı...)',
                  padding: const EdgeInsets.all(12),
                ),
                const SizedBox(height: 16),
                CupertinoTextField(
                  controller: _newTagsController,
                  placeholder: 'Etiketler (motivasyon, başarı, ilham)',
                  padding: const EdgeInsets.all(12),
                ),
              ],
            ),
            actions: [
              CupertinoDialogAction(
                child: const Text('İptal'),
                onPressed: () {
                  Navigator.of(context).pop();
                  _newQuoteController.clear();
                  _newAuthorController.clear();
                  _newCategoryController.clear();
                  _newTagsController.clear();
                },
              ),
              CupertinoDialogAction(
                child: const Text('Ekle'),
                onPressed: () async {
                  print('🔘 Ekle butonuna basıldı');
                  if (_newQuoteController.text.isNotEmpty) {
                    print('📝 Metin var: ${_newQuoteController.text}');
                    try {
                      // Provider'ı kullanarak ilham ekle
                      print('🔄 Provider çağrılıyor...');

                      // Etiketleri virgülle ayır
                      final tags = _newTagsController.text.isNotEmpty
                          ? _newTagsController.text
                                .split(',')
                                .map((e) => e.trim())
                                .toList()
                          : <String>[];

                      await ref
                          .read(inspirationsProvider.notifier)
                          .addInspiration(
                            _newQuoteController.text,
                            author: _newAuthorController.text.isNotEmpty
                                ? _newAuthorController.text
                                : '— Sen',
                            category: _newCategoryController.text.isNotEmpty
                                ? _newCategoryController.text
                                : 'Genel',
                            tags: tags,
                          );
                      print('✅ Provider başarılı');

                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Yeni ilham başarıyla eklendi!'),
                            backgroundColor: Colors.green,
                          ),
                        );

                        Navigator.of(context).pop();
                        _newQuoteController.clear();
                        _newAuthorController.clear();
                        _newCategoryController.clear();
                        _newTagsController.clear();
                      }
                    } catch (e) {
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Hata: $e'),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    }
                  } else {
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Lütfen bir ilham sözü yazın'),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  }
                },
              ),
            ],
          );
        },
      );
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Yeni İlham Ekle'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: _newQuoteController,
                  decoration: const InputDecoration(
                    labelText: 'İlham Sözü',
                    hintText: 'İlham verici bir söz yazın...',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 3,
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _newAuthorController,
                  decoration: const InputDecoration(
                    labelText: 'Yazar',
                    hintText: '— Sen veya — Anonim',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _newCategoryController,
                  decoration: const InputDecoration(
                    labelText: 'Kategori',
                    hintText: 'Genel, Motivasyon, Başarı...',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _newTagsController,
                  decoration: const InputDecoration(
                    labelText: 'Etiketler',
                    hintText: 'motivasyon, başarı, ilham (virgülle ayırın)',
                    border: OutlineInputBorder(),
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  _newQuoteController.clear();
                  _newAuthorController.clear();
                  _newCategoryController.clear();
                  _newTagsController.clear();
                },
                child: const Text('İptal'),
              ),
              ElevatedButton(
                onPressed: () async {
                  print('🔘 Ekle butonuna basıldı');
                  if (_newQuoteController.text.isNotEmpty) {
                    print('📝 Metin var: ${_newQuoteController.text}');
                    try {
                      // Provider'ı kullanarak ilham ekle
                      print('🔄 Provider çağrılıyor...');

                      // Etiketleri virgülle ayır
                      final tags = _newTagsController.text.isNotEmpty
                          ? _newTagsController.text
                                .split(',')
                                .map((e) => e.trim())
                                .toList()
                          : <String>[];

                      await ref
                          .read(inspirationsProvider.notifier)
                          .addInspiration(
                            _newQuoteController.text,
                            author: _newAuthorController.text.isNotEmpty
                                ? _newAuthorController.text
                                : '— Sen',
                            category: _newCategoryController.text.isNotEmpty
                                ? _newCategoryController.text
                                : 'Genel',
                            tags: tags,
                          );
                      print('✅ Provider başarılı');

                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Yeni ilham başarıyla eklendi!'),
                            backgroundColor: Colors.green,
                          ),
                        );

                        Navigator.of(context).pop();
                        _newQuoteController.clear();
                        _newAuthorController.clear();
                        _newCategoryController.clear();
                        _newTagsController.clear();
                      }
                    } catch (e) {
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Hata: $e'),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    }
                  } else {
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Lütfen bir ilham sözü yazın'),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  }
                },
                child: const Text('Ekle'),
              ),
            ],
          );
        },
      );
    }
  }

  /// ✅ Top App Bar - Resimdeki gibi
  Widget _buildTopBar(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          // Lightbulb button - Yeni ilham ekle
          GestureDetector(
            onTap: () {
              print('➕ + butonuna basıldı');
              _showAddInspirationDialog(context, ref);
            },
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.grey.shade300, width: 1),
              ),
              child: Icon(
                Icons.lightbulb_outline,
                size: 20,
                color: Colors.grey.shade700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// ✅ Main Content - Kayan sayfa (PageView)
  Widget _buildMainContent(BuildContext context) {
    if (widget.inspirations.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.lightbulb_outline,
              size: 64,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: 16),
            Text(
              'Henüz ilham sözü yok',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey.shade600,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Yeni ilham sözü eklemek için + butonuna basın',
              style: TextStyle(fontSize: 14, color: Colors.grey.shade500),
            ),
          ],
        ),
      );
    }

    return PageView.builder(
      controller: _pageController,
      scrollDirection: Axis.vertical, // Dikey kaydırma
      physics: const BouncingScrollPhysics(), // iOS tarzı kaydırma
      itemCount: widget.inspirations.length,
      onPageChanged: (index) {
        setState(() {
          _currentPageIndex = index;
        });
      },
      itemBuilder: (context, index) {
        final quote = widget.inspirations[index];
        return _buildInspirationPage(context, quote, index);
      },
    );
  }

  /// ✅ İlham Sayfası
  Widget _buildInspirationPage(
    BuildContext context,
    InspirationEntry quote,
    int index,
  ) {
    return Container(
      height: MediaQuery.of(context).size.height, // Tam ekran yükseklik
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // ✅ Quote Icon - Sadece ikon, numara yok
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(50),
            ),
            child: Icon(
              Icons.format_quote,
              size: 50,
              color: Colors.grey.shade400,
            ),
          ),

          const SizedBox(height: 40),

          // ✅ Quote Text
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Text(
              quote.text,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w600,
                height: 1.4,
                color: Colors.grey.shade800,
                letterSpacing: -0.5,
              ),
            ),
          ),

          const SizedBox(height: 30),

          // ✅ Author
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(
              quote.author ?? '— Anonim',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.grey.shade700,
              ),
            ),
          ),

          const SizedBox(height: 50),

          // ✅ Action Buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildActionButton(
                Icons.delete_outline,
                () => _deleteQuote(context, quote),
              ),
              const SizedBox(width: 30),
              _buildActionButton(Icons.copy, () => _copyQuote(context, quote)),
            ],
          ),

          const SizedBox(height: 40),
        ],
      ),
    );
  }

  // İlham sözü silme - Adaptive
  void _deleteQuote(BuildContext context, InspirationEntry quote) {
    _showAdaptiveDialog(
      context: context,
      title: 'İlham Sözünü Sil',
      content: 'Bu ilham sözünü silmek istediğinizden emin misiniz?',
      confirmText: 'Sil',
      cancelText: 'İptal',
      isDestructive: true,
      onConfirm: () async {
        try {
          if (quote.id.isNotEmpty) {
            // Firebase'den sil
            await InspirationService.deleteInspiration(quote.id);
          }

          // Provider'ı yenile
          // setState artık gerekli değil, provider otomatik güncellenecek

          // Provider otomatik güncellenecek

          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('İlham sözü silindi'),
                backgroundColor: Colors.red,
              ),
            );
          }
        } catch (e) {
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Silme hatası: $e'),
                backgroundColor: Colors.red,
              ),
            );
          }
        }
      },
    );
  }

  // İlham sözü kopyalama
  void _copyQuote(BuildContext context, InspirationEntry quote) {
    Clipboard.setData(
      ClipboardData(text: '${quote.text} ${quote.author ?? '— Anonim'}'),
    );
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('📋 İlham sözü panoya kopyalandı!'),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 2),
      ),
    );
  }

  // Düzenleme işlemi
  void _editQuote(InspirationEntry quote) {
    _newQuoteController.text = quote.text;
    _newAuthorController.text = quote.author ?? '';
    _showAddInspirationDialog(context, ref);
  }

  /// ✅ Action Button - Tıklanabilir
  Widget _buildActionButton(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(25),
          border: Border.all(color: Colors.grey.shade300, width: 1),
        ),
        child: Icon(icon, size: 24, color: Colors.grey.shade700),
      ),
    );
  }

  /// ✅ İstatistik Öğesi
  Widget _buildStatItem({
    required IconData icon,
    required int count,
    required String label,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: onTap != null ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          border: onTap != null
              ? Border.all(color: Colors.grey.shade300)
              : null,
        ),
        child: Column(
          children: [
            Icon(icon, size: 20, color: Colors.grey.shade600),
            const SizedBox(height: 4),
            Text(
              count.toString(),
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            Text(
              label,
              style: TextStyle(fontSize: 10, color: Colors.grey.shade600),
            ),
          ],
        ),
      ),
    );
  }

  /// ✅ Bottom Navigation - Resimdeki gibi
  Widget _buildBottomNavigation(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        top: 10,
        bottom: MediaQuery.of(context).padding.bottom + 10,
        left: 20,
        right: 20,
      ),
      decoration: BoxDecoration(
        color: Colors.grey.shade900,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavItem(Icons.lightbulb, 'İlham', 0),
          _buildNavItem(Icons.favorite_border, 'Ruh Hali', 1),
          _buildNavItem(Icons.self_improvement, 'Meditasyon', 2),
          _buildNavItem(Icons.person_outline, 'Profil', 3),
        ],
      ),
    );
  }

  /// ✅ Navigation Item - Resimdeki gibi
  Widget _buildNavItem(IconData icon, String label, int index) {
    final isSelected = _selectedIndex == index;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedIndex = index;
        });
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: isSelected ? Colors.grey.shade300 : Colors.transparent,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Icon(icon, size: 20, color: Colors.white),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
