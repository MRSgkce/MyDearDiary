import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:io';
import '../widgets/custom_app_bar.dart';
import '../widgets/inspiration_tab.dart';
import '../widgets/mood_tab.dart';
import '../widgets/personalized_home_widgets.dart';
import '../widgets/profile_tab.dart';
import '../providers/app_state_provider.dart';
import '../providers/inspiration_provider.dart';
import 'add_entry_screen.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedIndex = ref.watch(selectedTabIndexProvider);
    final enabledWidgets = ref.watch(enabledWidgetsProvider);

    if (Platform.isIOS) {
      return _buildCupertinoLayout(context, ref, selectedIndex, enabledWidgets);
    } else {
      return _buildMaterialLayout(context, ref, selectedIndex, enabledWidgets);
    }
  }

  Widget _buildMaterialLayout(
    BuildContext context,
    WidgetRef ref,
    int selectedIndex,
    List<String> enabledWidgets,
  ) {
    return Scaffold(
      appBar: const CustomAppBar(),
      body: SafeArea(
        child: _buildMaterialBody(context, ref, selectedIndex, enabledWidgets),
      ),
      floatingActionButton: selectedIndex == 0
          ? FloatingActionButton.extended(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AddEntryScreen(),
                  ),
                );
              },
              icon: const Icon(Icons.add),
              label: const Text('Yeni Giriş'),
            )
          : null,
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: selectedIndex,
        onTap: (index) =>
            ref.read(selectedTabIndexProvider.notifier).state = index,
        selectedItemColor: const Color(0xFF6B46C1),
        unselectedItemColor: Colors.grey,
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600),
        backgroundColor: const Color(0xFFF2F2F2),
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

  Widget _buildCupertinoLayout(
    BuildContext context,
    WidgetRef ref,
    int selectedIndex,
    List<String> enabledWidgets,
  ) {
    return CupertinoTabScaffold(
      tabBar: CupertinoTabBar(
        currentIndex: selectedIndex,
        onTap: (index) =>
            ref.read(selectedTabIndexProvider.notifier).state = index,
        activeColor: const Color(0xFF6B46C1),
        inactiveColor: CupertinoColors.inactiveGray,
        backgroundColor: const Color(0xFFF2F2F2),
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
              navigationBar: const CustomAppBar(),
              child: SafeArea(
                bottom: false,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: _buildDiaryContent(context, ref, enabledWidgets),
                ),
              ),
            ),
          );
        }

        return CupertinoTabView(
          builder: (context) => CupertinoPageScaffold(
            navigationBar: CustomAppBar(
              onAddInspirationPressed: index == 1
                  ? () => _showAddInspirationDialog(context, ref)
                  : null,
            ),
            child: SafeArea(
              bottom: false,
              child: index == 1
                  ? const InspirationTab(isCupertino: true)
                  : index == 2
                  ? const MoodTab(isCupertino: true)
                  : index == 3
                  ? _buildComingSoonContent(
                      title: 'Meditasyon',
                      description: 'Meditasyon özellikleri yakında gelecek!',
                      icon: CupertinoIcons.sparkles,
                      isCupertino: true,
                    )
                  : ProfileTab(isCupertino: true),
            ),
          ),
        );
      },
    );
  }

  Widget _buildMaterialBody(
    BuildContext context,
    WidgetRef ref,
    int selectedIndex,
    List<String> enabledWidgets,
  ) {
    if (selectedIndex == 0) {
      return RefreshIndicator(
        onRefresh: () async {},
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16),
          child: _buildDiaryContent(context, ref, enabledWidgets),
        ),
      );
    }

    return _buildTabContent(context, ref, selectedIndex);
  }

  Widget _buildTabContent(
    BuildContext context,
    WidgetRef ref,
    int selectedIndex,
  ) {
    switch (selectedIndex) {
      case 1:
        return const InspirationTab(isCupertino: false);
      case 2:
        return const MoodTab(isCupertino: false);
      case 3:
        return _buildComingSoonContent(
          title: 'Meditasyon',
          description: 'Meditasyon özellikleri yakında gelecek!',
          icon: Icons.self_improvement,
          isCupertino: false,
        );
      case 4:
        return const ProfileTab(isCupertino: false);
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildDiaryContent(
    BuildContext context,
    WidgetRef ref,
    List<String> enabledWidgets,
  ) {
    final availableWidgets = PersonalizedWidgetManager.availableWidgets;

    return Column(
      children: [
        ...enabledWidgets.map((widgetName) {
          final widget = availableWidgets.firstWhere(
            (w) => w.title == widgetName,
            orElse: () => throw Exception('Widget not found: $widgetName'),
          );
          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: widget.build(context, isCupertino: Platform.isIOS),
          );
        }).toList(),
      ],
    );
  }

  Widget _buildComingSoonContent({
    required String title,
    required String description,
    required IconData icon,
    required bool isCupertino,
  }) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 80,
              color: isCupertino ? CupertinoColors.systemGrey : Colors.grey,
            ),
            const SizedBox(height: 24),
            Text(
              title,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: isCupertino ? CupertinoColors.label : null,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              description,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: isCupertino
                    ? CupertinoColors.secondaryLabel
                    : Colors.black54,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showAddInspirationDialog(BuildContext context, WidgetRef ref) {
    final TextEditingController inspirationController = TextEditingController();
    final TextEditingController authorController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => Platform.isIOS
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
                  const SizedBox(height: 8),
                  CupertinoTextField(
                    controller: authorController,
                    placeholder: 'Yazar (isteğe bağlı)',
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
                  onPressed: () async {
                    if (inspirationController.text.trim().isNotEmpty) {
                      await ref
                          .read(inspirationsProvider.notifier)
                          .addInspiration(
                            inspirationController.text.trim(),
                            author: authorController.text.trim().isNotEmpty
                                ? authorController.text.trim()
                                : null,
                          );
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
                  const SizedBox(height: 8),
                  TextField(
                    controller: authorController,
                    decoration: const InputDecoration(
                      hintText: 'Yazar (isteğe bağlı)',
                      border: OutlineInputBorder(),
                    ),
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
                  onPressed: () async {
                    if (inspirationController.text.trim().isNotEmpty) {
                      await ref
                          .read(inspirationsProvider.notifier)
                          .addInspiration(
                            inspirationController.text.trim(),
                            author: authorController.text.trim().isNotEmpty
                                ? authorController.text.trim()
                                : null,
                          );
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
}
