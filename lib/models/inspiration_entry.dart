class InspirationEntry {
  final String id;
  final String text;
  final String? author;
  final int likes;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  InspirationEntry({
    required this.id,
    required this.text,
    this.author,
    this.likes = 0,
    this.createdAt,
    this.updatedAt,
  });

  // JSON'dan InspirationEntry oluştur
  factory InspirationEntry.fromJson(Map<String, dynamic> json) {
    return InspirationEntry(
      id:
          json['id'] as String? ??
          DateTime.now().millisecondsSinceEpoch.toString(),
      text: json['text'] as String,
      author: json['author'] as String?,
      likes: json['likes'] as int? ?? 0,
      createdAt: json['createdAt'] != null
          ? DateTime.fromMillisecondsSinceEpoch(json['createdAt'] as int)
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.fromMillisecondsSinceEpoch(json['updatedAt'] as int)
          : null,
    );
  }

  // InspirationEntry'yi JSON'a çevir
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'text': text,
      'author': author,
      'likes': likes,
      'createdAt': createdAt?.millisecondsSinceEpoch,
      'updatedAt': updatedAt?.millisecondsSinceEpoch,
    };
  }

  // InspirationEntry kopyala
  InspirationEntry copyWith({
    String? id,
    String? text,
    String? author,
    int? likes,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return InspirationEntry(
      id: id ?? this.id,
      text: text ?? this.text,
      author: author ?? this.author,
      likes: likes ?? this.likes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
