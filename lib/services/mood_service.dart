import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/mood_entry.dart';

class MoodService {
  static const String _moodsKey = 'mood_entries';
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static const String _collectionName = 'mood_entries';
  
  // Mevcut kullanıcı ID'sini al
  static String? get _currentUserId => FirebaseAuth.instance.currentUser?.uid;

  // Firebase'e mood kaydet
  static Future<void> saveMoodToFirebase(MoodEntry moodEntry) async {
    try {
      final userId = _currentUserId;
      if (userId == null) {
        throw Exception('Kullanıcı giriş yapmamış');
      }

      final moodData = moodEntry.toJson();
      // Firebase için Timestamp kullan
      moodData['createdAt'] = Timestamp.fromDate(moodEntry.createdAt);
      moodData['date'] = Timestamp.fromDate(moodEntry.date);
      moodData['userId'] = userId; // Kullanıcı ID'si eklendi

      await _firestore.collection(_collectionName).add(moodData);
      print('✅ Mood Firebase\'e başarıyla kaydedildi (userId: $userId)');
    } catch (e) {
      print('❌ Firebase\'e mood kayıt hatası: $e');
      rethrow;
    }
  }

  // Mood kaydet (Firebase + Local)
  static Future<void> saveMood(MoodEntry moodEntry) async {
    try {
      // Firebase'e kaydet
      await saveMoodToFirebase(moodEntry);
    } catch (e) {
      print('Firebase mood kayıt başarısız, local storage kullanılıyor: $e');
    }

    // Local storage'a da kaydet (backup için)
    // userId'yi moodEntry'ye ekle (local storage için)
    final userId = _currentUserId;
    final moodData = moodEntry.toJson();
    if (userId != null) {
      moodData['userId'] = userId;
    }
    
    final prefs = await SharedPreferences.getInstance();
    final String? moodsJson = prefs.getString(_moodsKey);
    final List<dynamic> moodsList = moodsJson != null 
        ? json.decode(moodsJson) 
        : [];
    
    moodsList.add(moodData);
    await prefs.setString(_moodsKey, json.encode(moodsList));
  }

  // Firebase'den kullanıcıya özel mood'ları getir
  static Future<List<MoodEntry>> getAllMoodsFromFirebase() async {
    try {
      final userId = _currentUserId;
      if (userId == null) {
        print('⚠️ Kullanıcı giriş yapmamış, boş liste döndürülüyor');
        return [];
      }

      print('🔍 Firebase\'den mood\'lar çekiliyor...');
      print('👤 Kullanıcı ID: $userId');

      // Kullanıcı ID'sine göre filtrele ve tarihe göre sırala (Firebase index kullanılıyor)
      final QuerySnapshot snapshot = await _firestore
          .collection(_collectionName)
          .where('userId', isEqualTo: userId)
          .orderBy('createdAt', descending: true)
          .get();

      print('📊 Firebase\'den ${snapshot.docs.length} mood geldi');

      if (snapshot.docs.isEmpty) {
        print('⚠️ Bu kullanıcı için mood kaydı bulunamadı');
        return [];
      }

      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        print('📦 Mood data: $data');
        final mood = MoodEntry.fromJson(data);
        print('✅ Mood oluşturuldu: ${mood.mood}');
        return mood;
      }).toList();
    } catch (e) {
      print('❌ Firebase\'den mood\'lar getirilirken hata: $e');
      return [];
    }
  }

  // Tüm mood'ları getir (local fallback ile)
  static Future<List<MoodEntry>> getAllMoods() async {
    try {
      // Önce Firebase'den dene
      final firebaseMoods = await getAllMoodsFromFirebase();
      if (firebaseMoods.isNotEmpty) {
        return firebaseMoods;
      }
    } catch (e) {
      print('Firebase bağlantı hatası, local storage kullanılıyor: $e');
    }

    // Firebase başarısız olursa local storage'dan al
    final userId = _currentUserId;
    if (userId == null) {
      print('⚠️ Kullanıcı giriş yapmamış, local storage\'dan veri alınamıyor');
      return [];
    }

    final prefs = await SharedPreferences.getInstance();
    final String? moodsJson = prefs.getString(_moodsKey);

    if (moodsJson == null) {
      return [];
    }

    final List<dynamic> moodsList = json.decode(moodsJson);
    final allMoods = moodsList.map((json) => MoodEntry.fromJson(json)).toList();
    
    // Local storage'dan da kullanıcıya özel filtrele (userId field'ı varsa)
    // Not: Eski kayıtlarda userId olmayabilir, bu durumda tüm kayıtları döndür
    return allMoods.where((mood) {
      // Eğer mood'un JSON'ında userId varsa filtrele, yoksa eski kayıt olduğu için göster
      final moodJson = mood.toJson();
      return moodJson['userId'] == null || moodJson['userId'] == userId;
    }).toList();
  }

  // ID oluştur
  static String generateId() {
    return DateTime.now().millisecondsSinceEpoch.toString();
  }

  // Bugünkü mood'u getir
  static Future<MoodEntry?> getTodaysMood() async {
    final moods = await getAllMoods();
    final today = DateTime.now();

    for (final mood in moods) {
      if (mood.date.year == today.year &&
          mood.date.month == today.month &&
          mood.date.day == today.day) {
        return mood;
      }
    }
    return null;
  }

  // Son 4 haftalık (30 gün) mood'ları getir
  static Future<List<MoodEntry>> getLast30DaysMoods() async {
    try {
      final userId = _currentUserId;
      if (userId == null) {
        return [];
      }

      final now = DateTime.now();
      final thirtyDaysAgo = now.subtract(const Duration(days: 30));

      // Firebase'den son 30 günlük kayıtları getir
      final QuerySnapshot snapshot = await _firestore
          .collection(_collectionName)
          .where('userId', isEqualTo: userId)
          .where('createdAt', isGreaterThanOrEqualTo: Timestamp.fromDate(thirtyDaysAgo))
          .orderBy('createdAt', descending: true)
          .get();

      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return MoodEntry.fromJson(data);
      }).toList();
    } catch (e) {
      print('❌ Son 30 günlük mood\'lar getirilirken hata: $e');
      // Fallback: Tüm kayıtları getir ve client-side'da filtrele
      final allMoods = await getAllMoods();
      final now = DateTime.now();
      final thirtyDaysAgo = now.subtract(const Duration(days: 30));
      
      return allMoods.where((mood) {
        return mood.createdAt.isAfter(thirtyDaysAgo);
      }).toList();
    }
  }

  // 30 günden eski kayıtları Firebase'den sil
  static Future<void> deleteOldMoods() async {
    try {
      final userId = _currentUserId;
      if (userId == null) {
        print('⚠️ Kullanıcı giriş yapmamış, eski kayıtlar silinemiyor');
        return;
      }

      final now = DateTime.now();
      final thirtyDaysAgo = now.subtract(const Duration(days: 30));

      print('🗑️ 30 günden eski kayıtlar siliniyor...');

      // Tüm kullanıcı kayıtlarını getir (index gerektirmeyen sorgu)
      final QuerySnapshot allSnapshot = await _firestore
          .collection(_collectionName)
          .where('userId', isEqualTo: userId)
          .orderBy('createdAt', descending: true)
          .get();

      // Client-side'da 30 günden eski olanları filtrele
      final oldDocs = allSnapshot.docs.where((doc) {
        final data = doc.data() as Map<String, dynamic>;
        final createdAt = data['createdAt'] as Timestamp?;
        if (createdAt == null) return false;
        return createdAt.toDate().isBefore(thirtyDaysAgo);
      }).toList();

      if (oldDocs.isEmpty) {
        print('✅ Silinecek eski kayıt yok');
        return;
      }

      // Tüm eski kayıtları sil
      final batch = _firestore.batch();
      for (var doc in oldDocs) {
        batch.delete(doc.reference);
      }
      await batch.commit();

      print('✅ ${oldDocs.length} adet eski kayıt silindi');
    } catch (e) {
      print('❌ Eski kayıtlar silinirken hata: $e');
      // Index hatası olabilir, sessizce devam et
    }
  }
}
