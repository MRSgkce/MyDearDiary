import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // İlham kaydet (Firebase + Local backup)
  static Future<void> saveInspiration(String text, {String? author}) async {
    final newInspiration = InspirationEntry(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      text: text,
      dateCreated: DateTime.now(),
      author: author,
    );

    // Firebase'e kaydet (Authentication olmadan)
    try {
      print('🔥 Firebase\'e kaydediliyor: ${newInspiration.text}');
      await _firestore
          .collection('inspirations')
          .doc(newInspiration.id)
          .set(newInspiration.toJson());
      print('✅ Firebase\'e başarıyla kaydedildi!');
    } catch (e) {
      print('❌ Firebase kaydetme hatası: $e');
      // Hata durumunda local'e kaydet
      await _saveToLocal(newInspiration);
    }
    
    // Her durumda local'e de kaydet (yedek olarak)
    await _saveToLocal(newInspiration);
  }

  // Local'e kaydet (yedek olarak)
  static Future<void> _saveToLocal(InspirationEntry inspiration) async {
    final prefs = await SharedPreferences.getInstance();
    final existingInspirations = await getInspirations();
    existingInspirations.add(inspiration);

    final inspirationsJson = existingInspirations
        .map((insp) => insp.toJson())
        .toList();

    await prefs.setString(_inspirationKey, jsonEncode(inspirationsJson));
  }

  // İlhamları getir (Firebase + Local backup)
  static Future<List<InspirationEntry>> getInspirations() async {
    // Firebase'den getir (Authentication olmadan)
    try {
      final snapshot = await _firestore
          .collection('inspirations')
          .orderBy('dateCreated', descending: true)
          .get();

      if (snapshot.docs.isNotEmpty) {
        print('✅ Firebase\'den ${snapshot.docs.length} ilham getirildi');
        return snapshot.docs
            .map((doc) => InspirationEntry.fromJson(doc.data()))
            .toList();
      }
    } catch (e) {
      print('❌ Firebase okuma hatası: $e');
      // Hata durumunda local'den getir
    }

    // Firebase'de veri yoksa veya hata varsa local'den getir
    print('📱 Local\'den ilhamlar getiriliyor');
    return await _getFromLocal();
  }

  // Local'den getir (yedek olarak)
  static Future<List<InspirationEntry>> _getFromLocal() async {
    final prefs = await SharedPreferences.getInstance();
    final inspirationsString = prefs.getString(_inspirationKey);

    if (inspirationsString == null) return [];

    final List<dynamic> inspirationsJson = jsonDecode(inspirationsString);
    return inspirationsJson
        .map((json) => InspirationEntry.fromJson(json))
        .toList();
  }

  // İlham sil (Firebase + Local)
  static Future<void> deleteInspiration(String id) async {
    // Firebase'den sil (Authentication olmadan)
    try {
      await _firestore
          .collection('inspirations')
          .doc(id)
          .delete();
      print('✅ Firebase\'den silindi: $id');
    } catch (e) {
      print('❌ Firebase silme hatası: $e');
    }

    // Local'den de sil
    await _deleteFromLocal(id);
  }

  // Local'den sil
  static Future<void> _deleteFromLocal(String id) async {
    final prefs = await SharedPreferences.getInstance();
    final existingInspirations = await _getFromLocal();

    existingInspirations.removeWhere((inspiration) => inspiration.id == id);

    final inspirationsJson = existingInspirations
        .map((inspiration) => inspiration.toJson())
        .toList();

    await prefs.setString(_inspirationKey, jsonEncode(inspirationsJson));
  }

  // İlham güncelle (Firebase + Local)
  static Future<void> updateInspiration(
    String id,
    String text, {
    String? author,
  }) async {
    // Firebase'de güncelle (Authentication olmadan)
    try {
      await _firestore
          .collection('inspirations')
          .doc(id)
          .update({
        'text': text,
        'author': author,
      });
      print('✅ Firebase\'de güncellendi: $id');
    } catch (e) {
      print('❌ Firebase güncelleme hatası: $e');
    }

    // Local'de de güncelle
    await _updateLocal(id, text, author: author);
  }

  // Local'de güncelle
  static Future<void> _updateLocal(String id, String text, {String? author}) async {
    final prefs = await SharedPreferences.getInstance();
    final existingInspirations = await _getFromLocal();

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
