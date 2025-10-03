import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:io';
import '../widgets/custom_app_bar.dart';
import '../widgets/inspiration_tab.dart';
import '../widgets/mood_tab.dart';
import '../widgets/profile_tab.dart';
import '../widgets/adaptive_layout.dart';
import '../widgets/adaptive_navigation.dart';
import '../utils/responsive_helper.dart';
import '../providers/app_state_provider.dart';
import '../providers/inspiration_provider.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedIndex = ref.watch(selectedTabIndexProvider);

    return ResponsiveBuilder(
      builder: (context, deviceType, deviceSize) {
        return AdaptiveScaffold(
          appBar: _buildAdaptiveAppBar(context, ref, selectedIndex),
          body: _buildAdaptiveBody(context, ref, selectedIndex),
          navigationBar: _buildAdaptiveNavigationBar(
            context,
            ref,
            selectedIndex,
          ),
          navigationItems: _getNavigationItems(),
          selectedIndex: selectedIndex,
          onNavigationTap: (index) =>
              ref.read(selectedTabIndexProvider.notifier).state = index,
          floatingActionButton: null,
        );
      },
    );
  }

  // Adaptif AppBar
  Widget? _buildAdaptiveAppBar(
    BuildContext context,
    WidgetRef ref,
    int selectedIndex,
  ) {
    final deviceType = ResponsiveHelper.getDeviceType(context);

    if (deviceType == DeviceType.desktop ||
        deviceType == DeviceType.largeDesktop) {
      return null; // Desktop'ta sidebar kullanıyoruz
    }

    return CustomAppBar(
      onAddInspirationPressed: selectedIndex == 0
          ? () => _showAddInspirationDialog(context, ref)
          : null,
    );
  }

  // Adaptif Body
  Widget _buildAdaptiveBody(
    BuildContext context,
    WidgetRef ref,
    int selectedIndex,
  ) {
    return AdaptiveLayout(
      scrollable: selectedIndex != 0, // İlham sekmesi için scrollable değil
      child: _buildAdaptiveTabContent(context, ref, selectedIndex),
    );
  }

  // Adaptif Navigation Bar
  Widget _buildAdaptiveNavigationBar(
    BuildContext context,
    WidgetRef ref,
    int selectedIndex,
  ) {
    return AdaptiveNavigationBar(
      selectedIndex: selectedIndex,
      onTap: (index) =>
          ref.read(selectedTabIndexProvider.notifier).state = index,
      items: _getNavigationItems(),
    );
  }

  // Navigation Items
  List<AdaptiveNavigationItem> _getNavigationItems() {
    return const [
      AdaptiveNavigationItem(
        icon: Icons.format_quote_outlined,
        activeIcon: Icons.format_quote,
        label: 'İlham',
      ),
      AdaptiveNavigationItem(
        icon: Icons.favorite_outline,
        activeIcon: Icons.favorite,
        label: 'Ruh Hali',
      ),
      AdaptiveNavigationItem(
        icon: Icons.self_improvement_outlined,
        activeIcon: Icons.self_improvement,
        label: 'Meditasyon',
      ),
      AdaptiveNavigationItem(
        icon: Icons.person_outline,
        activeIcon: Icons.person,
        label: 'Profil',
      ),
    ];
  }

  // Tab Content
  Widget _buildAdaptiveTabContent(
    BuildContext context,
    WidgetRef ref,
    int selectedIndex,
  ) {
    switch (selectedIndex) {
      case 0:
        return const InspirationTab(isCupertino: false);
      case 1:
        return const MoodTab(isCupertino: false);
      case 2:
        return _buildComingSoonContent(
          title: 'Meditasyon',
          description: 'Meditasyon özellikleri yakında gelecek!',
          icon: Icons.self_improvement,
          isCupertino: false,
        );
      case 3:
        return const ProfileTab(isCupertino: false);
      default:
        return const SizedBox.shrink();
    }
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
              color: isCupertino ? CupertinoColors.systemGrey : Colors.amber,
            ),
            const SizedBox(height: 24),
            Text(
              title,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: isCupertino ? CupertinoColors.label : Colors.black87,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              description,
              style: TextStyle(
                fontSize: 16,
                color: isCupertino
                    ? CupertinoColors.secondaryLabel
                    : Colors.grey,
              ),
              textAlign: TextAlign.center,
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
