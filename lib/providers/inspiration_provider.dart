import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/inspiration_service.dart';
import '../models/inspiration_entry.dart';

// InspirationService provider - Static metodlar kullandığımız için gerekli değil
// final inspirationServiceProvider = Provider<InspirationService>((ref) {
//   return InspirationService();
// });

// Inspirations listesi provider
final inspirationsProvider =
    StateNotifierProvider<InspirationsNotifier, List<InspirationEntry>>((ref) {
      return InspirationsNotifier();
    });

// InspirationsNotifier
class InspirationsNotifier extends StateNotifier<List<InspirationEntry>> {
  InspirationsNotifier() : super([]) {
    loadInspirations();
  }

  // İlhamları yükle
  Future<void> loadInspirations() async {
    print('🔄 Provider loadInspirations başladı');
    final inspirationsData = await InspirationService.getInspirations();
    print('📊 Firebase\'den ${inspirationsData.length} ilham geldi');
    final inspirations = inspirationsData
        .map((data) => InspirationEntry.fromJson(data))
        .toList();
    print('📦 ${inspirations.length} ilham state\'e atandı');
    state = inspirations;
  }

  // Yeni ilham ekle
  Future<void> addInspiration(
    String text, {
    String? author,
    String? category,
    List<String>? tags,
  }) async {
    print('🎯 Provider addInspiration başladı');
    final inspiration = {
      'text': text,
      'author': author,
      'likes': 0,
      'shares': 0,
      'category': category ?? 'Genel',
      'tags': tags ?? [],
      'isFavorite': false,
    };
    print('📦 İlham verisi hazırlandı: $inspiration');

    try {
      await InspirationService.addInspiration(inspiration);
      print('✅ Service başarılı, listeyi yeniliyor...');
      await loadInspirations(); // Listeyi yenile
      print('🔄 Liste yenilendi, toplam: ${state.length}');
    } catch (e) {
      print('❌ Provider hatası: $e');
      rethrow;
    }
  }

  // İlham sil
  Future<void> deleteInspiration(String id) async {
    await InspirationService.deleteInspiration(id);
    await loadInspirations(); // Listeyi yenile
  }

  // İlham güncelle
  Future<void> updateInspiration(
    String id,
    String text, {
    String? author,
  }) async {
    await InspirationService.updateInspiration(id, text, author: author);
    await loadInspirations(); // Listeyi yenile
  }

  // İlham beğen
  Future<void> likeInspiration(String id) async {
    await InspirationService.likeInspiration(id);
    await loadInspirations(); // Listeyi yenile
  }

  // İlham paylaş
  Future<void> shareInspiration(String id) async {
    await InspirationService.shareInspiration(id);
    await loadInspirations(); // Listeyi yenile
  }

  // İlham favorilere ekle/çıkar
  Future<void> toggleFavorite(String id) async {
    await InspirationService.toggleFavorite(id);
    await loadInspirations(); // Listeyi yenile
  }
}
