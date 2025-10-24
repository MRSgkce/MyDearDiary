import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class InspirationService {
  static const String _inspirationsKey = 'inspiration_quotes';
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static const String _collectionName = 'inspirations';

  // Firebase'e ilham sözü ekle
  static Future<void> addInspirationToFirebase(
    Map<String, dynamic> inspiration,
  ) async {
    try {
      final inspirationData = {
        'text': inspiration['text'],
        'author': inspiration['author'],
        'likes': 0,
        'shares': 0,
        'category': inspiration['category'] ?? 'Genel',
        'tags': inspiration['tags'] ?? [],
        'imageUrl': inspiration['imageUrl'],
        'isFavorite': false,
        'createdAt': Timestamp.now(),
        'updatedAt': Timestamp.now(),
      };

      await _firestore.collection(_collectionName).add(inspirationData);
      print('✅ İlham sözü Firebase\'e başarıyla kaydedildi');
    } catch (e) {
      print('❌ Firebase\'e ilham kayıt hatası: $e');
      rethrow;
    }
  }

  // Firebase'den tüm ilham sözlerini getir
  static Future<List<Map<String, dynamic>>>
  getAllInspirationsFromFirebase() async {
    try {
      print('🔥 Firebase\'den veri çekiliyor...');
      print('📋 Collection ismi: $_collectionName');

      // Önce basit sorgu dene
      final QuerySnapshot snapshot = await _firestore
          .collection(_collectionName)
          .get();

      print('📊 Firebase\'den ${snapshot.docs.length} document geldi');

      if (snapshot.docs.isEmpty) {
        print('⚠️ Collection boş! Firebase Console\'da kontrol edin');
        return [];
      }

      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return {
          'id': doc.id,
          'text': data['text'],
          'author': data['author'],
          'likes': data['likes'] ?? 0,
          'shares': data['shares'] ?? 0,
          'category': data['category'] ?? 'Genel',
          'tags':
              (data['tags'] as List<dynamic>?)
                  ?.map((e) => e.toString())
                  .toList() ??
              [],
          'imageUrl': data['imageUrl'],
          'isFavorite': data['isFavorite'] ?? false,
          'createdAt': data['createdAt']?.millisecondsSinceEpoch,
          'updatedAt': data['updatedAt']?.millisecondsSinceEpoch,
        };
      }).toList();
    } catch (e) {
      print('Firebase\'den ilham sözleri getirilirken hata: $e');
      return [];
    }
  }

  // İlham sözü beğenme (Firebase)
  static Future<void> likeInspiration(String id) async {
    try {
      await _firestore.collection(_collectionName).doc(id).update({
        'likes': FieldValue.increment(1),
        'updatedAt': Timestamp.now(),
      });
      print('✅ İlham beğenildi: $id');
    } catch (e) {
      print('❌ Beğeni hatası: $e');
      rethrow;
    }
  }

  // İlham sözü silme (Firebase)
  static Future<void> deleteInspiration(String id) async {
    try {
      await _firestore.collection(_collectionName).doc(id).delete();
      print('İlham sözü Firebase\'den silindi');
    } catch (e) {
      print('Silme hatası: $e');
      rethrow;
    }
  }

  // Local storage'dan tüm ilham sözlerini getir
  static Future<List<Map<String, dynamic>>>
  getAllInspirationsFromLocal() async {
    final prefs = await SharedPreferences.getInstance();
    final String? inspirationsJson = prefs.getString(_inspirationsKey);

    if (inspirationsJson == null) {
      return [];
    }

    final List<dynamic> inspirationsList = json.decode(inspirationsJson);
    return inspirationsList
        .map((json) => Map<String, dynamic>.from(json))
        .toList();
  }

  // Local storage'a ilham sözlerini kaydet
  static Future<void> saveInspirationsToLocal(
    List<Map<String, dynamic>> inspirations,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    final inspirationsJson = json.encode(inspirations);
    await prefs.setString(_inspirationsKey, inspirationsJson);
  }

  // Sadece Firebase kullan
  static Future<List<Map<String, dynamic>>> getAllInspirations() async {
    try {
      final firebaseInspirations = await getAllInspirationsFromFirebase();
      return firebaseInspirations;
    } catch (e) {
      print('Firebase bağlantı hatası: $e');
      return [];
    }
  }

  // Sadece Firebase kullan
  static Future<void> addInspiration(Map<String, dynamic> inspiration) async {
    print('🔥 Service addInspiration başladı');
    try {
      print('📤 Firebase\'e gönderiliyor...');
      await addInspirationToFirebase(inspiration);
      print('✅ İlham sözü Firebase\'e başarıyla kaydedildi');
    } catch (e) {
      print('❌ Firebase kayıt hatası: $e');
      rethrow;
    }
  }

  // Provider için uyumlu metodlar
  static Future<List<Map<String, dynamic>>> getInspirations() async {
    return await getAllInspirations();
  }

  static Future<void> saveInspiration(String text, {String? author}) async {
    final inspiration = {'text': text, 'author': author, 'likes': 0};
    await addInspiration(inspiration);
  }

  static Future<void> updateInspiration(
    String id,
    String text, {
    String? author,
  }) async {
    try {
      await _firestore.collection(_collectionName).doc(id).update({
        'text': text,
        'author': author,
        'updatedAt': Timestamp.now(),
      });
      print('İlham sözü güncellendi');
    } catch (e) {
      print('Güncelleme hatası: $e');
      rethrow;
    }
  }

  // Paylaşım işlemi
  static Future<void> shareInspiration(String id) async {
    try {
      await _firestore.collection(_collectionName).doc(id).update({
        'shares': FieldValue.increment(1),
        'updatedAt': Timestamp.now(),
      });
      print('✅ İlham paylaşıldı: $id');
    } catch (e) {
      print('❌ Paylaşım hatası: $e');
      rethrow;
    }
  }

  // Favori işlemi
  static Future<void> toggleFavorite(String id) async {
    try {
      final doc = await _firestore.collection(_collectionName).doc(id).get();
      if (doc.exists) {
        final currentFavorite = doc.data()?['isFavorite'] ?? false;
        await _firestore.collection(_collectionName).doc(id).update({
          'isFavorite': !currentFavorite,
          'updatedAt': Timestamp.now(),
        });
        print('✅ Favori durumu değiştirildi: $id');
      }
    } catch (e) {
      print('❌ Favori hatası: $e');
      rethrow;
    }
  }
}
