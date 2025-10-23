import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class InspirationService {
  static const String _inspirationsKey = 'inspiration_quotes';
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static const String _collectionName = 'inspiration_quotes';

  // Firebase'e ilham sözü ekle
  static Future<void> addInspirationToFirebase(Map<String, dynamic> inspiration) async {
    try {
      final inspirationData = {
        'text': inspiration['text'],
        'author': inspiration['author'],
        'likes': 0,
        'createdAt': Timestamp.now(),
        'updatedAt': Timestamp.now(),
      };
      
      await _firestore.collection(_collectionName).add(inspirationData);
      print('İlham sözü Firebase\'e başarıyla kaydedildi');
    } catch (e) {
      print('Firebase\'e ilham kayıt hatası: $e');
      rethrow;
    }
  }

  // Firebase'den tüm ilham sözlerini getir
  static Future<List<Map<String, dynamic>>> getAllInspirationsFromFirebase() async {
    try {
      final QuerySnapshot snapshot = await _firestore
          .collection(_collectionName)
          .orderBy('createdAt', descending: true)
          .get();
      
      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return {
          'id': doc.id,
          'text': data['text'],
          'author': data['author'],
          'likes': data['likes'] ?? 0,
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
      print('İlham sözü beğenildi');
    } catch (e) {
      print('Beğenme hatası: $e');
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
  static Future<List<Map<String, dynamic>>> getAllInspirationsFromLocal() async {
    final prefs = await SharedPreferences.getInstance();
    final String? inspirationsJson = prefs.getString(_inspirationsKey);

    if (inspirationsJson == null) {
      return [];
    }

    final List<dynamic> inspirationsList = json.decode(inspirationsJson);
    return inspirationsList.map((json) => Map<String, dynamic>.from(json)).toList();
  }

  // Local storage'a ilham sözlerini kaydet
  static Future<void> saveInspirationsToLocal(List<Map<String, dynamic>> inspirations) async {
    final prefs = await SharedPreferences.getInstance();
    final inspirationsJson = json.encode(inspirations);
    await prefs.setString(_inspirationsKey, inspirationsJson);
  }

  // Hibrit sistem - önce Firebase'den dene, sonra local
  static Future<List<Map<String, dynamic>>> getAllInspirations() async {
    try {
      final firebaseInspirations = await getAllInspirationsFromFirebase();
      if (firebaseInspirations.isNotEmpty) {
        return firebaseInspirations;
      }
    } catch (e) {
      print('Firebase bağlantı hatası, local storage kullanılıyor: $e');
    }
    
    return await getAllInspirationsFromLocal();
  }

  // Hibrit sistem - Firebase + Local
  static Future<void> addInspiration(Map<String, dynamic> inspiration) async {
    try {
      await addInspirationToFirebase(inspiration);
    } catch (e) {
      print('Firebase kayıt başarısız, local storage kullanılıyor: $e');
    }
    
    // Local storage'a da kaydet
    final inspirations = await getAllInspirationsFromLocal();
    inspirations.add(inspiration);
    await saveInspirationsToLocal(inspirations);
  }
}