import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/diary_entry.dart';

class DiaryService {
  static const String _entriesKey = 'diary_entries';

  // Tüm girişleri getir
  static Future<List<DiaryEntry>> getAllEntries() async {
    final prefs = await SharedPreferences.getInstance();
    final String? entriesJson = prefs.getString(_entriesKey);

    if (entriesJson == null) {
      return [];
    }

    final List<dynamic> entriesList = json.decode(entriesJson);
    return entriesList.map((json) => DiaryEntry.fromJson(json)).toList();
  }

  // Giriş ekle
  static Future<void> addEntry(DiaryEntry entry) async {
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
