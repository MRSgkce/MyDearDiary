import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'platform_specific_widgets.dart';
import 'adaptive_layout.dart';
import 'mood_widgets.dart'; // ✅ Modüler widget'larımız
import '../utils/responsive_helper.dart';

/// ✨ ADAPTIVE MOOD TAB
/// 
/// ÖNCEKİ SORUNLAR:
/// ❌ Manuel platform kontrolleri
/// ❌ Sabit padding ve boyutlar
/// ❌ Tekrar eden kod
/// ❌ Wrap kullanımı (responsive değil)
///
/// YENİ ÖZELLİKLER:
/// ✅ AdaptiveLayout ile responsive
/// ✅ AdaptiveGrid ile otomatik kolon sayısı
/// ✅ Modüler widget'larla temiz kod
/// ✅ ResponsiveHelper ile dinamik boyutlar

class MoodTab extends StatefulWidget {
  const MoodTab({super.key, this.isCupertino = false});

  final bool isCupertino;

  @override
  State<MoodTab> createState() => _MoodTabState();
}

class _MoodTabState extends State<MoodTab> {
  final TextEditingController _noteController = TextEditingController();
  final TextEditingController _affirmationController = TextEditingController();

  int? _selectedMoodIndex;
  String _selectedCategory = _categories.first;

  final List<_Affirmation> _affirmations = [
    const _Affirmation(text: 'Ben güçlü ve yetenekliyim', category: 'Öz Güven'),
    const _Affirmation(text: 'Her gün daha iyi oluyorum', category: 'Gelişim'),
    const _Affirmation(
      text: 'Kendimi olduğum gibi seviyorum',
      category: 'Öz Sevgi',
    ),
    const _Affirmation(
      text: 'Hayat bana güzel fırsatlar sunuyor',
      category: 'Pozitiflik',
    ),
  ];

  static const List<String> _categories = [
    'Öz Güven',
    'Gelişim',
    'Şükran',
    'Öz Sevgi',
    'Pozitiflik',
    'Sağlık',
  ];

  static const List<_MoodOption> _moods = [
    _MoodOption(label: 'Çok İyi', emoji: '😁'),
    _MoodOption(label: 'İyi', emoji: '🙂'),
    _MoodOption(label: 'Normal', emoji: '😐'),
    _MoodOption(label: 'Kötü', emoji: '🙁'),
    _MoodOption(label: 'Çok Kötü', emoji: '😞'),
  ];

  @override
  void dispose() {
    _noteController.dispose();
    _affirmationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // ✅ ÖĞRENİN: AdaptiveLayout kullanımı
    // Otomatik responsive padding ve scrolling ekler
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: Colors.white, // ✅ Sade beyaz arka plan
      child: AdaptiveLayout(
        scrollable: true, // Otomatik scroll
        useSafeArea: true, // Safe area padding
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Ruh Hali Seçme Bölümü
            _buildMoodSection(context),
            
            // Responsive spacing - cihaza göre
            SizedBox(
              height: ResponsiveHelper.responsive(
                context,
                mobile: 24.0,
                tablet: 32.0,
                desktop: 40.0,
              ),
            ),
            
            // Olumlamalar Bölümü
            _buildAffirmationsSection(context),
          ],
        ),
      ),
    );
  }

  /// ✅ ÖĞRENİN: Bölüm Widget'ı
  /// Tam sayfa container + SectionHeader kullanımı
  Widget _buildMoodSection(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: ResponsiveHelper.responsivePadding(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ✅ Modüler başlık widget'ı
          SectionHeader(
            title: 'Bugün Nasıl Hissediyorsun?',
            icon: Platform.isIOS ? CupertinoIcons.heart_fill : Icons.favorite,
          ),
          
          // Responsive spacing
          SizedBox(
            height: ResponsiveHelper.responsive(
              context,
              mobile: 20.0,
              tablet: 24.0,
              desktop: 28.0,
            ),
          ),
          
          // ✅ ÖĞRENİN: AdaptiveGrid kullanımı
          // Mobil: 2 kolon, Tablet: 3 kolon, Desktop: 5 kolon
          AdaptiveGrid(
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            maxColumns: 5, // Max 5 kolon (5 ruh hali var)
            childAspectRatio: 1.0, // Kare şekil
            children: List.generate(_moods.length, (index) {
              final mood = _moods[index];
              // ✅ Modüler MoodOptionCard widget'ı
              return MoodOptionCard(
                emoji: mood.emoji,
                label: mood.label,
                isSelected: _selectedMoodIndex == index,
                onTap: () => setState(() => _selectedMoodIndex = index),
              );
            }),
          ),
          
          SizedBox(
            height: ResponsiveHelper.responsive(
              context,
              mobile: 24.0,
              tablet: 28.0,
              desktop: 32.0,
            ),
          ),
          
          // Not alanı
          _buildNoteField(context),
          
          SizedBox(
            height: ResponsiveHelper.responsive(
              context,
              mobile: 16.0,
              tablet: 20.0,
              desktop: 24.0,
            ),
          ),
          
          // Kaydet butonu
          _buildSaveButton(context),
        ],
      ),
    );
  }

  /// Olumlamalar Bölümü
  Widget _buildAffirmationsSection(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: ResponsiveHelper.responsivePadding(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ✅ Modüler başlık
          SectionHeader(
            title: 'Günlük Olumlamalar',
            icon: Platform.isIOS ? CupertinoIcons.star_fill : Icons.star,
            iconColor: Platform.isIOS
                ? CupertinoColors.systemOrange
                : const Color(0xFFEA580C),
          ),
          
          SizedBox(
            height: ResponsiveHelper.responsive(
              context,
              mobile: 20.0,
              tablet: 24.0,
              desktop: 28.0,
            ),
          ),
          
          // Olumlama ekleme alanı
          _buildAffirmationInput(context),
          
          SizedBox(
            height: ResponsiveHelper.responsive(
              context,
              mobile: 16.0,
              tablet: 20.0,
              desktop: 24.0,
            ),
          ),
          
          // Olumlamalar listesi
          _buildAffirmationsList(context),
        ],
      ),
    );
  }

  /// Not girişi
  Widget _buildNoteField(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Not ekle (opsiyonel)',
          style: TextStyle(
            color: Platform.isIOS
                ? CupertinoColors.secondaryLabel
                : Colors.grey[600],
            fontSize: ResponsiveHelper.responsiveFontSize(
              context,
              mobile: 14,
              tablet: 15,
              desktop: 16,
            ),
          ),
        ),
        SizedBox(
          height: ResponsiveHelper.responsive(
            context,
            mobile: 8.0,
            tablet: 10.0,
            desktop: 12.0,
          ),
        ),
        // ✅ Platform-specific TextField
        PlatformTextField(
          placeholder: 'Bugün neler yaşadın?',
          controller: _noteController,
          maxLines: 4,
        ),
      ],
    );
  }

  /// Kaydet butonu
  Widget _buildSaveButton(BuildContext context) {
    final bool isDisabled =
        _selectedMoodIndex == null && _noteController.text.trim().isEmpty;

    // ✅ Platform-specific Button
    return PlatformButton(
      text: 'Kaydet',
      onPressed: isDisabled ? null : _onSaveMood,
      isFullWidth: true,
    );
  }

  /// Ruh halini kaydet
  void _onSaveMood() {
    if (_selectedMoodIndex == null && _noteController.text.trim().isEmpty) {
      return;
    }

    final String moodLabel = _selectedMoodIndex != null
        ? _moods[_selectedMoodIndex!].label
        : 'Not Kaydedildi';

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Ruh hali kaydedildi: $moodLabel'),
        backgroundColor: Platform.isIOS
            ? CupertinoColors.systemBlue
            : const Color(0xFFA68A38),
      ),
    );

    // Formu temizle
    setState(() {
      _selectedMoodIndex = null;
      _noteController.clear();
    });
  }

  /// Olumlama girişi
  Widget _buildAffirmationInput(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(
              child: PlatformTextField(
                placeholder: 'Yeni olumlama ekle...',
                controller: _affirmationController,
              ),
            ),
            SizedBox(
              width: ResponsiveHelper.responsive(
                context,
                mobile: 12.0,
                tablet: 16.0,
                desktop: 20.0,
              ),
            ),
            // Platform-specific buton
            PlatformButton(
              text: 'Ekle',
              onPressed: _addAffirmation,
            ),
          ],
        ),
        SizedBox(
          height: ResponsiveHelper.responsive(
            context,
            mobile: 12.0,
            tablet: 16.0,
            desktop: 20.0,
          ),
        ),
        // ✅ Modüler kategori seçici
        CategorySelector(
          selectedCategory: _selectedCategory,
          onTap: _showCategoryPicker,
        ),
      ],
    );
  }

  /// Kategori seçici dialog
  void _showCategoryPicker() {
    if (Platform.isIOS) {
      showCupertinoModalPopup(
        context: context,
        builder: (context) => CupertinoActionSheet(
          title: const Text('Kategori Seç'),
          actions: _categories
              .map(
                (category) => CupertinoActionSheetAction(
                  onPressed: () {
                    setState(() => _selectedCategory = category);
                    Navigator.pop(context);
                  },
                  isDefaultAction: category == _selectedCategory,
                  child: Text(category),
                ),
              )
              .toList(),
          cancelButton: CupertinoActionSheetAction(
            onPressed: () => Navigator.pop(context),
            child: const Text('İptal'),
          ),
        ),
      );
    } else {
      showModalBottomSheet(
        context: context,
        builder: (context) => Container(
          padding: ResponsiveHelper.responsivePadding(context),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Kategori Seç',
                style: TextStyle(
                  fontSize: ResponsiveHelper.responsiveFontSize(
                    context,
                    mobile: 18,
                    tablet: 20,
                    desktop: 22,
                  ),
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[800],
                ),
              ),
              const SizedBox(height: 16),
              ..._categories.map(
                (category) => ListTile(
                  title: Text(category),
                  leading: category == _selectedCategory
                      ? const Icon(Icons.check, color: Color(0xFFA68A38))
                      : null,
                  onTap: () {
                    setState(() => _selectedCategory = category);
                    Navigator.pop(context);
                  },
                ),
              ),
            ],
          ),
        ),
      );
    }
  }

  /// Olumlama ekle
  void _addAffirmation() {
    if (_affirmationController.text.trim().isEmpty) return;

    setState(() {
      _affirmations.add(
        _Affirmation(
          text: _affirmationController.text.trim(),
          category: _selectedCategory,
        ),
      );
      _affirmationController.clear();
    });
  }

  /// Olumlamalar listesi
  Widget _buildAffirmationsList(BuildContext context) {
    if (_affirmations.isEmpty) {
      // ✅ Modüler boş durum widget'ı
      return EmptyStateWidget(
        message:
            'Henüz olumlama eklenmemiş.\nYukarıdan yeni olumlama ekleyebilirsiniz.',
        icon: Platform.isIOS ? CupertinoIcons.star : Icons.star_border,
      );
    }

    // ✅ ÖĞRENİN: Modüler AffirmationCard kullanımı
    // Her olumlama için aynı tasarım
    return Column(
      children: _affirmations.asMap().entries.map((entry) {
        final index = entry.key;
        final affirmation = entry.value;
        
        return AffirmationCard(
          text: affirmation.text,
          category: affirmation.category,
          isFavorite: affirmation.isFavorite,
          onToggleFavorite: () => _toggleFavorite(index),
          onDelete: () => _deleteAffirmation(index),
        );
      }).toList(),
    );
  }

  /// Favori durumunu değiştir
  void _toggleFavorite(int index) {
    setState(() {
      _affirmations[index] = _affirmations[index].copyWith(
        isFavorite: !_affirmations[index].isFavorite,
      );
    });
  }

  /// Olumlamayı sil
  void _deleteAffirmation(int index) {
    setState(() {
      _affirmations.removeAt(index);
    });
  }
}

/// Ruh hali seçeneği model
class _MoodOption {
  const _MoodOption({required this.label, required this.emoji});

  final String label;
  final String emoji;
}

/// Olumlama model
class _Affirmation {
  const _Affirmation({
    required this.text,
    required this.category,
    this.isFavorite = false,
  });

  final String text;
  final String category;
  final bool isFavorite;

  _Affirmation copyWith({String? text, String? category, bool? isFavorite}) {
    return _Affirmation(
      text: text ?? this.text,
      category: category ?? this.category,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }
}
