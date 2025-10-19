# Adaptive Widgets Kullanım Kılavuzu

## 🎯 Adaptive Widgets Nedir?

Adaptive widgets, Flutter uygulamalarınızın farklı platformlarda (iOS, Android, Web, Desktop) ve farklı ekran boyutlarında (telefon, tablet, desktop) otomatik olarak optimize görünmesini sağlar.

## 📱 Platform-Specific Widgets

### 1. PlatformButton
iOS'ta CupertinoButton, Android'de ElevatedButton olarak görünür.

```dart
import 'package:my_dear_diary/widgets/platform_specific_widgets.dart';

PlatformButton(
  text: 'Kaydet',
  icon: Icons.save,
  onPressed: () {
    // Kaydet işlemi
  },
  isFullWidth: true,
  backgroundColor: Colors.blue,
)
```

### 2. PlatformCard
Platform stiline uygun kart widget'ı.

```dart
PlatformCard(
  padding: EdgeInsets.all(20),
  margin: EdgeInsets.all(16),
  child: Column(
    children: [
      Text('Günlük Kaydım'),
      Text('Bugün harika bir gündü...'),
    ],
  ),
)
```

### 3. PlatformTextField
Platforma özel metin girişi.

```dart
PlatformTextField(
  placeholder: 'Günlük başlığı...',
  controller: _titleController,
  onChanged: (value) {
    print('Yeni değer: $value');
  },
  maxLines: 1,
)
```

### 4. PlatformAlertDialog
Platforma özel dialog gösterme.

```dart
PlatformAlertDialog.show(
  context: context,
  title: 'Emin misiniz?',
  content: 'Bu günlük kaydını silmek istediğinizden emin misiniz?',
  actions: [
    PlatformDialogAction(
      text: 'İptal',
      onPressed: () => Navigator.pop(context),
    ),
    PlatformDialogAction(
      text: 'Sil',
      isDestructive: true,
      onPressed: () {
        // Silme işlemi
        Navigator.pop(context);
      },
    ),
  ],
)
```

## 📐 Responsive/Adaptive Layout Widgets

### 1. AdaptiveLayout
Ekran boyutuna göre padding, scrolling ve safe area yönetimi.

```dart
import 'package:my_dear_diary/widgets/adaptive_layout.dart';

AdaptiveLayout(
  scrollable: true,
  useSafeArea: true,
  child: Column(
    children: [
      Text('İçerik buraya'),
      // Mobilde: 16px padding
      // Tablet'te: 24px padding
      // Desktop'ta: 32px padding
    ],
  ),
)
```

### 2. AdaptiveGrid
Ekran boyutuna göre otomatik kolon sayısı.

```dart
AdaptiveGrid(
  children: [
    MoodCard(mood: '😊'),
    MoodCard(mood: '😢'),
    MoodCard(mood: '😴'),
    MoodCard(mood: '🤩'),
  ],
  // Mobil: 1 kolon
  // Tablet: 2 kolon
  // Desktop: 3 kolon
  // Large Desktop: 4 kolon
)
```

### 3. AdaptiveCard
Ekran boyutuna göre responsive kart.

```dart
AdaptiveCard(
  child: Column(
    children: [
      Icon(Icons.mood, size: 48),
      SizedBox(height: 12),
      Text('Bugün nasıl hissediyorsun?'),
    ],
  ),
  // Padding, margin, elevation otomatik ayarlanır
)
```

### 4. AdaptiveText
Font boyutu otomatik ölçeklenir.

```dart
AdaptiveText(
  'Başlık',
  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
  // Mobil: 24px
  // Tablet: 26.4px (1.1x)
  // Desktop: 28.8px (1.2x)
  // Large Desktop: 31.2px (1.3x)
)
```

### 5. AdaptiveButton
Ekran boyutuna göre boyutlanan buton.

```dart
AdaptiveButton(
  text: 'Yeni Günlük Ekle',
  icon: Icons.add,
  onPressed: () {
    // Ekle işlemi
  },
  isFullWidth: true,
)
```

## 🧭 Adaptive Navigation

### AdaptiveNavigationBar
Ekran boyutuna göre farklı navigasyon tipleri:
- **Mobil/Tablet**: Alt navigasyon çubuğu
- **Desktop**: Yan sidebar

```dart
import 'package:my_dear_diary/widgets/adaptive_navigation.dart';

AdaptiveNavigationBar(
  selectedIndex: _currentIndex,
  onTap: (index) {
    setState(() => _currentIndex = index);
  },
  items: [
    AdaptiveNavigationItem(
      icon: Icons.home_outlined,
      activeIcon: Icons.home,
      label: 'Ana Sayfa',
    ),
    AdaptiveNavigationItem(
      icon: Icons.book_outlined,
      activeIcon: Icons.book,
      label: 'Günlüklerim',
    ),
    AdaptiveNavigationItem(
      icon: Icons.lightbulb_outline,
      activeIcon: Icons.lightbulb,
      label: 'İlham',
    ),
  ],
)
```

### AdaptiveScaffold
Tüm scaffold yapısını adaptive hale getirir.

```dart
AdaptiveScaffold(
  appBar: CustomAppBar(title: 'Ana Sayfa'),
  body: Column(
    children: [
      Text('İçerik'),
    ],
  ),
  navigationItems: [
    AdaptiveNavigationItem(
      icon: Icons.home_outlined,
      activeIcon: Icons.home,
      label: 'Ana Sayfa',
    ),
  ],
  selectedIndex: 0,
  onNavigationTap: (index) {
    // Navigasyon işlemi
  },
)
```

## 🛠️ Responsive Helper Kullanımı

### Cihaz Tipini Öğrenme

```dart
import 'package:my_dear_diary/utils/responsive_helper.dart';

final deviceType = ResponsiveHelper.getDeviceType(context);

if (deviceType == DeviceType.mobile) {
  // Mobil için özel kod
} else if (deviceType == DeviceType.tablet) {
  // Tablet için özel kod
} else if (deviceType == DeviceType.desktop) {
  // Desktop için özel kod
}
```

### Responsive Değerler

```dart
// Farklı ekranlar için farklı değerler
final padding = ResponsiveHelper.responsive(
  context,
  mobile: 16.0,
  tablet: 24.0,
  desktop: 32.0,
  largeDesktop: 40.0,
);

// Font boyutu
final fontSize = ResponsiveHelper.responsiveFontSize(
  context,
  mobile: 14,
  tablet: 16,
  desktop: 18,
);

// Grid kolon sayısı
final columns = ResponsiveHelper.responsiveGridColumns(context);
// Mobil: 1, Tablet: 2, Desktop: 3, Large Desktop: 4
```

### Landscape Kontrolü

```dart
final isLandscape = ResponsiveHelper.isLandscape(context);

if (isLandscape) {
  // Landscape için özel layout
} else {
  // Portrait için normal layout
}
```

## 📋 Tam Ekran Örneği

```dart
import 'package:flutter/material.dart';
import 'package:my_dear_diary/widgets/adaptive_layout.dart';
import 'package:my_dear_diary/widgets/adaptive_navigation.dart';
import 'package:my_dear_diary/widgets/platform_specific_widgets.dart';
import 'package:my_dear_diary/utils/responsive_helper.dart';

class AdaptiveExampleScreen extends StatefulWidget {
  const AdaptiveExampleScreen({Key? key}) : super(key: key);

  @override
  State<AdaptiveExampleScreen> createState() => _AdaptiveExampleScreenState();
}

class _AdaptiveExampleScreenState extends State<AdaptiveExampleScreen> {
  int _selectedIndex = 0;
  final _titleController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AdaptiveScaffold(
      appBar: AppBar(title: const Text('Adaptive Örnek')),
      body: AdaptiveLayout(
        scrollable: true,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Responsive başlık
            AdaptiveText(
              'Yeni Günlük Kaydı',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            
            SizedBox(height: ResponsiveHelper.responsive(
              context,
              mobile: 16.0,
              tablet: 24.0,
              desktop: 32.0,
            )),
            
            // Platform-specific text field
            PlatformTextField(
              placeholder: 'Başlık yazın...',
              controller: _titleController,
            ),
            
            SizedBox(height: 24),
            
            // Adaptive grid
            AdaptiveGrid(
              children: [
                _buildMoodCard('😊', 'Mutlu'),
                _buildMoodCard('😢', 'Üzgün'),
                _buildMoodCard('😴', 'Yorgun'),
                _buildMoodCard('🤩', 'Heyecanlı'),
              ],
            ),
            
            SizedBox(height: 24),
            
            // Platform-specific button
            PlatformButton(
              text: 'Kaydet',
              icon: Icons.save,
              onPressed: () {
                PlatformAlertDialog.show(
                  context: context,
                  title: 'Başarılı',
                  content: 'Günlük kaydınız kaydedildi!',
                  actions: [
                    PlatformDialogAction(
                      text: 'Tamam',
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                );
              },
              isFullWidth: true,
            ),
          ],
        ),
      ),
      navigationItems: [
        AdaptiveNavigationItem(
          icon: Icons.home_outlined,
          activeIcon: Icons.home,
          label: 'Ana Sayfa',
        ),
        AdaptiveNavigationItem(
          icon: Icons.book_outlined,
          activeIcon: Icons.book,
          label: 'Günlüklerim',
        ),
      ],
      selectedIndex: _selectedIndex,
      onNavigationTap: (index) {
        setState(() => _selectedIndex = index);
      },
    );
  }

  Widget _buildMoodCard(String emoji, String label) {
    return AdaptiveCard(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(emoji, style: TextStyle(fontSize: 48)),
          SizedBox(height: 8),
          AdaptiveText(
            label,
            style: TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }
}
```

## 🎨 Tasarım Kuralları

### Breakpoint'ler
- **Mobile**: < 480px
- **Tablet**: 480px - 768px
- **Desktop**: 768px - 1024px
- **Large Desktop**: > 1440px

### Padding Standartları
- Mobile: 16px
- Tablet: 24px
- Desktop: 32px
- Large Desktop: 40px

### Font Çarpanları
- Mobile: 1.0x
- Tablet: 1.1x
- Desktop: 1.2x
- Large Desktop: 1.3x

## 💡 İpuçları

1. **Platform-Specific widget'ları** iOS ve Android arasındaki görünüm farklılıkları için kullanın
2. **Adaptive Layout widget'ları** farklı ekran boyutları için kullanın
3. **ResponsiveHelper**'ı custom değerler için kullanın
4. Her zaman **context**'i geçmeyi unutmayın
5. Tablet ve Desktop için ayrı değerler vermezseniz, mobil değerler kullanılır

## 📚 Daha Fazla Örnek

Projenizde zaten kullanılan örneklere bakın:
- `lib/screens/home_screen.dart` - AdaptiveScaffold kullanımı
- `lib/widgets/mood_card.dart` - PlatformCard kullanımı
- `lib/widgets/custom_app_bar.dart` - Platform-specific AppBar

---

**Not**: Bu widget'lar projenizde hazır durumda! Sadece import edip kullanmaya başlayabilirsiniz. 🚀


