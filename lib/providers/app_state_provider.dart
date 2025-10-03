import 'package:flutter_riverpod/flutter_riverpod.dart';

// Seçili tab indeksi provider
final selectedTabIndexProvider = StateProvider<int>((ref) => 0);
