class InspirationEntry {
  final String id;
  final String text;
  final String? author;
  final int likes;
  final int shares;
  final String category;
  final List<String> tags;
  final String? imageUrl;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final bool isFavorite;

  InspirationEntry({
    required this.id,
    required this.text,
    this.author,
    this.likes = 0,
    this.shares = 0,
    this.category = 'Genel',
    this.tags = const [],
    this.imageUrl,
    this.createdAt,
    this.updatedAt,
    this.isFavorite = false,
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
      shares: json['shares'] as int? ?? 0,
      category: json['category'] as String? ?? 'Genel',
      tags:
          (json['tags'] as List<dynamic>?)?.map((e) => e.toString()).toList() ??
          [],
      imageUrl: json['imageUrl'] as String?,
      createdAt: json['createdAt'] != null
          ? DateTime.fromMillisecondsSinceEpoch(json['createdAt'] as int)
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.fromMillisecondsSinceEpoch(json['updatedAt'] as int)
          : null,
      isFavorite: json['isFavorite'] as bool? ?? false,
    );
  }

  // InspirationEntry'yi JSON'a çevir
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'text': text,
      'author': author,
      'likes': likes,
      'shares': shares,
      'category': category,
      'tags': tags,
      'imageUrl': imageUrl,
      'createdAt': createdAt?.millisecondsSinceEpoch,
      'updatedAt': updatedAt?.millisecondsSinceEpoch,
      'isFavorite': isFavorite,
    };
  }

  // InspirationEntry kopyala
  InspirationEntry copyWith({
    String? id,
    String? text,
    String? author,
    int? likes,
    int? shares,
    String? category,
    List<String>? tags,
    String? imageUrl,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isFavorite,
  }) {
    return InspirationEntry(
      id: id ?? this.id,
      text: text ?? this.text,
      author: author ?? this.author,
      likes: likes ?? this.likes,
      shares: shares ?? this.shares,
      category: category ?? this.category,
      tags: tags ?? this.tags,
      imageUrl: imageUrl ?? this.imageUrl,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }
}
