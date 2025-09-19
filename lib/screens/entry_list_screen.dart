import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/diary_entry.dart';
import '../services/diary_service.dart';
import 'add_entry_screen.dart';

class EntryListScreen extends StatefulWidget {
  const EntryListScreen({super.key});

  @override
  State<EntryListScreen> createState() => _EntryListScreenState();
}

class _EntryListScreenState extends State<EntryListScreen> {
  List<DiaryEntry> _entries = [];
  List<DiaryEntry> _filteredEntries = [];
  bool _isLoading = true;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _loadEntries();
  }

  Future<void> _loadEntries() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final entries = await DiaryService.getAllEntries();
      setState(() {
        _entries = entries;
        _filteredEntries = entries;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Hata: $e')));
      }
    }
  }

  void _searchEntries(String query) {
    setState(() {
      _searchQuery = query;
      if (query.isEmpty) {
        _filteredEntries = _entries;
      } else {
        _filteredEntries = _entries.where((entry) {
          return entry.title.toLowerCase().contains(query.toLowerCase()) ||
              entry.content.toLowerCase().contains(query.toLowerCase());
        }).toList();
      }
    });
  }

  Future<void> _deleteEntry(DiaryEntry entry) async {
    final bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Girişi Sil'),
        content: const Text('Bu girişi silmek istediğinizden emin misiniz?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('İptal'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Sil', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        await DiaryService.deleteEntry(entry.id);
        _loadEntries();
        if (mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text('Giriş silindi')));
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
        title: const Text('Tüm Girişler'),
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AddEntryScreen()),
              ).then((_) => _loadEntries());
            },
            icon: const Icon(Icons.add),
            tooltip: 'Yeni Giriş',
          ),
        ],
      ),
      body: Column(
        children: [
          // Arama çubuğu
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Girişlerde ara...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: Theme.of(
                  context,
                ).colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
              ),
              onChanged: _searchEntries,
            ),
          ),

          // Giriş listesi
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _filteredEntries.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          _searchQuery.isEmpty
                              ? Icons.book_outlined
                              : Icons.search_off,
                          size: 64,
                          color: Theme.of(context).colorScheme.outline,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          _searchQuery.isEmpty
                              ? 'Henüz giriş yok'
                              : 'Arama sonucu bulunamadı',
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(
                                color: Theme.of(context).colorScheme.outline,
                              ),
                        ),
                        if (_searchQuery.isEmpty) ...[
                          const SizedBox(height: 8),
                          Text(
                            'İlk girişini oluşturmak için + butonuna bas',
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(
                                  color: Theme.of(context).colorScheme.outline,
                                ),
                          ),
                        ],
                      ],
                    ),
                  )
                : RefreshIndicator(
                    onRefresh: _loadEntries,
                    child: ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: _filteredEntries.length,
                      itemBuilder: (context, index) {
                        final entry = _filteredEntries[index];
                        return Card(
                          margin: const EdgeInsets.only(bottom: 8),
                          child: ListTile(
                            title: Text(
                              entry.title,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 4),
                                Text(
                                  entry.content.length > 150
                                      ? '${entry.content.substring(0, 150)}...'
                                      : entry.content,
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.calendar_today,
                                      size: 16,
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.outline,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      DateFormat(
                                        'dd MMMM yyyy, HH:mm',
                                        'tr_TR',
                                      ).format(entry.date),
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodySmall
                                          ?.copyWith(
                                            color: Theme.of(
                                              context,
                                            ).colorScheme.outline,
                                          ),
                                    ),
                                    if (entry.mood != null) ...[
                                      const SizedBox(width: 16),
                                      Icon(
                                        Icons.mood,
                                        size: 16,
                                        color: Theme.of(
                                          context,
                                        ).colorScheme.outline,
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        entry.mood!,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodySmall
                                            ?.copyWith(
                                              color: Theme.of(
                                                context,
                                              ).colorScheme.outline,
                                            ),
                                      ),
                                    ],
                                  ],
                                ),
                              ],
                            ),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      AddEntryScreen(entry: entry),
                                ),
                              ).then((_) => _loadEntries());
                            },
                            trailing: PopupMenuButton(
                              itemBuilder: (context) => [
                                const PopupMenuItem(
                                  value: 'edit',
                                  child: Row(
                                    children: [
                                      Icon(Icons.edit),
                                      SizedBox(width: 8),
                                      Text('Düzenle'),
                                    ],
                                  ),
                                ),
                                const PopupMenuItem(
                                  value: 'delete',
                                  child: Row(
                                    children: [
                                      Icon(Icons.delete, color: Colors.red),
                                      SizedBox(width: 8),
                                      Text(
                                        'Sil',
                                        style: TextStyle(color: Colors.red),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                              onSelected: (value) {
                                if (value == 'edit') {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          AddEntryScreen(entry: entry),
                                    ),
                                  ).then((_) => _loadEntries());
                                } else if (value == 'delete') {
                                  _deleteEntry(entry);
                                }
                              },
                            ),
                          ),
                        );
                      },
                    ),
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddEntryScreen()),
          ).then((_) => _loadEntries());
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
