class DiaryEntry {
  final String id;
  final String title;
  final String content;
  final DateTime date;
  final String? mood;

  DiaryEntry({
    required this.id,
    required this.title,
    required this.content,
    required this.date,
    this.mood,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'date': date.millisecondsSinceEpoch,
      'mood': mood,
    };
  }

  factory DiaryEntry.fromJson(Map<String, dynamic> json) {
    return DiaryEntry(
      id: json['id'],
      title: json['title'],
      content: json['content'],
      date: DateTime.fromMillisecondsSinceEpoch(json['date']),
      mood: json['mood'],
    );
  }

  DiaryEntry copyWith({
    String? id,
    String? title,
    String? content,
    DateTime? date,
    String? mood,
  }) {
    return DiaryEntry(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      date: date ?? this.date,
      mood: mood ?? this.mood,
    );
  }
}
