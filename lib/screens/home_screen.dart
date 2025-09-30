import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'dart:io';
import '../models/diary_entry.dart';
import '../services/diary_service.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/inspiration_tab.dart';
import '../widgets/mood_card.dart';
import '../widgets/mood_tab.dart';
import '../widgets/weekly_activities.dart';
import '../widgets/quick_actions.dart';
import '../widgets/recent_entries.dart';
import 'add_entry_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<DiaryEntry> _recentEntries = [];
  int _selectedIndex = 0; // Seçili sekme indeksi

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
      appBar: const CustomAppBar(),
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
        selectedItemColor: Theme.of(context).colorScheme.primary,
        unselectedItemColor: Theme.of(context).colorScheme.outline,
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600),
        items: [
          BottomNavigationBarItem(
            icon: Image.asset(
              'assets/images/bulb.png',
              width: 24,
              height: 24,
              color: Theme.of(context).colorScheme.outline,
            ),
            activeIcon: Image.asset(
              'assets/images/bulb.png',
              width: 24,
              height: 24,
              color: Theme.of(context).colorScheme.primary,
            ),
            label: 'İlham',
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              'assets/icons/diary_outline.png',
              width: 24,
              height: 24,
            ),
            activeIcon: Image.asset(
              'assets/icons/diary_filled.png',
              width: 24,
              height: 24,
            ),
            label: 'Günlük',
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              'assets/icons/mood_outline.png',
              width: 24,
              height: 24,
            ),
            activeIcon: Image.asset(
              'assets/icons/mood_filled.png',
              width: 24,
              height: 24,
            ),
            label: 'Ruh Hali',
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              'assets/icons/meditation_outline.png',
              width: 24,
              height: 24,
            ),
            activeIcon: Image.asset(
              'assets/icons/meditation_filled.png',
              width: 24,
              height: 24,
            ),
            label: 'Meditasyon',
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
        items: const [
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.book),
            activeIcon: Icon(CupertinoIcons.book_fill),
            label: 'Günlük',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.lightbulb),
            activeIcon: Icon(CupertinoIcons.lightbulb_fill),
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
        ],
      ),
      tabBuilder: (context, index) {
        if (index == 0) {
          return CupertinoTabView(
            builder: (context) => CupertinoPageScaffold(
              navigationBar: const CustomAppBar(),
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

  // Ana içerik widget'ı
  Widget _buildDiaryContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Ruh hali kartı
        const MoodCard(),

        const SizedBox(height: 32),

        // Haftalık aktiviteler
        const WeeklyActivities(),

        const SizedBox(height: 32),

        // Hızlı eylemler
        QuickActions(onRefresh: _loadRecentEntries),

        const SizedBox(height: 32),

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
      case 1:
        return 'İlham';
      case 2:
        return 'Ruh Hali';
      case 3:
        return 'Meditasyon';
      default:
        return 'Günlük';
    }
  }

  String _tabDescription(int index) {
    switch (index) {
      case 1:
        return 'İlham köşesi üzerinde çalışıyoruz. Yakında size ilham verecek içerikler burada olacak!';
      case 2:
        return 'Ruh hali takibi çok yakında devrede olacak. Günlük modunuzu kolayca kaydedebileceksiniz.';
      case 3:
        return 'Meditasyon deneyimi hazırlık aşamasında. Sakinleşmek için kısa egzersizler burada yer alacak!';
      default:
        return '';
    }
  }

  IconData _materialPlaceholderIcon(int index) {
    switch (index) {
      case 1:
        return Icons.lightbulb_outline;
      case 2:
        return Icons.favorite_outline;
      case 3:
        return Icons.self_improvement_outlined;
      default:
        return Icons.book_outlined;
    }
  }

  IconData _cupertinoPlaceholderIcon(int index) {
    switch (index) {
      case 1:
        return CupertinoIcons.lightbulb;
      case 2:
        return CupertinoIcons.heart;
      case 3:
        return CupertinoIcons.sparkles;
      default:
        return CupertinoIcons.book;
    }
  }
}
