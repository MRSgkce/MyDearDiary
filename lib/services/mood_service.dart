import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/mood_entry.dart';

class MoodService {
  static const String _moodsKey = 'mood_entries';
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static const String _collectionName = 'mood_entries';

  // Firebase'e mood kaydet
  static Future<void> saveMoodToFirebase(MoodEntry moodEntry) async {
    try {
      final moodData = moodEntry.toJson();
      // Firebase için Timestamp kullan
      moodData['createdAt'] = Timestamp.fromDate(moodEntry.createdAt);
      moodData['date'] = Timestamp.fromDate(moodEntry.date);

      await _firestore.collection(_collectionName).add(moodData);
      print('Mood Firebase\'e başarıyla kaydedildi');
    } catch (e) {
      print('Firebase\'e mood kayıt hatası: $e');
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
    final moods = await getAllMoods();
    moods.add(moodEntry);
    await _saveMoods(moods);
  }

  // Firebase'den tüm mood'ları getir
  static Future<List<MoodEntry>> getAllMoodsFromFirebase() async {
    try {
      print('🔍 Firebase\'den mood\'lar çekiliyor...');
      final QuerySnapshot snapshot = await _firestore
          .collection(_collectionName)
          .orderBy('createdAt', descending: true)
          .get();

      print('📊 Firebase\'den ${snapshot.docs.length} mood geldi');

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
    final prefs = await SharedPreferences.getInstance();
    final String? moodsJson = prefs.getString(_moodsKey);

    if (moodsJson == null) {
      return [];
    }

    final List<dynamic> moodsList = json.decode(moodsJson);
    return moodsList.map((json) => MoodEntry.fromJson(json)).toList();
  }

  // Mood'ları kaydet
  static Future<void> _saveMoods(List<MoodEntry> moods) async {
    final prefs = await SharedPreferences.getInstance();
    final moodsJson = json.encode(moods.map((m) => m.toJson()).toList());
    await prefs.setString(_moodsKey, moodsJson);
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
}
