import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'services/mood_service.dart';
import 'models/mood_entry.dart';
import 'services/inspiration_service.dart';
import 'providers/inspiration_provider.dart';
import 'models/inspiration_entry.dart';
import 'services/meditation_service.dart';
import 'models/meditation_entry.dart';
import 'providers/auth_provider.dart';
import 'screens/login_screen.dart';
import 'screens/mood_history_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Firebase'i başlat
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Production Firebase kullan (emulator kaldırıldı)
  print('🔥 Production Firebase bağlandı');

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);

    return MaterialApp(
      title: 'MyDearDiary',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF4A90E2), // Ana mavi
          brightness: Brightness.light,
        ),
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFF5F5F5), // Soft grey
        fontFamily: 'Inter',
        // AppBar Theme
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF4A90E2),
          foregroundColor: Colors.white,
          elevation: 0,
        ),
        // Card Theme
        cardTheme: CardThemeData(
          color: Colors.white,
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        // Button Theme
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF4A90E2),
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          ),
        ),
      ),
      home: authState.when(
        data: (user) {
          // Kullanıcı giriş yapmışsa ana sayfayı göster
          if (user != null) {
            return const InspirationScreen();
          }
          // Kullanıcı giriş yapmamışsa login sayfasını göster
          return const LoginScreen();
        },
        loading: () => const Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        ),
        error: (error, stack) => const LoginScreen(),
      ),
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
  final PageController _pageController = PageController(); // İlham quote'ları için
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

  @override
  Widget build(BuildContext context) {
    // Telefon container kaldırıldı - direkt ekrana yerleştirildi
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        top: false, // Tüm sayfalarda SafeArea devre dışı
        bottom: false, // Bottom navigation Scaffold'da
        child: Column(
        children: [
            // Status Bar Area kaldırıldı - Lightbulb butonu başlıkta

              // Main Content Area - Slide Transition ile
              Expanded(
                child: _buildTabContentWithAnimation(context),
              ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNavigation(context),
    );
  }

  /// Status Bar Area - Sadece lightbulb butonu (saat cihazın kendi status bar'ında)
  Widget _buildStatusBar(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 16, // Status bar + padding
        bottom: 16, // pb-4 = 16px
        left: 32, // px-8 = 32px
        right: 32,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end, // Sağa hizala
        children: [
          // Lightbulb Button
          GestureDetector(
            onTap: () {
              _showAddInspirationDialog(context, ref);
            },
            child: Container(
              width: 40, // w-10 = 40px
              height: 40, // h-10 = 40px
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Icon(
                Icons.lightbulb_outline,
                size: 20, // w-5 = 20px
                color: Colors.grey.shade700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// ✅ Tab içeriği - Fade Transition ile animasyonlu (aradaki sayfalar görünmez)
  Widget _buildTabContentWithAnimation(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      transitionBuilder: (Widget child, Animation<double> animation) {
        return FadeTransition(
          opacity: animation,
          child: child,
        );
      },
      child: _buildCurrentTabContent(context),
    );
  }

  /// ✅ Mevcut tab içeriğini döndür
  Widget _buildCurrentTabContent(BuildContext context) {
    switch (_selectedIndex) {
      case 0:
        return _buildMainContent(
          key: const ValueKey('inspiration'),
          context,
        ); // İlham
      case 1:
        return _AnimatedMoodContent(
          key: const ValueKey('mood'),
          isActive: true,
          onMoodSelected: (mood, emoji) {
            setState(() {
              _selectedMood = mood;
              _selectedEmoji = emoji;
            });
          },
          selectedMood: _selectedMood,
          prompt1Controller: _prompt1Controller,
          prompt2Controller: _prompt2Controller,
          onSave: () async => await _saveMood(context),
          onMoodSaved: () {
            // Kayıt yapıldıktan sonra mood content'i yenile
            setState(() {});
          },
        ); // Ruh Hali
      case 2:
        return _buildMeditationContent(
          key: const ValueKey('meditation'),
          context,
        ); // Meditasyon
      case 3:
        return _buildProfileContent(
          key: const ValueKey('profile'),
          context,
        ); // Profil
      default:
        return _buildMainContent(
          key: const ValueKey('inspiration'),
          context,
        );
    }
  }


  /// ✅ Meditation Content - Kategorili meditasyon sayfası
  Widget _buildMeditationContent(BuildContext context, {Key? key}) {
    return _AnimatedMeditationContent(key: key);
  }

  /// ✅ Profile Content - Modern ve güzel tasarım
  Widget _buildProfileContent(BuildContext context, {Key? key}) {
    // Alt navigasyon çubuğu için padding hesapla
    final bottomPadding = MediaQuery.of(context).padding.bottom;
    final navBarHeight = 70.0;
    final currentUser = ref.watch(currentUserProvider);
    final safeAreaTop = MediaQuery.of(context).padding.top;
    
    return SingleChildScrollView(
      key: key,
      padding: EdgeInsets.fromLTRB(
        20,
        0, // Padding yok - başlık en üstte
        20,
        bottomPadding + navBarHeight + 20,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ✅ Başlık - En yukarıda (minimum padding)
          Transform.translate(
            offset: Offset(0, -(safeAreaTop * 0.8)), // Status bar'ın %80'i kadar yukarı taşı
            child: Padding(
              padding: EdgeInsets.fromLTRB(0, safeAreaTop * 0.2, 0, 0), // Status bar'ın %20'si kadar padding
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Icon(
                      Icons.person_outline,
                      color: Colors.grey.shade800,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
          Text(
                'Profil',
            style: TextStyle(
                          fontSize: 32,
              fontWeight: FontWeight.bold,
                          color: Colors.grey.shade900,
                          letterSpacing: -0.5,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Hesap bilgileriniz ve ayarlar',
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey.shade500,
                          fontWeight: FontWeight.w400,
            ),
          ),
            ],
          ),
                ),
              ],
            ),
            ),
          ),
          const SizedBox(height: 24),
          
          // ✅ Profil Avatar ve Bilgiler - Minimalist kart
          Container(
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: Colors.grey.shade200,
                width: 1,
              ),
            ),
            padding: const EdgeInsets.all(24),
              child: Row(
                children: [
                // Minimalist avatar
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.grey.shade200,
                        width: 2,
                      ),
                    ),
                    child: Icon(
                      Icons.person,
                      size: 42,
                      color: Colors.grey.shade700,
                    ),
                  ),
                const SizedBox(width: 20),
                  Expanded(
            child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                        'Hoş Geldiniz',
                          style: TextStyle(
                          fontSize: 13,
                            color: Colors.grey.shade600,
                    fontWeight: FontWeight.w500,
                          ),
                        ),
                      const SizedBox(height: 8),
        Text(
                          currentUser?.email ?? 'Yükleniyor...',
          style: TextStyle(
            fontSize: 16,
                          color: Colors.grey.shade900,
                            fontWeight: FontWeight.w600,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          
          const SizedBox(height: 20),
          
          // ✅ Geçmiş Kayıtlar Butonu - Minimalist kart
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: Colors.grey.shade200,
                width: 1,
              ),
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const MoodHistoryScreen(),
                    ),
                  );
                },
                borderRadius: BorderRadius.circular(18),
                child: Container(
                  padding: const EdgeInsets.all(20.0),
                  child: Row(
                    children: [
                      Container(
                        width: 56,
                        height: 56,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade50,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: Colors.grey.shade200,
                            width: 1,
                          ),
                        ),
                        child: Icon(
                          Icons.history_rounded,
                          color: Colors.grey.shade800,
                          size: 28,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Geçmiş Kayıtlar',
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w600,
                                color: Colors.grey.shade900,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Son 4 haftalık ruh hali kayıtlarını görüntüle',
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Icon(
                        Icons.arrow_forward_ios,
                        size: 16,
                        color: Colors.grey.shade400,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          
          const SizedBox(height: 16),
          
          // ✅ Çıkış yap butonu - Minimalist stil
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: Colors.grey.shade200,
                width: 1,
              ),
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () async {
                // Onay dialogu göster
                final shouldLogout = await showDialog<bool>(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Çıkış Yap'),
                    content: const Text('Çıkış yapmak istediğinize emin misiniz?'),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(false),
                        child: Text(
                          'İptal',
                            style: TextStyle(
                              color: Colors.grey.shade600,
                              fontWeight: FontWeight.w500,
                            ),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () => Navigator.of(context).pop(true),
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red.shade600,
                          foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 0,
                        ),
                        child: const Text('Çıkış Yap'),
                      ),
                    ],
                  ),
                );

                if (shouldLogout == true) {
                  try {
                    final authService = ref.read(authServiceProvider);
                    await authService.signOut();
                    // Auth state değiştiği için otomatik olarak login sayfasına yönlendirilecek
                  } catch (e) {
                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Çıkış yapılırken bir hata oluştu: $e'),
                          backgroundColor: Colors.red,
                            behavior: SnackBarBehavior.floating,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                        ),
                      );
                    }
                  }
                }
              },
                borderRadius: BorderRadius.circular(18),
                child: Container(
                  padding: const EdgeInsets.all(20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.red.shade50,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          Icons.logout_rounded,
                          size: 20,
                          color: Colors.red.shade600,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                    'Çıkış Yap',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
                          color: Colors.red.shade600,
                    ),
                  ),
                ],
                  ),
                ),
              ),
          ),
        ),
      ],
      ),
    );
  }

  /// ✅ Save Button - Firebase ile kaydet
  Future<void> _saveMood(BuildContext context) async {
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

  // Yeni ilham ekleme dialog'u - Modern Modal Bottom Sheet
  void _showAddInspirationDialog(BuildContext context, WidgetRef ref) {
    print('📱 Dialog açılıyor...');
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.9,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
          ),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Başlık ve kapatma butonu
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Yeni İlham Ekle',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        _newQuoteController.clear();
                        _newAuthorController.clear();
                        _newCategoryController.clear();
                        _newTagsController.clear();
                      },
                      icon: const Icon(Icons.close, color: Colors.grey),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                // Form alanları
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // İlham Sözü
                        const Text(
                          'İlham Sözü',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextField(
                          controller: _newQuoteController,
                          decoration: InputDecoration(
                            hintText: 'İlham verici bir söz yazın...',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                color: Colors.grey.shade300,
                              ),
                            ),
                            filled: true,
                            fillColor: Colors.grey.shade50,
                          ),
                          maxLines: 4,
                        ),
                        const SizedBox(height: 24),
                        // Yazar
                        const Text(
                          'Yazar',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextField(
                          controller: _newAuthorController,
                          decoration: InputDecoration(
                            hintText: '— Sen veya — Anonim',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                color: Colors.grey.shade300,
                              ),
                            ),
                            filled: true,
                            fillColor: Colors.grey.shade50,
                          ),
                        ),
                        const SizedBox(height: 24),
                        // Kategori
                        const Text(
                          'Kategori',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextField(
                          controller: _newCategoryController,
                          decoration: InputDecoration(
                            hintText: 'Genel, Motivasyon, Başarı...',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                color: Colors.grey.shade300,
                              ),
                            ),
                            filled: true,
                            fillColor: Colors.grey.shade50,
                          ),
                        ),
                        const SizedBox(height: 24),
                        // Etiketler
                        const Text(
                          'Etiketler',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextField(
                          controller: _newTagsController,
                          decoration: InputDecoration(
                            hintText:
                                'motivasyon, başarı, ilham (virgülle ayırın)',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                color: Colors.grey.shade300,
                              ),
                            ),
                            filled: true,
                            fillColor: Colors.grey.shade50,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                // Butonlar
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          _newQuoteController.clear();
                          _newAuthorController.clear();
                          _newCategoryController.clear();
                          _newTagsController.clear();
                        },
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          side: BorderSide(color: Colors.grey.shade300),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          'İptal',
                          style: TextStyle(fontSize: 16, color: Colors.black87),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () async {
                          print('🔘 Ekle butonuna basıldı');
                          if (_newQuoteController.text.isNotEmpty) {
                            print('📝 Metin var: ${_newQuoteController.text}');
                            try {
                              print('🔄 Provider çağrılıyor...');

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
                                    category:
                                        _newCategoryController.text.isNotEmpty
                                        ? _newCategoryController.text
                                        : 'Genel',
                                    tags: tags,
                                  );
                              print('✅ Provider başarılı');

                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      'Yeni ilham başarıyla eklendi!',
                                    ),
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
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          backgroundColor: Colors.grey.shade900,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          'Ekle',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  /// ✅ Main Content - Kayan sayfa (PageView)
  Widget _buildMainContent(BuildContext context, {Key? key}) {
    // Status bar'da lightbulb butonu var, burada ekstra buton kaldırıldı
    return _buildInspirationPageView(key: key, context: context, ref: ref);
  }

  Widget _buildInspirationPageView({required BuildContext context, Key? key, required WidgetRef ref}) {
    // Alt navigasyon çubuğu için padding hesapla
    final bottomPadding = MediaQuery.of(context).padding.bottom;
    final navBarHeight = 70.0;
    final safeAreaTop = MediaQuery.of(context).padding.top;
    
    if (widget.inspirations.isEmpty) {
      return Column(
        key: key,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ✅ Başlık - En üstte
          Padding(
            padding: EdgeInsets.fromLTRB(20, safeAreaTop + 16, 20, 0),
            child: Row(
              children: [
                Icon(
                  Icons.lightbulb_outline,
                  color: Colors.grey.shade400,
                  size: 24,
                ),
                const SizedBox(width: 8),
                Text(
                  'İlham',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey.shade800,
                  ),
                ),
                const Spacer(),
                // Lightbulb butonu başlığın sağında
                GestureDetector(
                  onTap: () {
                    _showAddInspirationDialog(context, ref);
                  },
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
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
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.fromLTRB(
                20,
                60,
                20,
                bottomPadding + navBarHeight + 20,
              ),
        child: Center(
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
        ),
            ),
          ),
        ],
      );
    }

    return Column(
      key: key,
      crossAxisAlignment: CrossAxisAlignment.start,
        children: [
        // ✅ Başlık - En üstte (diğer sayfalarla aynı)
        Padding(
          padding: EdgeInsets.fromLTRB(20, safeAreaTop + 16, 20, 0),
          child: Row(
            children: [
              Icon(
                Icons.lightbulb_outline,
              color: Colors.grey.shade400,
                size: 24,
              ),
              const SizedBox(width: 8),
              Text(
                'İlham',
              style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                color: Colors.grey.shade800,
                ),
              ),
              const Spacer(),
              // Lightbulb butonu başlığın sağında
              GestureDetector(
                onTap: () {
                  _showAddInspirationDialog(context, ref);
                },
                child: Container(
                  width: 40,
                  height: 40,
            decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
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
        ),
        // PageView - Başlığın altında
        Expanded(
          child: Padding(
            padding: EdgeInsets.fromLTRB(
              20,
              20,
              20,
              bottomPadding + navBarHeight + 20,
            ),
            child: PageView.builder(
              controller: _pageController,
              scrollDirection: Axis.vertical,
              physics: const BouncingScrollPhysics(),
              itemCount: widget.inspirations.length,
              onPageChanged: (index) {
                setState(() {
                  _currentPageIndex = index;
                });
              },
              itemBuilder: (context, index) {
                final quote = widget.inspirations[index];
                return _AnimatedInspirationPage(
                  quote: quote,
                  onDelete: () => _deleteQuote(context, quote),
                  onCopy: () => _copyQuote(context, quote),
                );
              },
            ),
          ),
        ),
      ],
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

            // Provider'ı manuel yenile
            await ref.read(inspirationsProvider.notifier).loadInspirations();
          }

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
      padding: const EdgeInsets.symmetric(
        vertical: 10,
        horizontal: 20,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFFE8E8E8), // Kırık beyaz gri
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavItem(Icons.lightbulb_outline, 'İlham', 0),
          _buildNavItem(Icons.favorite_outline, 'Ruh Hali', 1),
          _buildNavItem(Icons.local_florist_outlined, 'Meditasyon', 2),
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
        // Direkt tab değiştir (aradaki sayfalar görünmez)
        setState(() {
          _selectedIndex = index;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? Colors.grey.shade200 : Colors.transparent,
          borderRadius: BorderRadius.circular(25),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
                    icon,
                    size: 28,
                    color: isSelected
                        ? const Color(0xFF4A90E2)
                        : Colors.grey.shade600,
                  ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                color: isSelected
                    ? const Color(0xFF4A90E2)
                    : Colors.grey.shade600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// ✅ Animasyonlu İlham Sayfası - Fade Slide Up Animasyonu
class _AnimatedInspirationPage extends StatefulWidget {
  final InspirationEntry quote;
  final VoidCallback onDelete;
  final VoidCallback onCopy;

  const _AnimatedInspirationPage({
    required this.quote,
    required this.onDelete,
    required this.onCopy,
  });

  @override
  State<_AnimatedInspirationPage> createState() =>
      _AnimatedInspirationPageState();
}

class _AnimatedInspirationPageState extends State<_AnimatedInspirationPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    // Fade animasyonu (0'dan 1'e)
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    ));

    // Slide animasyonu (aşağıdan yukarıya)
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0.0, 0.3), // %30 aşağıdan başla
      end: Offset.zero, // Normal pozisyona gel
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    ));

    // Animasyonu başlat
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
                    // ✅ Quote Icon
                    Container(
                      width: 70,
                      height: 70,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(35),
                      ),
                      child: Icon(
                        Icons.format_quote,
                        size: 35,
                        color: Colors.grey.shade400,
                      ),
                    ),

                    const SizedBox(height: 24),

                    // ✅ Quote Text
                    Flexible(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Text(
                          widget.quote.text,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            height: 1.4,
                            color: Colors.grey.shade800,
                            letterSpacing: -0.5,
                          ),
                          maxLines: 10,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // ✅ Author
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Text(
                        widget.quote.author ?? '— Anonim',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey.shade700,
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

              // ✅ Action Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildActionButton(
                    Icons.delete_outline,
                    widget.onDelete,
                  ),
                  const SizedBox(width: 30),
                  _buildActionButton(Icons.copy, widget.onCopy),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

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
}

/// ✅ Animasyonlu Mood Content
class _AnimatedMoodContent extends StatefulWidget {
  final Function(String, String) onMoodSelected;
  final String? selectedMood;
  final TextEditingController prompt1Controller;
  final TextEditingController prompt2Controller;
  final Future<void> Function() onSave;
  final VoidCallback? onMoodSaved;
  final bool isActive;

  const _AnimatedMoodContent({
    required this.onMoodSelected,
    required this.selectedMood,
    required this.prompt1Controller,
    required this.prompt2Controller,
    required this.onSave,
    this.onMoodSaved,
    required this.isActive,
    super.key,
  });

  @override
  State<_AnimatedMoodContent> createState() => _AnimatedMoodContentState();
}

class _AnimatedMoodContentState extends State<_AnimatedMoodContent>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500), // Daha uzun süre, tüm animasyonlar için yeterli
    );
    // Sadece aktif ise animasyonu başlat
    if (widget.isActive) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          try {
            _controller.forward();
          } catch (e) {
            // Hata durumunda sessizce devam et
          }
        }
      });
    } else {
      // Hemen görünür yap
      _controller.value = 1.0;
    }
  }

  @override
  void didUpdateWidget(_AnimatedMoodContent oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!mounted) return;
    
    // Eğer tab aktif hale geldiyse animasyonu başlat
    if (widget.isActive && !oldWidget.isActive) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          try {
            if (_controller.isAnimating) {
              _controller.stop();
            }
            _controller.reset();
            _controller.forward();
          } catch (e) {
            // Controller zaten dispose edilmiş, hata yok say
          }
        }
      });
    }
  }

  @override
  void dispose() {
    if (_controller.isAnimating) {
      _controller.stop();
    }
    _controller.dispose();
    super.dispose();
  }

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

  @override
  Widget build(BuildContext context) {
    // Alt navigasyon çubuğu için padding hesapla
    final bottomPadding = MediaQuery.of(context).padding.bottom;
    final navBarHeight = 70.0;
    
    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(
        20,
        0, // Padding yok - başlık en üstte
        20,
        bottomPadding + navBarHeight + 20, // Alt navigasyon için boşluk
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ✅ Başlık - Diğer sayfalarla aynı hizada (safeAreaTop + 16)
          Padding(
            padding: EdgeInsets.fromLTRB(0, MediaQuery.of(context).padding.top + 16, 0, 0),
            child: Row(
            children: [
              Icon(
                Icons.favorite_outline,
                color: Colors.grey.shade400,
                size: 24,
              ),
              const SizedBox(width: 8),
              Text(
                'Ruh Hali',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey.shade800,
                ),
              ),
            ],
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'halini seç ve kaydet',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 20), // Boşluk artırıldı
          // ✅ Animasyonlu Mood Grid
          _buildAnimatedMoodGrid(context),
          const SizedBox(height: 40),
          // ✅ Animasyonlu Journal Prompts
          _buildAnimatedJournalPrompts(context),
          const SizedBox(height: 30),
          // ✅ Save Button
          _buildSaveButton(context, () {
            // Kayıt yapıldıktan sonra callback'i çağır
            widget.onMoodSaved?.call();
          }),
          const SizedBox(height: 20), // Alt navigasyon için minimal boşluk
        ],
      ),
    );
  }

  /// ✅ Staggered Animation Mood Grid
  Widget _buildAnimatedMoodGrid(BuildContext context) {
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
      padding: EdgeInsets.zero, // Üst boşluğu kaldır
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 0.8,
      ),
      itemCount: moods.length,
      itemBuilder: (context, index) {
        final mood = moods[index];
        // Her kart 0.05 saniye gecikmeli
        final delay = index * 0.05;
        return _StaggeredMoodCard(
          animationController: _controller,
          delay: delay,
          mood: mood,
          isSelected: widget.selectedMood == mood['label'] as String,
          onTap: () {
            widget.onMoodSelected(
              mood['label'] as String,
              _getEmojiForMood(mood['label'] as String),
            );
          },
        );
      },
    );
  }

  /// ✅ Cascade Animation Journal Prompts
  Widget _buildAnimatedJournalPrompts(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // İlk prompt - 0.1s gecikme
        _CascadeCard(
          animationController: _controller,
          delay: 0.1,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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
                  controller: widget.prompt1Controller,
                  decoration: InputDecoration(
                    hintText: 'Bugün başardığın şeyleri yaz...',
                    hintStyle:
                        TextStyle(fontSize: 14, color: Colors.grey.shade500),
                    border: InputBorder.none,
                  ),
                  maxLines: 3,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        // İkinci prompt - 0.2s gecikme
        _CascadeCard(
          animationController: _controller,
          delay: 0.2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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
                  controller: widget.prompt2Controller,
                  decoration: InputDecoration(
                    hintText: 'Geliştirebileceğin alanları düşün...',
                    hintStyle:
                        TextStyle(fontSize: 14, color: Colors.grey.shade500),
                    border: InputBorder.none,
                  ),
                  maxLines: 3,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSaveButton(BuildContext context, VoidCallback? onSaved) {
    return GestureDetector(
      onTap: () async {
        // Kayıt işlemini başlat ve tamamlanmasını bekle
        await widget.onSave();
        // Firebase kayıt işleminin tamamlanması ve verinin yansıması için bekle
        await Future.delayed(const Duration(milliseconds: 1500));
        if (mounted) {
          onSaved?.call();
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

}

/// ✅ Staggered Mood Card - Fade + Scale Animation
class _StaggeredMoodCard extends StatelessWidget {
  final AnimationController animationController;
  final double delay;
  final Map<String, dynamic> mood;
  final bool isSelected;
  final VoidCallback onTap;

  const _StaggeredMoodCard({
    required this.animationController,
    required this.delay,
    required this.mood,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // Interval'ı doğru hesapla (0.0-1.0 arası, toplam animasyon süresi 1.5 saniye)
    final totalDuration = 1.5;
    final startTime = (delay / totalDuration).clamp(0.0, 1.0);
    final endTime = ((delay + 0.3) / totalDuration).clamp(0.0, 1.0);

    final animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: animationController,
        curve: Interval(
          startTime,
          endTime,
          curve: Curves.easeOut,
        ),
      ),
    );

    final scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(
        parent: animationController,
        curve: Interval(
          startTime,
          endTime,
          curve: Curves.easeOut,
        ),
      ),
    );

    return AnimatedBuilder(
      animation: animationController,
      builder: (context, child) {
        return Opacity(
          opacity: animation.value,
          child: Transform.scale(
            scale: scaleAnimation.value,
            child: GestureDetector(
              onTap: onTap,
              child: Container(
                decoration: BoxDecoration(
                  color: mood['color'] as Color,
                  borderRadius: BorderRadius.circular(12),
                  border: isSelected
                      ? Border.all(color: Colors.black, width: 3)
                      : null,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(mood['icon'] as IconData,
                        size: 30, color: Colors.white),
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
            ),
          ),
        );
      },
    );
  }
}

/// ✅ Cascade Card - Fade Animation
class _CascadeCard extends StatelessWidget {
  final AnimationController animationController;
  final double delay;
  final Widget child;

  const _CascadeCard({
    required this.animationController,
    required this.delay,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    // Interval'ı doğru hesapla (0.0-1.0 arası, toplam animasyon süresi 1.5 saniye)
    final totalDuration = 1.5;
    final startTime = (delay / totalDuration).clamp(0.0, 1.0);
    final endTime = ((delay + 0.3) / totalDuration).clamp(0.0, 1.0);

    final animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: animationController,
        curve: Interval(
          startTime,
          endTime,
          curve: Curves.easeOut,
        ),
      ),
    );

    return AnimatedBuilder(
      animation: animationController,
      builder: (context, _) {
        return Opacity(
          opacity: animation.value,
          child: child,
        );
      },
    );
  }
}

/// ✅ Animasyonlu Meditasyon Content
class _AnimatedMeditationContent extends StatefulWidget {
  const _AnimatedMeditationContent({super.key});

  @override
  State<_AnimatedMeditationContent> createState() =>
      _AnimatedMeditationContentState();
}

class _AnimatedMeditationContentState
    extends State<_AnimatedMeditationContent> {
  String _selectedCategory = 'Tümü';
  List<MeditationEntry> _meditations = [];
  bool _isLoading = true;

  final List<Map<String, dynamic>> _categories = [
    {'name': 'Tümü', 'icon': Icons.auto_awesome},
    {'name': 'Uyku', 'icon': Icons.bedtime_outlined},
    {'name': 'Stres', 'icon': Icons.favorite_outline},
    {'name': 'Odak', 'icon': Icons.radio_button_checked},
    {'name': 'Nefes', 'icon': Icons.air_outlined},
  ];

  @override
  void initState() {
    super.initState();
    _loadMeditations();
  }

  Future<void> _loadMeditations() async {
    setState(() {
      _isLoading = true;
    });

    final meditations = await MeditationService.getAllMeditations();
    setState(() {
      _meditations = meditations;
      _isLoading = false;
    });
  }

  List<MeditationEntry> get _filteredMeditations {
    if (_selectedCategory == 'Tümü') {
      return _meditations;
    }
    return _meditations
        .where((m) => m.category == _selectedCategory)
        .toList();
  }

  String _formatListens(int listens) {
    if (listens >= 1000) {
      return '${(listens / 1000).toStringAsFixed(1)}k';
    }
    return listens.toString();
  }

  @override
  Widget build(BuildContext context) {
    // Alt navigasyon çubuğu için yeterli boşluk bırak
    final bottomPadding = MediaQuery.of(context).padding.bottom;
    final navBarHeight = 70.0; // Navigasyon çubuğu yaklaşık yüksekliği
    
    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(
        20,
        0, // Padding yok - başlık en üstte
        20,
        bottomPadding + navBarHeight + 20, // Alt navigasyon için yeterli boşluk
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ✅ Başlık - Diğer sayfalarla aynı hizada (safeAreaTop + 16)
          Padding(
            padding: EdgeInsets.fromLTRB(0, MediaQuery.of(context).padding.top + 16, 0, 0),
            child: Row(
            children: [
              Icon(
                Icons.nightlight_outlined,
                color: Colors.grey.shade400,
                size: 24,
              ),
              const SizedBox(width: 8),
              Text(
                'Meditasyon',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey.shade800,
                ),
              ),
            ],
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'İçsel huzurunu keşfet',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 30),
          // ✅ Kategori Filtreleri
          SizedBox(
            height: 50,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _categories.length,
              itemBuilder: (context, index) {
                final category = _categories[index];
                final isSelected = _selectedCategory == category['name'];
                return Padding(
                  padding: const EdgeInsets.only(right: 12),
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedCategory = category['name'] as String;
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? Colors.grey.shade900
                            : Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (isSelected)
                            Icon(
                              Icons.auto_awesome,
                              size: 18,
                              color: Colors.white,
                            )
                          else
                            Icon(
                              category['icon'] as IconData,
                              size: 18,
                              color: Colors.grey.shade700,
                            ),
                          const SizedBox(width: 8),
                          Text(
                            category['name'] as String,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: isSelected
                                  ? Colors.white
                                  : Colors.grey.shade700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 30),
          // ✅ Meditasyon Kartları
          if (_isLoading)
            const Center(
              child: Padding(
                padding: EdgeInsets.all(40),
                child: CircularProgressIndicator(),
              ),
            )
          else if (_filteredMeditations.isEmpty)
            Center(
              child: Padding(
                padding: const EdgeInsets.all(40),
                child: Text(
                  'Bu kategoride meditasyon bulunamadı',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey.shade600,
                  ),
                ),
              ),
            )
          else
            ..._filteredMeditations.map(
              (meditation) => _MeditationCard(
                meditation: meditation,
                onPlay: () {
                  // Play butonu tıklandığında yapılacaklar
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('${meditation.title} başlatılıyor...'),
                      duration: const Duration(seconds: 1),
                    ),
                  );
                },
                formatListens: _formatListens,
              ),
            ),
        ],
      ),
    );
  }
}

/// ✅ Meditasyon Kartı
class _MeditationCard extends StatelessWidget {
  final MeditationEntry meditation;
  final VoidCallback onPlay;
  final String Function(int) formatListens;

  const _MeditationCard({
    required this.meditation,
    required this.onPlay,
    required this.formatListens,
  });

  @override
  Widget build(BuildContext context) {
    final colors = meditation.gradientColorsFlutter;
    
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      height: 170,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: colors.length >= 2
              ? [colors[0], colors[1]]
              : [colors[0], colors[0].withOpacity(0.8)],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: colors[0].withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // İçerik
          Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // İkon
                Text(
                  meditation.icon,
                  style: const TextStyle(fontSize: 28),
                ),
                const SizedBox(height: 10),
                // Başlık
                Text(
                  meditation.title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    height: 1.3,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const Spacer(),
                // Süre ve Dinlenme
                Row(
                  children: [
                    Icon(
                      Icons.access_time,
                      size: 14,
                      color: Colors.white.withOpacity(0.9),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${meditation.duration} dk',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.white.withOpacity(0.9),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Icon(
                      Icons.headphones,
                      size: 14,
                      color: Colors.white.withOpacity(0.9),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      formatListens(meditation.listens),
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.white.withOpacity(0.9),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                // Progress Bar
                Container(
                  height: 3,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(2),
                  ),
                  child: FractionallySizedBox(
                    alignment: Alignment.centerLeft,
                    widthFactor: meditation.progress,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Play Butonu
          Positioned(
            right: 20,
            top: 20,
            child: GestureDetector(
              onTap: onPlay,
              child: Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.3),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white.withOpacity(0.5),
                    width: 2,
                  ),
                ),
                child: const Icon(
                  Icons.play_arrow,
                  color: Colors.white,
                  size: 32,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
