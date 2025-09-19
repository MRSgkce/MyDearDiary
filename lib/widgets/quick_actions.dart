import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'dart:io';
import '../screens/add_entry_screen.dart';
import '../screens/entry_list_screen.dart';

class QuickActions extends StatelessWidget {
  final VoidCallback onRefresh;

  const QuickActions({super.key, required this.onRefresh});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Hızlı eylemler başlığı
        Text(
          'Hızlı Eylemler',
          style: Platform.isIOS
              ? CupertinoTheme.of(context).textTheme.navTitleTextStyle.copyWith(
                  fontWeight: FontWeight.w600,
                  color: CupertinoColors.label,
                )
              : Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
        ),
        const SizedBox(height: 12),

        // Hızlı eylem butonları
        Row(
          children: [
            Expanded(
              child: Platform.isIOS
                  ? CupertinoButton(
                      onPressed: () {
                        // Ruh hali sayfası
                        _showMoodPage(context);
                      },
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: CupertinoColors.systemBackground,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: CupertinoColors.separator),
                        ),
                        child: const Column(
                          children: [
                            Icon(CupertinoIcons.heart, size: 32),
                            SizedBox(height: 8),
                            Text(
                              'Ruh Hali',
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                color: CupertinoColors.label,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  : Card(
                      child: InkWell(
                        onTap: () {
                          // Ruh hali sayfası
                          _showMoodPage(context);
                        },
                        borderRadius: BorderRadius.circular(12),
                        child: const Padding(
                          padding: EdgeInsets.all(20),
                          child: Column(
                            children: [
                              Icon(Icons.favorite_border, size: 32),
                              SizedBox(height: 8),
                              Text(
                                'Ruh Hali',
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black87,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Platform.isIOS
                  ? CupertinoButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const AddEntryScreen(),
                          ),
                        ).then((_) => onRefresh());
                      },
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: CupertinoColors.systemBackground,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: CupertinoColors.separator),
                        ),
                        child: const Column(
                          children: [
                            Icon(CupertinoIcons.add, size: 32),
                            SizedBox(height: 8),
                            Text(
                              'Not Ekle',
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                color: CupertinoColors.label,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  : Card(
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const AddEntryScreen(),
                            ),
                          ).then((_) => onRefresh());
                        },
                        borderRadius: BorderRadius.circular(12),
                        child: const Padding(
                          padding: EdgeInsets.all(20),
                          child: Column(
                            children: [
                              Icon(Icons.add, size: 32),
                              SizedBox(height: 8),
                              Text(
                                'Not Ekle',
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black87,
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
      ],
    );
  }

  // Ruh hali sayfası
  void _showMoodPage(BuildContext context) {
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
}
