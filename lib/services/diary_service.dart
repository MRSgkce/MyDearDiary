import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/diary_entry.dart';

class DiaryService {
  static const String _entriesKey = 'diary_entries';
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static const String _collectionName = 'diary_entries';

  // Firebase'den tüm girişleri getir
  static Future<List<DiaryEntry>> getAllEntriesFromFirebase() async {
    try {
      final QuerySnapshot snapshot = await _firestore
          .collection(_collectionName)
          .orderBy('createdAt', descending: true)
          .get();
      
      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return DiaryEntry.fromJson(data);
      }).toList();
    } catch (e) {
      print('Firebase\'den girişler getirilirken hata: $e');
      return [];
    }
  }

  // Tüm girişleri getir (local fallback ile)
  static Future<List<DiaryEntry>> getAllEntries() async {
    try {
      // Önce Firebase'den dene
      final firebaseEntries = await getAllEntriesFromFirebase();
      if (firebaseEntries.isNotEmpty) {
        return firebaseEntries;
      }
    } catch (e) {
      print('Firebase bağlantı hatası, local storage kullanılıyor: $e');
    }
    
    // Firebase başarısız olursa local storage'dan al
    final prefs = await SharedPreferences.getInstance();
    final String? entriesJson = prefs.getString(_entriesKey);

    if (entriesJson == null) {
      return [];
    }

    final List<dynamic> entriesList = json.decode(entriesJson);
    return entriesList.map((json) => DiaryEntry.fromJson(json)).toList();
  }

  // Firebase'e giriş ekle
  static Future<void> addEntryToFirebase(DiaryEntry entry) async {
    try {
      final entryData = entry.toJson();
      entryData['createdAt'] = Timestamp.now();
      entryData['updatedAt'] = Timestamp.now();
      
      await _firestore.collection(_collectionName).add(entryData);
      print('Giriş Firebase\'e başarıyla kaydedildi');
    } catch (e) {
      print('Firebase\'e kayıt hatası: $e');
      rethrow;
    }
  }

  // Giriş ekle (Firebase + Local)
  static Future<void> addEntry(DiaryEntry entry) async {
    try {
      // Firebase'e kaydet
      await addEntryToFirebase(entry);
    } catch (e) {
      print('Firebase kayıt başarısız, local storage kullanılıyor: $e');
    }
    
    // Local storage'a da kaydet (backup için)
    final entries = await getAllEntries();
    entries.add(entry);
    await _saveEntries(entries);
  }

  // Giriş güncelle
  static Future<void> updateEntry(DiaryEntry entry) async {
    final entries = await getAllEntries();
    final index = entries.indexWhere((e) => e.id == entry.id);
    if (index != -1) {
      entries[index] = entry;
      await _saveEntries(entries);
    }
  }

  // Giriş sil
  static Future<void> deleteEntry(String id) async {
    final entries = await getAllEntries();
    entries.removeWhere((entry) => entry.id == id);
    await _saveEntries(entries);
  }

  // Girişleri kaydet
  static Future<void> _saveEntries(List<DiaryEntry> entries) async {
    final prefs = await SharedPreferences.getInstance();
    final entriesJson = json.encode(entries.map((e) => e.toJson()).toList());
    await prefs.setString(_entriesKey, entriesJson);
  }

  // ID oluştur
  static String generateId() {
    return DateTime.now().millisecondsSinceEpoch.toString();
  }
}
