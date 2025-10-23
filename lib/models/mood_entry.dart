class MoodEntry {
  final String id;
  final String mood;
  final String emoji;
  final String? journalPrompt1;
  final String? journalPrompt2;
  final DateTime date;
  final DateTime createdAt;

  MoodEntry({
    required this.id,
    required this.mood,
    required this.emoji,
    this.journalPrompt1,
    this.journalPrompt2,
    required this.date,
    required this.createdAt,
  });

  // JSON'dan MoodEntry oluştur
  factory MoodEntry.fromJson(Map<String, dynamic> json) {
    return MoodEntry(
      id: json['id'] as String,
      mood: json['mood'] as String,
      emoji: json['emoji'] as String,
      journalPrompt1: json['journalPrompt1'] as String?,
      journalPrompt2: json['journalPrompt2'] as String?,
      date: DateTime.fromMillisecondsSinceEpoch(json['date'] as int),
      createdAt: DateTime.fromMillisecondsSinceEpoch(json['createdAt'] as int),
    );
  }

  // MoodEntry'yi JSON'a çevir
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'mood': mood,
      'emoji': emoji,
      'journalPrompt1': journalPrompt1,
      'journalPrompt2': journalPrompt2,
      'date': date.millisecondsSinceEpoch,
      'createdAt': createdAt.millisecondsSinceEpoch,
    };
  }

  // MoodEntry kopyala
  MoodEntry copyWith({
    String? id,
    String? mood,
    String? emoji,
    String? journalPrompt1,
    String? journalPrompt2,
    DateTime? date,
    DateTime? createdAt,
  }) {
    return MoodEntry(
      id: id ?? this.id,
      mood: mood ?? this.mood,
      emoji: emoji ?? this.emoji,
      journalPrompt1: journalPrompt1 ?? this.journalPrompt1,
      journalPrompt2: journalPrompt2 ?? this.journalPrompt2,
      date: date ?? this.date,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
