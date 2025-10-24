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
    final inspirationsData = await InspirationService.getInspirations();
    final inspirations = inspirationsData
        .map((data) => InspirationEntry.fromJson(data))
        .toList();
    state = inspirations;
  }

  // Yeni ilham ekle
  Future<void> addInspiration(String text, {String? author}) async {
    await InspirationService.saveInspiration(text, author: author);
    await loadInspirations(); // Listeyi yenile
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
}
