import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'platform_specific_widgets.dart';

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
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildSection(
            title: 'Bugün Nasıl Hissediyorsun?',
            icon: Icon(
              Platform.isIOS ? CupertinoIcons.heart_fill : Icons.favorite,
              color: Platform.isIOS
                  ? CupertinoColors.systemBlue
                  : const Color(0xFFD2691E),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: List.generate(_moods.length, (index) {
                    final option = _moods[index];
                    final bool isSelected = _selectedMoodIndex == index;
                    return GestureDetector(
                      onTap: () => setState(() => _selectedMoodIndex = index),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 18,
                          vertical: 16,
                        ),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? (Platform.isIOS
                                    ? CupertinoColors.systemBlue.withOpacity(
                                        0.08,
                                      )
                                    : const Color(0xFFD2691E).withOpacity(0.08))
                              : (Platform.isIOS
                                    ? CupertinoColors.systemGrey6.withOpacity(
                                        0.3,
                                      )
                                    : Colors.grey.shade50),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: isSelected
                                ? (Platform.isIOS
                                      ? CupertinoColors.systemBlue.withOpacity(
                                          0.3,
                                        )
                                      : const Color(
                                          0xFFD2691E,
                                        ).withOpacity(0.3))
                                : (Platform.isIOS
                                      ? CupertinoColors.separator.withOpacity(
                                          0.2,
                                        )
                                      : Colors.grey.shade200),
                            width: isSelected ? 2 : 1,
                          ),
                          boxShadow: isSelected
                              ? [
                                  BoxShadow(
                                    color:
                                        (Platform.isIOS
                                                ? CupertinoColors.systemBlue
                                                : const Color(0xFFD2691E))
                                            .withOpacity(0.1),
                                    blurRadius: 12,
                                    offset: const Offset(0, 4),
                                  ),
                                ]
                              : null,
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              option.emoji,
                              style: const TextStyle(fontSize: 26),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              option.label,
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: Platform.isIOS
                                    ? CupertinoColors.label
                                    : Colors.black87,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
                ),
                const SizedBox(height: 24),
                _buildNoteField(context),
                const SizedBox(height: 16),
                _buildSaveButton(context),
              ],
            ),
          ),
          const SizedBox(height: 24),
          _buildSection(
            title: 'Günlük Olumlamalar',
            icon: Icon(
              Platform.isIOS ? CupertinoIcons.star_fill : Icons.star,
              color: Platform.isIOS
                  ? CupertinoColors.systemOrange
                  : const Color(0xFFEA580C),
            ),
            child: Column(
              children: [
                _buildAffirmationInput(context),
                const SizedBox(height: 16),
                _buildAffirmationsList(context),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required Widget icon,
    required Widget child,
  }) {
    return PlatformCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              icon,
              const SizedBox(width: 12),
              Text(
                title,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Platform.isIOS
                      ? CupertinoColors.label
                      : Theme.of(context).colorScheme.onSurface,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          child,
        ],
      ),
    );
  }

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
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 8),
        PlatformTextField(
          placeholder: 'Bugün neler yaşadın?',
          controller: _noteController,
          maxLines: 4,
        ),
      ],
    );
  }

  Widget _buildSaveButton(BuildContext context) {
    final bool isDisabled =
        _selectedMoodIndex == null && _noteController.text.trim().isEmpty;

    return PlatformButton(
      text: 'Kaydet',
      onPressed: isDisabled ? null : _onSaveMood,
      isFullWidth: true,
    );
  }

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
            : const Color(0xFFD2691E),
      ),
    );

    // Formu temizle
    setState(() {
      _selectedMoodIndex = null;
      _noteController.clear();
    });
  }

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
            const SizedBox(width: 12),
            PlatformButton(text: 'Ekle', onPressed: _addAffirmation),
          ],
        ),
        const SizedBox(height: 12),
        _buildCategorySelector(context),
      ],
    );
  }

  Widget _buildCategorySelector(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Platform.isIOS
            ? CupertinoColors.systemGrey6.withOpacity(0.3)
            : Colors.grey.shade50,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Platform.isIOS
              ? CupertinoColors.separator.withOpacity(0.2)
              : Colors.grey.shade200,
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Text(
            'Kategori: ',
            style: TextStyle(
              color: Platform.isIOS
                  ? CupertinoColors.secondaryLabel
                  : Colors.grey[600],
              fontSize: 14,
            ),
          ),
          Expanded(
            child: Text(
              _selectedCategory,
              style: TextStyle(
                color: Platform.isIOS ? CupertinoColors.label : Colors.black87,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          GestureDetector(
            onTap: _showCategoryPicker,
            child: Icon(
              Platform.isIOS
                  ? CupertinoIcons.chevron_down
                  : Icons.arrow_drop_down,
              color: Platform.isIOS
                  ? CupertinoColors.systemBlue
                  : const Color(0xFFD2691E),
            ),
          ),
        ],
      ),
    );
  }

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
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Kategori Seç',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[800],
                ),
              ),
              const SizedBox(height: 16),
              ..._categories.map(
                (category) => ListTile(
                  title: Text(category),
                  leading: category == _selectedCategory
                      ? Icon(Icons.check, color: const Color(0xFFD2691E))
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

  Widget _buildAffirmationsList(BuildContext context) {
    if (_affirmations.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(32),
        child: Text(
          'Henüz olumlama eklenmemiş.\nYukarıdan yeni olumlama ekleyebilirsiniz.',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Platform.isIOS
                ? CupertinoColors.secondaryLabel
                : Colors.grey[600],
            fontSize: 14,
          ),
        ),
      );
    }

    return Column(
      children: _affirmations.asMap().entries.map((entry) {
        final index = entry.key;
        final affirmation = entry.value;
        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Platform.isIOS
                ? CupertinoColors.systemGrey6.withOpacity(0.3)
                : Colors.grey.shade50,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: Platform.isIOS
                  ? CupertinoColors.separator.withOpacity(0.2)
                  : Colors.grey.shade200,
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.02),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      affirmation.text,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Platform.isIOS
                            ? CupertinoColors.label
                            : Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      affirmation.category,
                      style: TextStyle(
                        fontSize: 12,
                        color: Platform.isIOS
                            ? CupertinoColors.secondaryLabel
                            : Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  GestureDetector(
                    onTap: () => _toggleFavorite(index),
                    child: Icon(
                      affirmation.isFavorite
                          ? (Platform.isIOS
                                ? CupertinoIcons.heart_fill
                                : Icons.favorite)
                          : (Platform.isIOS
                                ? CupertinoIcons.heart
                                : Icons.favorite_border),
                      color: affirmation.isFavorite
                          ? (Platform.isIOS
                                ? CupertinoColors.systemRed
                                : Colors.red)
                          : (Platform.isIOS
                                ? CupertinoColors.secondaryLabel
                                : Colors.grey),
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: () => _deleteAffirmation(index),
                    child: Icon(
                      Platform.isIOS
                          ? CupertinoIcons.trash
                          : Icons.delete_outline,
                      color: Platform.isIOS
                          ? CupertinoColors.systemRed
                          : Colors.red,
                      size: 20,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  void _toggleFavorite(int index) {
    setState(() {
      _affirmations[index] = _affirmations[index].copyWith(
        isFavorite: !_affirmations[index].isFavorite,
      );
    });
  }

  void _deleteAffirmation(int index) {
    setState(() {
      _affirmations.removeAt(index);
    });
  }
}

class _MoodOption {
  const _MoodOption({required this.label, required this.emoji});

  final String label;
  final String emoji;
}

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
