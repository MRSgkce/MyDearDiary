import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class ProfileTab extends StatefulWidget {
  final bool isCupertino;

  const ProfileTab({super.key, this.isCupertino = false});

  @override
  State<ProfileTab> createState() => _ProfileTabState();
}

class _ProfileTabState extends State<ProfileTab> {
  String _userName = 'Kullanıcı';
  String _userEmail = 'kullanici@example.com';
  String _joinDate = 'Ocak 2024';

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildProfileHeader(context),
          const SizedBox(height: 24),
          _buildStatsSection(context),
          const SizedBox(height: 24),
          _buildSettingsSection(context),
          const SizedBox(height: 24),
          _buildAboutSection(context),
        ],
      ),
    );
  }

  Widget _buildProfileHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: widget.isCupertino
            ? CupertinoColors.systemBackground
            : Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: widget.isCupertino
            ? Border.all(color: CupertinoColors.separator)
            : null,
        boxShadow: widget.isCupertino
            ? null
            : [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
      ),
      child: Column(
        children: [
          CircleAvatar(
            radius: 50,
            backgroundColor: widget.isCupertino
                ? CupertinoColors.systemBlue
                : Theme.of(context).colorScheme.primary,
            child: Text(
              _userName[0].toUpperCase(),
              style: const TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            _userName,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: widget.isCupertino ? CupertinoColors.label : null,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            _userEmail,
            style: TextStyle(
              fontSize: 16,
              color: widget.isCupertino
                  ? CupertinoColors.secondaryLabel
                  : Colors.black54,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Üyelik: $_joinDate',
            style: TextStyle(
              fontSize: 14,
              color: widget.isCupertino
                  ? CupertinoColors.tertiaryLabel
                  : Colors.black38,
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: widget.isCupertino
                ? CupertinoButton.filled(
                    onPressed: _editProfile,
                    child: const Text('Profili Düzenle'),
                  )
                : ElevatedButton(
                    onPressed: _editProfile,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: const Text('Profili Düzenle'),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsSection(BuildContext context) {
    final stats = [
      {'label': 'Toplam Günlük', 'value': '47', 'icon': Icons.book},
      {
        'label': 'Günlük Seri',
        'value': '12',
        'icon': Icons.local_fire_department,
      },
      {'label': 'Toplam Kelime', 'value': '12.5K', 'icon': Icons.text_fields},
      {'label': 'Ortalama', 'value': '266', 'icon': Icons.trending_up},
    ];

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: widget.isCupertino
            ? CupertinoColors.systemBackground
            : Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: widget.isCupertino
            ? Border.all(color: CupertinoColors.separator)
            : null,
        boxShadow: widget.isCupertino
            ? null
            : [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'İstatistikler',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: widget.isCupertino ? CupertinoColors.label : null,
            ),
          ),
          const SizedBox(height: 16),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 1.8,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
            ),
            itemCount: stats.length,
            itemBuilder: (context, index) {
              final stat = stats[index];
              return Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: widget.isCupertino
                      ? CupertinoColors.systemGrey6
                      : Theme.of(
                          context,
                        ).colorScheme.surfaceVariant.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      stat['icon'] as IconData,
                      color: widget.isCupertino
                          ? CupertinoColors.systemBlue
                          : Theme.of(context).colorScheme.primary,
                      size: 20,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      stat['value'] as String,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: widget.isCupertino
                            ? CupertinoColors.label
                            : null,
                      ),
                    ),
                    Text(
                      stat['label'] as String,
                      style: TextStyle(
                        fontSize: 10,
                        color: widget.isCupertino
                            ? CupertinoColors.secondaryLabel
                            : Colors.black54,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsSection(BuildContext context) {
    final settingsItems = [
      {
        'title': 'Bildirimler',
        'subtitle': 'Hatırlatıcıları yönet',
        'icon': widget.isCupertino ? CupertinoIcons.bell : Icons.notifications,
      },
      {
        'title': 'Tema',
        'subtitle': 'Açık/Koyu tema',
        'icon': widget.isCupertino ? CupertinoIcons.sun_max : Icons.palette,
      },
      {
        'title': 'Yedekleme',
        'subtitle': 'Verilerinizi yedekleyin',
        'icon': widget.isCupertino ? CupertinoIcons.cloud : Icons.cloud_upload,
      },
      {
        'title': 'Gizlilik',
        'subtitle': 'Gizlilik ayarları',
        'icon': widget.isCupertino ? CupertinoIcons.lock : Icons.privacy_tip,
      },
    ];

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: widget.isCupertino
            ? CupertinoColors.systemBackground
            : Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: widget.isCupertino
            ? Border.all(color: CupertinoColors.separator)
            : null,
        boxShadow: widget.isCupertino
            ? null
            : [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Ayarlar',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: widget.isCupertino ? CupertinoColors.label : null,
            ),
          ),
          const SizedBox(height: 16),
          ...settingsItems
              .map(
                (item) => ListTile(
                  leading: Icon(
                    item['icon'] as IconData,
                    color: widget.isCupertino
                        ? CupertinoColors.systemBlue
                        : Theme.of(context).colorScheme.primary,
                  ),
                  title: Text(
                    item['title'] as String,
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: widget.isCupertino ? CupertinoColors.label : null,
                    ),
                  ),
                  subtitle: Text(
                    item['subtitle'] as String,
                    style: TextStyle(
                      fontSize: 12,
                      color: widget.isCupertino
                          ? CupertinoColors.secondaryLabel
                          : Colors.black54,
                    ),
                  ),
                  trailing: Icon(
                    widget.isCupertino
                        ? CupertinoIcons.chevron_right
                        : Icons.arrow_forward_ios,
                    size: 16,
                    color: widget.isCupertino
                        ? CupertinoColors.inactiveGray
                        : Colors.black54,
                  ),
                  onTap: () => _handleSettingTap(item['title'] as String),
                ),
              )
              .toList(),
        ],
      ),
    );
  }

  Widget _buildAboutSection(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: widget.isCupertino
            ? CupertinoColors.systemBackground
            : Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: widget.isCupertino
            ? Border.all(color: CupertinoColors.separator)
            : null,
        boxShadow: widget.isCupertino
            ? null
            : [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Hakkında',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: widget.isCupertino ? CupertinoColors.label : null,
            ),
          ),
          const SizedBox(height: 16),
          ListTile(
            leading: Icon(
              widget.isCupertino ? CupertinoIcons.info : Icons.info_outline,
              color: widget.isCupertino
                  ? CupertinoColors.systemBlue
                  : Theme.of(context).colorScheme.primary,
            ),
            title: const Text('Uygulama Versiyonu'),
            subtitle: const Text('1.0.0'),
            onTap: () {},
          ),
          ListTile(
            leading: Icon(
              widget.isCupertino
                  ? CupertinoIcons.heart
                  : Icons.favorite_outline,
              color: widget.isCupertino
                  ? CupertinoColors.systemRed
                  : Theme.of(context).colorScheme.secondary,
            ),
            title: const Text('Uygulamayı Beğen'),
            subtitle: const Text('App Store\'da değerlendirin'),
            onTap: () {},
          ),
          ListTile(
            leading: Icon(
              widget.isCupertino ? CupertinoIcons.share : Icons.share,
              color: widget.isCupertino
                  ? CupertinoColors.systemGreen
                  : Colors.green,
            ),
            title: const Text('Uygulamayı Paylaş'),
            subtitle: const Text('Arkadaşlarınızla paylaşın'),
            onTap: () {},
          ),
        ],
      ),
    );
  }

  void _editProfile() {
    // Profil düzenleme sayfası açılacak
    if (widget.isCupertino) {
      showCupertinoDialog(
        context: context,
        builder: (context) => CupertinoAlertDialog(
          title: const Text('Profil Düzenleme'),
          content: const Text('Bu özellik yakında eklenecek!'),
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
        const SnackBar(
          content: Text('Profil düzenleme özelliği yakında eklenecek!'),
        ),
      );
    }
  }

  void _handleSettingTap(String setting) {
    if (widget.isCupertino) {
      showCupertinoDialog(
        context: context,
        builder: (context) => CupertinoAlertDialog(
          title: Text(setting),
          content: const Text('Bu özellik yakında eklenecek!'),
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
        SnackBar(content: Text('$setting özelliği yakında eklenecek!')),
      );
    }
  }
}
