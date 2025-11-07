import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/meditation_entry.dart';

class MeditationService {
  static const String _meditationsKey = 'meditation_entries';
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static const String _collectionName = 'meditation_entries';

  // Varsayılan meditasyon verileri
  static List<MeditationEntry> getDefaultMeditations() {
    return [
      MeditationEntry(
        id: '1',
        title: 'Rahatlatıcı Uyku Meditasyonu',
        category: 'Uyku',
        duration: 15,
        listens: 2400,
        icon: '🌙',
        gradientColors: [0xFF6B73FF, 0xFF8B9AFF],
        progress: 0.0,
        createdAt: DateTime.now(),
      ),
      MeditationEntry(
        id: '2',
        title: 'Sabah Enerjisi',
        category: 'Odak',
        duration: 10,
        listens: 1800,
        icon: '☀️',
        gradientColors: [0xFFFF8A65, 0xFFFFB6C1],
        progress: 0.0,
        createdAt: DateTime.now(),
      ),
      MeditationEntry(
        id: '3',
        title: 'Gece Huzuru',
        category: 'Uyku',
        duration: 25,
        listens: 4200,
        icon: '✨',
        gradientColors: [0xFF9C27B0, 0xFFBA68C8],
        progress: 0.0,
        createdAt: DateTime.now(),
      ),
      MeditationEntry(
        id: '4',
        title: 'Anksiyete Çözücü',
        category: 'Stres',
        duration: 18,
        listens: 2700,
        icon: '🌸',
        gradientColors: [0xFFFF6B9D, 0xFFFF8E9B],
        progress: 0.0,
        createdAt: DateTime.now(),
      ),
      MeditationEntry(
        id: '5',
        title: '4-7-8 Nefes Tekniği',
        category: 'Nefes',
        duration: 5,
        listens: 5300,
        icon: '💨',
        gradientColors: [0xFF42A5F5, 0xFF64B5F6],
        progress: 0.0,
        createdAt: DateTime.now(),
      ),
      MeditationEntry(
        id: '6',
        title: 'Odaklanma ve Konsantrasyon',
        category: 'Odak',
        duration: 20,
        listens: 1500,
        icon: '🎯',
        gradientColors: [0xFF4CAF50, 0xFF66BB6A],
        progress: 0.0,
        createdAt: DateTime.now(),
      ),
    ];
  }

  // Firebase'den tüm meditasyonları getir
  static Future<List<MeditationEntry>> getAllMeditationsFromFirebase() async {
    try {
      final QuerySnapshot snapshot = await _firestore
          .collection(_collectionName)
          .orderBy('createdAt', descending: true)
          .get();

      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id; // Firebase document ID'sini ekle
        return MeditationEntry.fromJson(data);
      }).toList();
    } catch (e) {
      print('Firebase\'den meditasyonlar getirilirken hata: $e');
      return [];
    }
  }

  // Tüm meditasyonları getir (local fallback ile)
  static Future<List<MeditationEntry>> getAllMeditations() async {
    try {
      // Önce Firebase'den dene
      final firebaseMeditations = await getAllMeditationsFromFirebase();
      if (firebaseMeditations.isNotEmpty) {
        return firebaseMeditations;
      }
    } catch (e) {
      print('Firebase bağlantı hatası, local storage kullanılıyor: $e');
    }

    // Firebase başarısız olursa local storage'dan al
    final prefs = await SharedPreferences.getInstance();
    final String? meditationsJson = prefs.getString(_meditationsKey);

    if (meditationsJson == null) {
      // Varsayılan meditasyonları döndür
      return getDefaultMeditations();
    }

    final List<dynamic> meditationsList = json.decode(meditationsJson);
    final meditations = meditationsList
        .map((json) => MeditationEntry.fromJson(json))
        .toList();

    // Eğer local storage boşsa varsayılan verileri ekle
    if (meditations.isEmpty) {
      final defaultMeditations = getDefaultMeditations();
      await _saveMeditations(defaultMeditations);
      return defaultMeditations;
    }

    return meditations;
  }

  // Kategoriye göre meditasyonları getir
  static Future<List<MeditationEntry>> getMeditationsByCategory(
      String category) async {
    final allMeditations = await getAllMeditations();
    if (category == 'Tümü') {
      return allMeditations;
    }
    return allMeditations.where((m) => m.category == category).toList();
  }

  // Meditasyonları kaydet
  static Future<void> _saveMeditations(List<MeditationEntry> meditations) async {
    final prefs = await SharedPreferences.getInstance();
    final meditationsJson =
        json.encode(meditations.map((m) => m.toJson()).toList());
    await prefs.setString(_meditationsKey, meditationsJson);
  }

  // Firebase'e meditasyon ekle
  static Future<void> addMeditationToFirebase(
      MeditationEntry meditation) async {
    try {
      final meditationData = meditation.toJson();
      meditationData['createdAt'] = Timestamp.fromDate(meditation.createdAt);

      await _firestore.collection(_collectionName).add(meditationData);
      print('Meditasyon Firebase\'e başarıyla eklendi');
    } catch (e) {
      print('Firebase\'e meditasyon ekleme hatası: $e');
      rethrow;
    }
  }

  // ID oluştur
  static String generateId() {
    return DateTime.now().millisecondsSinceEpoch.toString();
  }
}

