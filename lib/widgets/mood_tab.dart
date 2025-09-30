import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
    return NotificationListener<SizeChangedLayoutNotification>(
      onNotification: (_) {
        setState(() {});
        return true;
      },
      child: SizeChangedLayoutNotifier(
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildSection(
                title: 'Bugün Nasıl Hissediyorsun?',
                icon: widget.isCupertino
                    ? const Icon(
                        CupertinoIcons.heart_fill,
                        color: CupertinoColors.activeBlue,
                      )
                    : Icon(
                        Icons.favorite,
                        color: Theme.of(context).colorScheme.primary,
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
                          onTap: () =>
                              setState(() => _selectedMoodIndex = index),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 18,
                              vertical: 16,
                            ),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? (widget.isCupertino
                                        ? CupertinoColors.activeBlue
                                              .withOpacity(0.12)
                                        : Theme.of(context).colorScheme.primary
                                              .withOpacity(0.1))
                                  : (widget.isCupertino
                                        ? CupertinoColors.systemBackground
                                        : Theme.of(
                                            context,
                                          ).colorScheme.surface),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: isSelected
                                    ? (widget.isCupertino
                                          ? CupertinoColors.activeBlue
                                          : Theme.of(
                                              context,
                                            ).colorScheme.primary)
                                    : (widget.isCupertino
                                          ? CupertinoColors.separator
                                          : Theme.of(
                                              context,
                                            ).dividerColor.withOpacity(0.3)),
                              ),
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
                                    color: widget.isCupertino
                                        ? CupertinoColors.label
                                        : Theme.of(
                                            context,
                                          ).colorScheme.onSurface,
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
                icon: widget.isCupertino
                    ? const Icon(
                        CupertinoIcons.star_fill,
                        color: CupertinoColors.activeOrange,
                      )
                    : Icon(
                        Icons.star,
                        color: Theme.of(context).colorScheme.secondary,
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
        ),
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required Widget icon,
    required Widget child,
  }) {
    final BorderRadius radius = BorderRadius.circular(20);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: widget.isCupertino
              ? CupertinoColors.systemBackground
              : Theme.of(context).colorScheme.surface,
          borderRadius: radius,
          border: widget.isCupertino
              ? Border.all(color: CupertinoColors.separator)
              : Border.all(
                  color: Theme.of(context).dividerColor.withOpacity(0.1),
                ),
          boxShadow: [
            BoxShadow(
              color: widget.isCupertino
                  ? CupertinoColors.black.withOpacity(0.02)
                  : Colors.black.withOpacity(0.03),
              blurRadius: 16,
              offset: const Offset(0, 12),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
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
                      color: widget.isCupertino
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
        ),
      ),
    );
  }

  Widget _buildNoteField(BuildContext context) {
    if (widget.isCupertino) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Not ekle (opsiyonel)',
            style: TextStyle(
              color: CupertinoColors.secondaryLabel,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 8),
          CupertinoTextField(
            controller: _noteController,
            placeholder: 'Bugün neler yaşadın?',
            minLines: 2,
            maxLines: 4,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: CupertinoColors.systemGrey6,
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Not ekle (opsiyonel)',
          style: Theme.of(context).textTheme.labelMedium?.copyWith(
            color: Theme.of(context).colorScheme.outline,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: _noteController,
          minLines: 2,
          maxLines: 4,
          decoration: InputDecoration(
            hintText: 'Bugün neler yaşadın?',
            filled: true,
            fillColor: Theme.of(
              context,
            ).colorScheme.surfaceVariant.withOpacity(0.3),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSaveButton(BuildContext context) {
    final bool isDisabled =
        _selectedMoodIndex == null && _noteController.text.trim().isEmpty;

    if (widget.isCupertino) {
      return CupertinoButton.filled(
        onPressed: isDisabled ? null : _onSaveMood,
        child: const Text('Kaydet'),
      );
    }

    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: isDisabled ? null : _onSaveMood,
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16),
        ),
        child: const Text('Kaydet'),
      ),
    );
  }

  void _onSaveMood() {
    if (_selectedMoodIndex == null && _noteController.text.trim().isEmpty) {
      return;
    }

    final String moodLabel = _selectedMoodIndex != null
        ? _moods[_selectedMoodIndex!].label
        : 'Not kaydedildi';

    if (widget.isCupertino) {
      showCupertinoDialog(
        context: context,
        builder: (context) => CupertinoAlertDialog(
          title: const Text('Kaydedildi'),
          content: Text('Bugünkü ruh halin "$moodLabel" olarak kaydedildi.'),
          actions: [
            CupertinoDialogAction(
              onPressed: () => Navigator.pop(context),
              child: const Text('Tamam'),
            ),
          ],
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Bugünkü ruh halin "$moodLabel" olarak kaydedildi.'),
        ),
      );
    }

    setState(() {
      _selectedMoodIndex = null;
      _noteController.clear();
    });
  }

  Widget _buildAffirmationInput(BuildContext context) {
    final Color background = widget.isCupertino
        ? CupertinoColors.systemGrey6
        : Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.25);

    return DecoratedBox(
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Yeni Olumlama',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: widget.isCupertino
                    ? CupertinoColors.label
                    : Theme.of(context).colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 12),
            if (widget.isCupertino)
              CupertinoTextField(
                controller: _affirmationController,
                placeholder: 'Ben başarılı olmayı hak ediyorum',
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: CupertinoColors.systemBackground,
                  borderRadius: BorderRadius.circular(12),
                ),
              )
            else
              TextField(
                controller: _affirmationController,
                decoration: InputDecoration(
                  hintText: 'Ben başarılı olmayı hak ediyorum',
                  filled: true,
                  fillColor: Theme.of(context).colorScheme.background,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: Theme.of(context).dividerColor.withOpacity(0.1),
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ),
              ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(child: _buildCategorySelector(context)),
                const SizedBox(width: 12),
                _buildAddAffirmationButton(context),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategorySelector(BuildContext context) {
    if (widget.isCupertino) {
      return CupertinoButton(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        color: CupertinoColors.systemBackground,
        borderRadius: BorderRadius.circular(12),
        onPressed: () async {
          final selected = await showCupertinoModalPopup<String>(
            context: context,
            builder: (context) => _CategoryPickerSheet(
              categories: _categories,
              initialValue: _selectedCategory,
            ),
          );

          if (selected != null && mounted) {
            setState(() => _selectedCategory = selected);
          }
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              _selectedCategory,
              style: const TextStyle(color: CupertinoColors.label),
            ),
            const Icon(
              CupertinoIcons.chevron_down,
              size: 18,
              color: CupertinoColors.systemGrey,
            ),
          ],
        ),
      );
    }

    return InputDecorator(
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          isExpanded: true,
          value: _selectedCategory,
          items: _categories
              .map(
                (category) =>
                    DropdownMenuItem(value: category, child: Text(category)),
              )
              .toList(),
          onChanged: (value) {
            if (value == null) return;
            setState(() => _selectedCategory = value);
          },
        ),
      ),
    );
  }

  Widget _buildAddAffirmationButton(BuildContext context) {
    final bool isDisabled = _affirmationController.text.trim().isEmpty;

    if (widget.isCupertino) {
      return CupertinoButton(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        color: isDisabled
            ? CupertinoColors.systemGrey4
            : CupertinoColors.activeBlue,
        borderRadius: BorderRadius.circular(12),
        onPressed: isDisabled ? null : _addAffirmation,
        child: const Icon(CupertinoIcons.add, color: CupertinoColors.white),
      );
    }

    return SizedBox(
      height: 48,
      child: ElevatedButton(
        onPressed: isDisabled ? null : _addAffirmation,
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 18),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _addAffirmation() {
    final text = _affirmationController.text.trim();
    if (text.isEmpty) return;

    setState(() {
      _affirmations.insert(
        0,
        _Affirmation(text: text, category: _selectedCategory),
      );
      _affirmationController.clear();
    });
  }

  Widget _buildAffirmationsList(BuildContext context) {
    if (_affirmations.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 24),
        child: Text(
          'Henüz olumlama eklenmedi.',
          style: TextStyle(
            color: widget.isCupertino
                ? CupertinoColors.secondaryLabel
                : Theme.of(context).colorScheme.outline,
          ),
        ),
      );
    }

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _affirmations.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final affirmation = _affirmations[index];
        return DecoratedBox(
          decoration: BoxDecoration(
            color: widget.isCupertino
                ? CupertinoColors.systemBackground
                : Theme.of(context).colorScheme.background,
            borderRadius: BorderRadius.circular(16),
            border: widget.isCupertino
                ? Border.all(color: CupertinoColors.separator)
                : Border.all(
                    color: Theme.of(context).dividerColor.withOpacity(0.1),
                  ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        affirmation.text,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: widget.isCupertino
                              ? CupertinoColors.label
                              : Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        widget.isCupertino
                            ? CupertinoButton(
                                padding: EdgeInsets.zero,
                                onPressed: () => _toggleFavorite(index),
                                child: Icon(
                                  affirmation.isFavorite
                                      ? CupertinoIcons.star_fill
                                      : CupertinoIcons.star,
                                  color: affirmation.isFavorite
                                      ? CupertinoColors.systemYellow
                                      : CupertinoColors.systemGrey,
                                  size: 22,
                                ),
                              )
                            : IconButton(
                                onPressed: () => _toggleFavorite(index),
                                icon: Icon(
                                  affirmation.isFavorite
                                      ? Icons.star
                                      : Icons.star_border,
                                  color: affirmation.isFavorite
                                      ? Colors.amber
                                      : Theme.of(context).colorScheme.outline,
                                ),
                              ),
                        widget.isCupertino
                            ? CupertinoButton(
                                padding: EdgeInsets.zero,
                                onPressed: () => _removeAffirmation(index),
                                child: const Icon(
                                  CupertinoIcons.delete,
                                  size: 22,
                                  color: CupertinoColors.systemRed,
                                ),
                              )
                            : IconButton(
                                onPressed: () => _removeAffirmation(index),
                                icon: const Icon(
                                  Icons.delete_outline,
                                  color: Colors.redAccent,
                                ),
                              ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: widget.isCupertino
                          ? CupertinoColors.systemGrey5
                          : Theme.of(
                              context,
                            ).colorScheme.primary.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Text(
                      affirmation.category,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: widget.isCupertino
                            ? CupertinoColors.secondaryLabel
                            : Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _toggleFavorite(int index) {
    setState(() {
      final affirmation = _affirmations[index];
      _affirmations[index] = affirmation.copyWith(
        isFavorite: !affirmation.isFavorite,
      );
    });
  }

  void _removeAffirmation(int index) {
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

class _CategoryPickerSheet extends StatelessWidget {
  const _CategoryPickerSheet({
    required this.categories,
    required this.initialValue,
  });

  final List<String> categories;
  final String initialValue;

  @override
  Widget build(BuildContext context) {
    return CupertinoActionSheet(
      title: const Text('Kategori Seç'),
      actions: [
        for (final category in categories)
          CupertinoActionSheetAction(
            onPressed: () => Navigator.pop(context, category),
            isDefaultAction: category == initialValue,
            child: Text(category),
          ),
      ],
      cancelButton: CupertinoActionSheetAction(
        onPressed: () => Navigator.pop(context),
        isDefaultAction: false,
        child: const Text('Vazgeç'),
      ),
    );
  }
}
