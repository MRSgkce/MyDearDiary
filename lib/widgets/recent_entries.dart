import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'dart:io';
import '../models/diary_entry.dart';
import '../screens/add_entry_screen.dart';

class RecentEntries extends StatelessWidget {
  final List<DiaryEntry> entries;
  final VoidCallback onRefresh;

  const RecentEntries({
    super.key,
    required this.entries,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Bugünün girişleri başlığı
        Row(
          children: [
            Icon(
              Platform.isIOS ? CupertinoIcons.calendar : Icons.calendar_today,
              color: Platform.isIOS ? CupertinoColors.label : Colors.black87,
              size: 20,
            ),
            const SizedBox(width: 8),
            Text(
              'Bugünün Girişleri',
              style: Platform.isIOS
                  ? CupertinoTheme.of(
                      context,
                    ).textTheme.navTitleTextStyle.copyWith(
                      fontWeight: FontWeight.w600,
                      color: CupertinoColors.label,
                    )
                  : Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
            ),
          ],
        ),
        const SizedBox(height: 12),

        // Giriş listesi
        if (entries.isEmpty)
          _buildEmptyState(context)
        else
          ...entries.map((entry) => _buildEntryCard(context, entry)),
      ],
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Platform.isIOS
        ? Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: CupertinoColors.systemBackground,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: CupertinoColors.separator),
            ),
            child: Column(
              children: [
                Icon(
                  CupertinoIcons.book,
                  size: 64,
                  color: CupertinoColors.secondaryLabel,
                ),
                const SizedBox(height: 12),
                Text(
                  'Henüz giriş yok',
                  style: CupertinoTheme.of(context).textTheme.textStyle
                      .copyWith(color: CupertinoColors.secondaryLabel),
                ),
                const SizedBox(height: 4),
                Text(
                  'İlk girişini oluşturmak için + butonuna bas',
                  style: CupertinoTheme.of(context).textTheme.textStyle
                      .copyWith(color: CupertinoColors.secondaryLabel),
                ),
              ],
            ),
          )
        : Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Icon(
                    Icons.book_outlined,
                    size: 64,
                    color: Theme.of(context).colorScheme.outline,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Henüz giriş yok',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Theme.of(context).colorScheme.outline,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'İlk girişini oluşturmak için + butonuna bas',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.outline,
                    ),
                  ),
                ],
              ),
            ),
          );
  }

  Widget _buildEntryCard(BuildContext context, DiaryEntry entry) {
    return Platform.isIOS
        ? Container(
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: CupertinoColors.systemBackground,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: CupertinoColors.separator),
            ),
            child: CupertinoButton(
              padding: EdgeInsets.zero,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddEntryScreen(entry: entry),
                  ),
                ).then((_) => onRefresh());
              },
              child: Row(
                children: [
                  // Sol ikon
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: CupertinoColors.systemGrey6,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Icon(
                      CupertinoIcons.heart_fill,
                      color: CupertinoColors.systemRed,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  // İçerik
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          entry.content.length > 50
                              ? '${entry.content.substring(0, 50)}...'
                              : entry.content,
                          style: const TextStyle(
                            color: CupertinoColors.label,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          DateFormat('HH:mm', 'tr_TR').format(entry.date),
                          style: const TextStyle(
                            color: CupertinoColors.secondaryLabel,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          )
        : Card(
            margin: const EdgeInsets.only(bottom: 8),
            child: ListTile(
              leading: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Icon(Icons.favorite, color: Colors.red, size: 20),
              ),
              title: Text(
                entry.content.length > 50
                    ? '${entry.content.substring(0, 50)}...'
                    : entry.content,
                style: const TextStyle(color: Colors.black87, fontSize: 16),
              ),
              subtitle: Text(
                DateFormat('HH:mm', 'tr_TR').format(entry.date),
                style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddEntryScreen(entry: entry),
                  ),
                ).then((_) => onRefresh());
              },
            ),
          );
  }
}
