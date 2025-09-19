import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'dart:io';

class MoodCard extends StatelessWidget {
  const MoodCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Ana ruh hali kartı - "Bugün"
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Platform.isIOS
                ? CupertinoColors.systemBackground
                : Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: Platform.isIOS
                  ? CupertinoColors.separator
                  : Colors.grey.shade200,
              width: 1,
            ),
          ),
          child: Row(
            children: [
              // Sol taraf - Metinler
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Bugün',
                      style: Platform.isIOS
                          ? CupertinoTheme.of(
                              context,
                            ).textTheme.navTitleTextStyle.copyWith(
                              fontWeight: FontWeight.bold,
                              fontSize: 24,
                              color: CupertinoColors.label,
                            )
                          : Theme.of(
                              context,
                            ).textTheme.headlineMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      DateFormat(
                        'dd MMMM EEEE',
                        'tr_TR',
                      ).format(DateTime.now()),
                      style: Platform.isIOS
                          ? CupertinoTheme.of(
                              context,
                            ).textTheme.textStyle.copyWith(
                              color: CupertinoColors.secondaryLabel,
                              fontSize: 16,
                            )
                          : Theme.of(context).textTheme.bodyLarge?.copyWith(
                              color: Colors.grey.shade600,
                            ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'İyi',
                      style: Platform.isIOS
                          ? CupertinoTheme.of(
                              context,
                            ).textTheme.navTitleTextStyle.copyWith(
                              fontWeight: FontWeight.bold,
                              fontSize: 32,
                              color: CupertinoColors.label,
                            )
                          : Theme.of(context).textTheme.headlineLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
