import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'dart:io';

class WeeklyActivities extends StatelessWidget {
  const WeeklyActivities({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Bu Hafta bölümü
        Row(
          children: [
            Icon(
              Platform.isIOS ? CupertinoIcons.chart_bar : Icons.track_changes,
              color: Platform.isIOS ? CupertinoColors.label : Colors.black87,
              size: 20,
            ),
            const SizedBox(width: 8),
            Text(
              'Bu Hafta',
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
        const SizedBox(height: 16),

        // Haftalık aktiviteler
        Column(
          children: [
            _buildWeeklyActivity(
              context,
              'Meditasyon',
              Icons.self_improvement,
              Colors.purple,
              4,
              7,
            ),
            const SizedBox(height: 12),
            _buildWeeklyActivity(
              context,
              'Olumlamalar',
              Icons.psychology,
              Colors.green,
              6,
              7,
            ),
            const SizedBox(height: 12),
            _buildWeeklyActivity(
              context,
              'Ruh Hali Takibi',
              Icons.mood,
              Colors.blue,
              7,
              7,
            ),
          ],
        ),
      ],
    );
  }

  // Haftalık aktivite widget'ı oluşturma fonksiyonu
  Widget _buildWeeklyActivity(
    BuildContext context,
    String title,
    IconData icon,
    Color color,
    int completed,
    int total,
  ) {
    final progress = completed / total;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Platform.isIOS ? CupertinoColors.systemBackground : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Platform.isIOS
              ? CupertinoColors.separator
              : Colors.grey.shade200,
          width: 1,
        ),
      ),
      child: Row(
        children: [
          // İkon
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 12),
          // Başlık ve ilerleme
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Platform.isIOS
                      ? CupertinoTheme.of(context).textTheme.textStyle.copyWith(
                          fontWeight: FontWeight.w600,
                        )
                      : Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                ),
                const SizedBox(height: 8),
                // İlerleme çubuğu
                LinearProgressIndicator(
                  value: progress,
                  backgroundColor: color.withOpacity(0.1),
                  valueColor: AlwaysStoppedAnimation<Color>(color),
                  borderRadius: BorderRadius.circular(4),
                  minHeight: 6,
                ),
                const SizedBox(height: 4),
                // Sayısal gösterim
                Text(
                  '$completed/$total',
                  style: Platform.isIOS
                      ? CupertinoTheme.of(context).textTheme.textStyle.copyWith(
                          color: CupertinoColors.secondaryLabel,
                          fontWeight: FontWeight.w500,
                        )
                      : Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.outline,
                          fontWeight: FontWeight.w500,
                        ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
