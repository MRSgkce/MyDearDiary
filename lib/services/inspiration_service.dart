import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class InspirationEntry {
  final String id;
  final String text;
  final DateTime dateCreated;
  final String? author;

  InspirationEntry({
    required this.id,
    required this.text,
    required this.dateCreated,
    this.author,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'text': text,
      'dateCreated': dateCreated.toIso8601String(),
      'author': author,
    };
  }

  factory InspirationEntry.fromJson(Map<String, dynamic> json) {
    return InspirationEntry(
      id: json['id'],
      text: json['text'],
      dateCreated: DateTime.parse(json['dateCreated']),
      author: json['author'],
    );
  }
}

class InspirationService {
  static const String _inspirationKey = 'saved_inspirations';

  // İlham kaydet
  static Future<void> saveInspiration(String text, {String? author}) async {
    final prefs = await SharedPreferences.getInstance();
    final existingInspirations = await getInspirations();

    final newInspiration = InspirationEntry(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      text: text,
      dateCreated: DateTime.now(),
      author: author,
    );

    existingInspirations.add(newInspiration);

    final inspirationsJson = existingInspirations
        .map((inspiration) => inspiration.toJson())
        .toList();

    await prefs.setString(_inspirationKey, jsonEncode(inspirationsJson));
  }

  // İlhamları getir
  static Future<List<InspirationEntry>> getInspirations() async {
    final prefs = await SharedPreferences.getInstance();
    final inspirationsString = prefs.getString(_inspirationKey);

    if (inspirationsString == null) return [];

    final List<dynamic> inspirationsJson = jsonDecode(inspirationsString);
    return inspirationsJson
        .map((json) => InspirationEntry.fromJson(json))
        .toList();
  }

  // İlham sil
  static Future<void> deleteInspiration(String id) async {
    final prefs = await SharedPreferences.getInstance();
    final existingInspirations = await getInspirations();

    existingInspirations.removeWhere((inspiration) => inspiration.id == id);

    final inspirationsJson = existingInspirations
        .map((inspiration) => inspiration.toJson())
        .toList();

    await prefs.setString(_inspirationKey, jsonEncode(inspirationsJson));
  }

  // İlham güncelle
  static Future<void> updateInspiration(
    String id,
    String text, {
    String? author,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final existingInspirations = await getInspirations();

    final index = existingInspirations.indexWhere(
      (inspiration) => inspiration.id == id,
    );
    if (index != -1) {
      existingInspirations[index] = InspirationEntry(
        id: id,
        text: text,
        dateCreated: existingInspirations[index].dateCreated,
        author: author,
      );

      final inspirationsJson = existingInspirations
          .map((inspiration) => inspiration.toJson())
          .toList();

      await prefs.setString(_inspirationKey, jsonEncode(inspirationsJson));
    }
  }
}
