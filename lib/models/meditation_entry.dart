import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class MeditationEntry {
  final String id;
  final String title;
  final String category; // Tümü, Uyku, Stres, Odak, Nefes
  final int duration; // Dakika cinsinden
  final int listens; // Dinlenme sayısı
  final String icon; // Emoji
  final List<int> gradientColors; // Gradient renkleri (Color value olarak)
  final double progress; // 0.0 - 1.0 arası ilerleme
  final String? audioUrl; // Ses dosyası URL'i (gelecekte kullanılabilir)
  final DateTime createdAt;

  MeditationEntry({
    required this.id,
    required this.title,
    required this.category,
    required this.duration,
    required this.listens,
    required this.icon,
    required this.gradientColors,
    this.progress = 0.0,
    this.audioUrl,
    required this.createdAt,
  });

  // JSON'dan MeditationEntry oluştur
  factory MeditationEntry.fromJson(Map<String, dynamic> json) {
    DateTime parseDateTime(dynamic value) {
      if (value is Timestamp) {
        return value.toDate();
      } else if (value is int) {
        return DateTime.fromMillisecondsSinceEpoch(value);
      } else {
        return DateTime.now();
      }
    }

    return MeditationEntry(
      id: json['id'] as String,
      title: json['title'] as String,
      category: json['category'] as String,
      duration: json['duration'] as int,
      listens: json['listens'] as int,
      icon: json['icon'] as String,
      gradientColors: (json['gradientColors'] as List<dynamic>?)
              ?.map((c) => c is int ? c : int.parse(c.toString()))
              .toList() ??
          [0xFF6B73FF, 0xFF8B9AFF],
      progress: (json['progress'] as num?)?.toDouble() ?? 0.0,
      audioUrl: json['audioUrl'] as String?,
      createdAt: parseDateTime(json['createdAt']),
    );
  }

  // MeditationEntry'yi JSON'a çevir
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'category': category,
      'duration': duration,
      'listens': listens,
      'icon': icon,
      'gradientColors': gradientColors,
      'progress': progress,
      'audioUrl': audioUrl,
      'createdAt': createdAt.millisecondsSinceEpoch,
    };
  }

  // Gradient renklerini Flutter Color'a çevir
  List<Color> get gradientColorsFlutter {
    return gradientColors.map((c) => Color(c)).toList();
  }
}

