import 'package:flutter_riverpod/flutter_riverpod.dart';

// Seçili tab indeksi provider
final selectedTabIndexProvider = StateProvider<int>((ref) => 0);

// Aktif widget'lar provider
final enabledWidgetsProvider = StateProvider<List<String>>(
  (ref) => ['Günlük Hedef', 'Akıllı Öneriler', 'İlham Ekle'],
);

// Tab değiştirme provider
final tabProvider = StateNotifierProvider<TabNotifier, int>((ref) {
  return TabNotifier();
});

class TabNotifier extends StateNotifier<int> {
  TabNotifier() : super(0);

  void changeTab(int index) {
    state = index;
  }
}

// Widget yönetimi provider
final widgetManagementProvider =
    StateNotifierProvider<WidgetManagementNotifier, List<String>>((ref) {
      return WidgetManagementNotifier();
    });

class WidgetManagementNotifier extends StateNotifier<List<String>> {
  WidgetManagementNotifier()
    : super(['Günlük Hedef', 'Akıllı Öneriler', 'İlham Ekle']);

  void updateWidgets(List<String> newWidgets) {
    state = newWidgets;
  }

  void toggleWidget(String widgetName) {
    if (state.contains(widgetName)) {
      state = state.where((widget) => widget != widgetName).toList();
    } else {
      state = [...state, widgetName];
    }
  }
}
