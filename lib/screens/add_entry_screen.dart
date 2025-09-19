import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/diary_entry.dart';
import '../services/diary_service.dart';

class AddEntryScreen extends StatefulWidget {
  final DiaryEntry? entry;

  const AddEntryScreen({super.key, this.entry});

  @override
  State<AddEntryScreen> createState() => _AddEntryScreenState();
}

class _AddEntryScreenState extends State<AddEntryScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();

  DateTime _selectedDate = DateTime.now();
  String? _selectedMood;

  final List<String> _moods = [
    '😊 Mutlu',
    '😢 Üzgün',
    '😴 Yorgun',
    '😤 Sinirli',
    '😌 Sakin',
    '🤔 Düşünceli',
    '😍 Aşık',
    '😰 Endişeli',
    '😎 Kendinden Emin',
    '😴 Uykulu',
  ];

  @override
  void initState() {
    super.initState();
    if (widget.entry != null) {
      _titleController.text = widget.entry!.title;
      _contentController.text = widget.entry!.content;
      _selectedDate = widget.entry!.date;
      _selectedMood = widget.entry!.mood;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      locale: const Locale('tr', 'TR'),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _saveEntry() async {
    if (_formKey.currentState!.validate()) {
      try {
        final entry = DiaryEntry(
          id: widget.entry?.id ?? DiaryService.generateId(),
          title: _titleController.text.trim(),
          content: _contentController.text.trim(),
          date: _selectedDate,
          mood: _selectedMood,
        );

        if (widget.entry == null) {
          await DiaryService.addEntry(entry);
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Giriş başarıyla kaydedildi!')),
            );
          }
        } else {
          await DiaryService.updateEntry(entry);
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Giriş başarıyla güncellendi!')),
            );
          }
        }

        if (mounted) {
          Navigator.pop(context, true);
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Hata: $e')));
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.entry == null ? 'Yeni Giriş' : 'Girişi Düzenle'),
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        actions: [
          TextButton(
            onPressed: _saveEntry,
            child: Text(
              'Kaydet',
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Başlık
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Başlık',
                  hintText: 'Bugün nasıldı?',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Lütfen bir başlık girin';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 16),

              // Tarih seçici
              Card(
                child: ListTile(
                  leading: const Icon(Icons.calendar_today),
                  title: const Text('Tarih'),
                  subtitle: Text(
                    DateFormat('dd MMMM yyyy', 'tr_TR').format(_selectedDate),
                  ),
                  trailing: const Icon(Icons.arrow_drop_down),
                  onTap: _selectDate,
                ),
              ),

              const SizedBox(height: 16),

              // Ruh hali seçici
              Text(
                'Ruh Hali',
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),

              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _moods.map((mood) {
                  final isSelected = _selectedMood == mood;
                  return FilterChip(
                    label: Text(mood),
                    selected: isSelected,
                    onSelected: (selected) {
                      setState(() {
                        _selectedMood = selected ? mood : null;
                      });
                    },
                    selectedColor: Theme.of(
                      context,
                    ).colorScheme.primaryContainer,
                    checkmarkColor: Theme.of(
                      context,
                    ).colorScheme.onPrimaryContainer,
                  );
                }).toList(),
              ),

              const SizedBox(height: 16),

              // İçerik
              TextFormField(
                controller: _contentController,
                decoration: const InputDecoration(
                  labelText: 'İçerik',
                  hintText: 'Bugün neler yaşadın? Nasıl hissediyorsun?',
                  border: OutlineInputBorder(),
                  alignLabelWithHint: true,
                ),
                maxLines: 10,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Lütfen içerik girin';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 24),

              // Kaydet butonu
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _saveEntry,
                  icon: const Icon(Icons.save),
                  label: Text(widget.entry == null ? 'Kaydet' : 'Güncelle'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
