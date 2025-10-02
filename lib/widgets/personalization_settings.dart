import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'personalized_home_widgets.dart';

class PersonalizationSettings extends StatefulWidget {
  final bool isCupertino;
  final List<String> enabledWidgets;
  final Function(List<String>) onWidgetsChanged;

  const PersonalizationSettings({
    super.key,
    required this.isCupertino,
    required this.enabledWidgets,
    required this.onWidgetsChanged,
  });

  @override
  State<PersonalizationSettings> createState() =>
      _PersonalizationSettingsState();
}

class _PersonalizationSettingsState extends State<PersonalizationSettings> {
  late List<String> _enabledWidgets;

  @override
  void initState() {
    super.initState();
    _enabledWidgets = List.from(widget.enabledWidgets);
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isCupertino) {
      return _buildCupertinoSettings();
    } else {
      return _buildMaterialSettings();
    }
  }

  Widget _buildMaterialSettings() {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ana Sayfa Kişiselleştirme'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          TextButton(onPressed: _saveSettings, child: const Text('Kaydet')),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Widget\'ları Özelleştirin',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Ana sayfanızda hangi widget\'ların görüneceğini seçin ve sıralarını değiştirin.',
                      style: Theme.of(
                        context,
                      ).textTheme.bodyMedium?.copyWith(color: Colors.black54),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            _buildWidgetList(),
          ],
        ),
      ),
    );
  }

  Widget _buildCupertinoSettings() {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: const Text('Ana Sayfa Kişiselleştirme'),
        trailing: CupertinoButton(
          padding: EdgeInsets.zero,
          onPressed: _saveSettings,
          child: const Text('Kaydet'),
        ),
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: CupertinoColors.systemBackground,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: CupertinoColors.separator),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Widget\'ları Özelleştirin',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: CupertinoColors.label,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Ana sayfanızda hangi widget\'ların görüneceğini seçin ve sıralarını değiştirin.',
                      style: TextStyle(
                        fontSize: 14,
                        color: CupertinoColors.secondaryLabel,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              _buildWidgetList(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWidgetList() {
    final availableWidgets = PersonalizedWidgetManager.availableWidgets;

    return ReorderableListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: availableWidgets.length,
      onReorder: _onReorder,
      itemBuilder: (context, index) {
        final widget = availableWidgets[index];
        final isEnabled = _enabledWidgets.contains(widget.title);

        return Card(
          key: ValueKey(widget.title),
          margin: const EdgeInsets.only(bottom: 8),
          child: ListTile(
            leading: Icon(
              widget.icon,
              color: isEnabled
                  ? (this.widget.isCupertino
                        ? CupertinoColors.activeBlue
                        : Theme.of(context).colorScheme.primary)
                  : (this.widget.isCupertino
                        ? CupertinoColors.inactiveGray
                        : Colors.grey),
            ),
            title: Text(
              widget.title,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: isEnabled
                    ? (this.widget.isCupertino ? CupertinoColors.label : null)
                    : (this.widget.isCupertino
                          ? CupertinoColors.secondaryLabel
                          : Colors.grey),
              ),
            ),
            subtitle: Text(
              widget.description,
              style: TextStyle(
                fontSize: 12,
                color: this.widget.isCupertino
                    ? CupertinoColors.secondaryLabel
                    : Colors.black54,
              ),
            ),
            trailing: this.widget.isCupertino
                ? CupertinoSwitch(
                    value: isEnabled,
                    onChanged: (value) => _toggleWidget(widget.title),
                  )
                : Switch(
                    value: isEnabled,
                    onChanged: (value) => _toggleWidget(widget.title),
                  ),
            onTap: () => _toggleWidget(widget.title),
          ),
        );
      },
    );
  }

  void _onReorder(int oldIndex, int newIndex) {
    setState(() {
      if (newIndex > oldIndex) {
        newIndex -= 1;
      }
      final item = _enabledWidgets.removeAt(oldIndex);
      _enabledWidgets.insert(newIndex, item);
    });
  }

  void _toggleWidget(String widgetTitle) {
    setState(() {
      if (_enabledWidgets.contains(widgetTitle)) {
        _enabledWidgets.remove(widgetTitle);
      } else {
        _enabledWidgets.add(widgetTitle);
      }
    });
  }

  void _saveSettings() {
    widget.onWidgetsChanged(_enabledWidgets);
    Navigator.pop(context);

    // Başarı mesajı göster
    if (widget.isCupertino) {
      showCupertinoDialog(
        context: context,
        builder: (context) => CupertinoAlertDialog(
          title: const Text('Başarılı'),
          content: const Text('Ana sayfa ayarları kaydedildi!'),
          actions: [
            CupertinoDialogAction(
              child: const Text('Tamam'),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Ana sayfa ayarları kaydedildi!')),
      );
    }
  }
}
