import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'dart:io';
import '../models/diary_entry.dart';
import '../services/diary_service.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/mood_card.dart';
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

  // Bottom navigation bar tıklama fonksiyonu
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    // Her sekme için farklı işlemler
    switch (index) {
      case 0:
        // Günlük - zaten ana sayfa
        break;
      case 1:
        // İlham - yeni sayfa aç
        _showInspirationPage();
        break;
      case 2:
        // Ruh Hali - ruh hali sayfası aç
        _showMoodPage();
        break;
      case 3:
        // Meditasyon - meditasyon sayfası aç
        _showMeditationPage();
        break;
    }
  }

  // İlham sayfası
  void _showInspirationPage() {
    if (Platform.isIOS) {
      showCupertinoDialog(
        context: context,
        builder: (context) => CupertinoAlertDialog(
          title: const Text('İlham'),
          content: const Text('İlham sayfası yakında gelecek!'),
          actions: [
            CupertinoDialogAction(
              onPressed: () => Navigator.pop(context),
              child: const Text('Tamam'),
            ),
          ],
        ),
      );
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('İlham'),
          content: const Text('İlham sayfası yakında gelecek!'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Tamam'),
            ),
          ],
        ),
      );
    }
  }

  // Ruh hali sayfası
  void _showMoodPage() {
    if (Platform.isIOS) {
      showCupertinoDialog(
        context: context,
        builder: (context) => CupertinoAlertDialog(
          title: const Text('Ruh Hali'),
          content: const Text('Ruh hali takibi yakında gelecek!'),
          actions: [
            CupertinoDialogAction(
              onPressed: () => Navigator.pop(context),
              child: const Text('Tamam'),
            ),
          ],
        ),
      );
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Ruh Hali'),
          content: const Text('Ruh hali takibi yakında gelecek!'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Tamam'),
            ),
          ],
        ),
      );
    }
  }

  // Meditasyon sayfası
  void _showMeditationPage() {
    if (Platform.isIOS) {
      showCupertinoDialog(
        context: context,
        builder: (context) => CupertinoAlertDialog(
          title: const Text('Meditasyon'),
          content: const Text('Meditasyon sayfası yakında gelecek!'),
          actions: [
            CupertinoDialogAction(
              onPressed: () => Navigator.pop(context),
              child: const Text('Tamam'),
            ),
          ],
        ),
      );
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Meditasyon'),
          content: const Text('Meditasyon sayfası yakında gelecek!'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Tamam'),
            ),
          ],
        ),
      );
    }
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
      return CupertinoPageScaffold(
        navigationBar: const CustomAppBar(),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: _buildBody(),
          ),
        ),
      );
    } else {
      return Scaffold(
        appBar: const CustomAppBar(),
        body: SafeArea(
          child: RefreshIndicator(
            onRefresh: _loadRecentEntries,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(16),
              child: _buildBody(),
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const AddEntryScreen()),
            ).then((_) => _loadRecentEntries());
          },
          icon: const Icon(Icons.add),
          label: const Text('Yeni Giriş'),
        ),
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          selectedItemColor: Theme.of(context).colorScheme.primary,
          unselectedItemColor: Theme.of(context).colorScheme.outline,
          selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600),
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.book_outlined),
              activeIcon: Icon(Icons.book),
              label: 'Günlük',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.lightbulb_outline),
              activeIcon: Icon(Icons.lightbulb),
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
          ],
        ),
      );
    }
  }

  // Ana içerik widget'ı
  Widget _buildBody() {
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
}
