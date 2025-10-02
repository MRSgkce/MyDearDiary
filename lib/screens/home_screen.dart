import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'dart:io';
import '../models/diary_entry.dart';
import '../services/diary_service.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/inspiration_tab.dart';
import '../widgets/mood_tab.dart';
import '../widgets/weekly_activities.dart';
import '../widgets/quick_actions.dart';
import '../widgets/recent_entries.dart';
import '../widgets/personalized_home_widgets.dart';
import '../widgets/personalization_settings.dart';
import '../widgets/profile_tab.dart';
import 'add_entry_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<DiaryEntry> _recentEntries = [];
  int _selectedIndex = 0; // Seçili sekme indeksi
  List<String> _enabledWidgets = [
    'Günlük Hedef',
    'Hızlı İstatistikler',
    'Duygusal Özet',
    'Akıllı Öneriler',
    'Hızlı Erişim',
  ]; // Aktif widget'lar

  @override
  void initState() {
    super.initState();
    _loadRecentEntries();
  }

  Future<void> _loadRecentEntries() async {
    final entries = await DiaryService.getAllEntries();
    setState(() {
      _recentEntries = entries.take(3).toList();
    });
  }

  void _openPersonalizationSettings() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PersonalizationSettings(
          isCupertino: Platform.isIOS,
          enabledWidgets: _enabledWidgets,
          onWidgetsChanged: (newWidgets) {
            setState(() {
              _enabledWidgets = newWidgets;
            });
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (Platform.isIOS) {
      return _buildCupertinoLayout();
    } else {
      return _buildMaterialLayout();
    }
  }

  Widget _buildMaterialLayout() {
    return Scaffold(
      appBar: CustomAppBar(onPersonalizePressed: _openPersonalizationSettings),
      body: SafeArea(child: _buildMaterialBody()),
      floatingActionButton: _selectedIndex == 0
          ? FloatingActionButton.extended(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AddEntryScreen(),
                  ),
                ).then((_) => _loadRecentEntries());
              },
              icon: const Icon(Icons.add),
              label: const Text('Yeni Giriş'),
            )
          : null,
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
        selectedItemColor: const Color(0xFF6B46C1),
        unselectedItemColor: Colors.grey,
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600),
        backgroundColor: Colors.white,
        elevation: 8,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.book_outlined),
            activeIcon: Icon(Icons.book),
            label: 'Günlük',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.format_quote_outlined),
            activeIcon: Icon(Icons.format_quote),
            label: 'İlham',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite_outline),
            activeIcon: Icon(Icons.favorite),
            label: 'Ruh Hali',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.self_improvement_outlined),
            activeIcon: Icon(Icons.self_improvement),
            label: 'Meditasyon',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Profil',
          ),
        ],
      ),
    );
  }

  Widget _buildMaterialBody() {
    if (_selectedIndex == 0) {
      return RefreshIndicator(
        onRefresh: _loadRecentEntries,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16),
          child: _buildDiaryContent(),
        ),
      );
    }

    if (_selectedIndex == 1) {
      return const InspirationTab();
    }

    if (_selectedIndex == 2) {
      return const MoodTab();
    }

    if (_selectedIndex == 3) {
      return _buildComingSoonContent(
        title: 'Meditasyon',
        description:
            'Meditasyon deneyimi hazırlık aşamasında. Sakinleşmek için kısa egzersizler burada yer alacak!',
        icon: Icons.self_improvement_outlined,
      );
    }

    if (_selectedIndex == 4) {
      return const ProfileTab();
    }

    return _buildComingSoonContent(
      title: _tabTitle(_selectedIndex),
      description: _tabDescription(_selectedIndex),
      icon: _materialPlaceholderIcon(_selectedIndex),
    );
  }

  Widget _buildCupertinoLayout() {
    return CupertinoTabScaffold(
      tabBar: CupertinoTabBar(
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
        activeColor: const Color(0xFF6B46C1),
        inactiveColor: CupertinoColors.inactiveGray,
        backgroundColor: CupertinoColors.systemBackground,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.book),
            activeIcon: Icon(CupertinoIcons.book_fill),
            label: 'Günlük',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.chat_bubble_2),
            activeIcon: Icon(CupertinoIcons.chat_bubble_2_fill),
            label: 'İlham',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.heart),
            activeIcon: Icon(CupertinoIcons.heart_fill),
            label: 'Ruh Hali',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.sparkles),
            activeIcon: Icon(CupertinoIcons.sparkles),
            label: 'Meditasyon',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.person),
            activeIcon: Icon(CupertinoIcons.person_fill),
            label: 'Profil',
          ),
        ],
      ),
      tabBuilder: (context, index) {
        if (index == 0) {
          return CupertinoTabView(
            builder: (context) => CupertinoPageScaffold(
              navigationBar: CustomAppBar(
                onPersonalizePressed: _openPersonalizationSettings,
              ),
              child: SafeArea(
                bottom: false,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: _buildDiaryContent(),
                ),
              ),
            ),
          );
        }

        return CupertinoTabView(
          builder: (context) => CupertinoPageScaffold(
            navigationBar: const CustomAppBar(),
            child: SafeArea(
              bottom: false,
              child: index == 1
                  ? const InspirationTab(isCupertino: true)
                  : index == 2
                  ? const MoodTab(isCupertino: true)
                  : index == 3
                  ? _buildComingSoonContent(
                      title: 'Meditasyon',
                      description:
                          'Meditasyon deneyimi hazırlık aşamasında. Sakinleşmek için kısa egzersizler burada yer alacak!',
                      icon: CupertinoIcons.sparkles,
                      isCupertino: true,
                    )
                  : index == 4
                  ? const ProfileTab(isCupertino: true)
                  : _buildComingSoonContent(
                      title: _tabTitle(index),
                      description: _tabDescription(index),
                      icon: _cupertinoPlaceholderIcon(index),
                      isCupertino: true,
                    ),
            ),
          ),
        );
      },
    );
  }

  // Ana içerik widget'ı - Kişiselleştirilebilir
  Widget _buildDiaryContent() {
    final availableWidgets = PersonalizedWidgetManager.availableWidgets;
    final isCupertino = Platform.isIOS;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Kişiselleştirilebilir widget'lar
        ..._enabledWidgets.map((widgetTitle) {
          final widget = availableWidgets.firstWhere(
            (w) => w.title == widgetTitle,
            orElse: () => availableWidgets.first,
          );
          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: widget.build(context, isCupertino: isCupertino),
          );
        }).toList(),

        const SizedBox(height: 16),

        // Haftalık aktiviteler
        const WeeklyActivities(),

        const SizedBox(height: 16),

        // Hızlı eylemler
        QuickActions(onRefresh: _loadRecentEntries),

        const SizedBox(height: 16),

        // Son girişler
        RecentEntries(entries: _recentEntries, onRefresh: _loadRecentEntries),
      ],
    );
  }

  Widget _buildComingSoonContent({
    required String title,
    required String description,
    required IconData icon,
    bool isCupertino = false,
  }) {
    final textStyle = isCupertino
        ? const TextStyle(
            fontSize: 16,
            color: CupertinoColors.secondaryLabel,
            height: 1.5,
          )
        : const TextStyle(fontSize: 16, color: Colors.black54, height: 1.5);

    final titleStyle = isCupertino
        ? const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w600,
            color: CupertinoColors.label,
          )
        : const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          );

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 56,
              color: isCupertino ? CupertinoColors.activeBlue : Colors.black38,
            ),
            const SizedBox(height: 24),
            Text(title, style: titleStyle, textAlign: TextAlign.center),
            const SizedBox(height: 12),
            Text(description, style: textStyle, textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }

  String _tabTitle(int index) {
    switch (index) {
      case 0:
        return 'Günlük';
      case 1:
        return 'İlham';
      case 2:
        return 'Ruh Hali';
      case 3:
        return 'Meditasyon';
      case 4:
        return 'Profil';
      default:
        return 'Günlük';
    }
  }

  String _tabDescription(int index) {
    switch (index) {
      case 0:
        return 'Günlük yazma alışkanlığınızı geliştirin.';
      case 1:
        return 'İlham köşesi üzerinde çalışıyoruz. Yakında size ilham verecek içerikler burada olacak!';
      case 2:
        return 'Ruh hali takibi çok yakında devrede olacak. Günlük modunuzu kolayca kaydedebileceksiniz.';
      case 3:
        return 'Meditasyon deneyimi hazırlık aşamasında. Sakinleşmek için kısa egzersizler burada yer alacak!';
      case 4:
        return 'Profil ayarlarınız ve kişisel bilgileriniz.';
      default:
        return '';
    }
  }

  IconData _materialPlaceholderIcon(int index) {
    switch (index) {
      case 0:
        return Icons.book_outlined;
      case 1:
        return Icons.format_quote_outlined;
      case 2:
        return Icons.favorite_outline;
      case 3:
        return Icons.self_improvement_outlined;
      case 4:
        return Icons.person_outline;
      default:
        return Icons.book_outlined;
    }
  }

  IconData _cupertinoPlaceholderIcon(int index) {
    switch (index) {
      case 0:
        return CupertinoIcons.book;
      case 1:
        return CupertinoIcons.chat_bubble_2;
      case 2:
        return CupertinoIcons.heart;
      case 3:
        return CupertinoIcons.sparkles;
      case 4:
        return CupertinoIcons.person;
      default:
        return CupertinoIcons.book;
    }
  }
}
