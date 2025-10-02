import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class ProfileTab extends StatelessWidget {
  final bool isCupertino;

  const ProfileTab({super.key, this.isCupertino = false});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profil Header
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: isCupertino
                    ? CupertinoColors.systemBackground
                    : Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(16),
                border: isCupertino
                    ? Border.all(color: CupertinoColors.separator)
                    : null,
              ),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundColor: isCupertino
                        ? CupertinoColors.systemBlue
                        : Theme.of(context).colorScheme.primary,
                    child: Text(
                      'K',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Kullanıcı',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: isCupertino ? CupertinoColors.label : null,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'kullanici@example.com',
                    style: TextStyle(
                      fontSize: 14,
                      color: isCupertino
                          ? CupertinoColors.secondaryLabel
                          : Colors.black54,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // İstatistikler
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: isCupertino
                    ? CupertinoColors.systemBackground
                    : Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(16),
                border: isCupertino
                    ? Border.all(color: CupertinoColors.separator)
                    : null,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'İstatistikler',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: isCupertino ? CupertinoColors.label : null,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: _buildStatItem('Günlük', '47', Icons.book),
                      ),
                      Expanded(
                        child: _buildStatItem(
                          'Seri',
                          '12',
                          Icons.local_fire_department,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: _buildStatItem('Olumlama', '28', Icons.star),
                      ),
                      Expanded(
                        child: _buildStatItem('İlham', '15', Icons.lightbulb),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Ayarlar
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isCupertino
                    ? CupertinoColors.systemBackground
                    : Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(16),
                border: isCupertino
                    ? Border.all(color: CupertinoColors.separator)
                    : null,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Ayarlar',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: isCupertino ? CupertinoColors.label : null,
                    ),
                  ),
                  const SizedBox(height: 8),
                  _buildSettingItem('Bildirimler', Icons.notifications),
                  _buildSettingItem('Tema', Icons.palette),
                  _buildSettingItem('Yedekleme', Icons.cloud_upload),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon) {
    return Container(
      margin: const EdgeInsets.all(4),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isCupertino ? CupertinoColors.systemGrey6 : Colors.grey.shade100,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            color: isCupertino ? CupertinoColors.systemBlue : Colors.blue,
            size: 20,
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: isCupertino ? CupertinoColors.label : null,
            ),
          ),
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              color: isCupertino
                  ? CupertinoColors.secondaryLabel
                  : Colors.black54,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingItem(String title, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(
            icon,
            color: isCupertino ? CupertinoColors.systemBlue : Colors.blue,
            size: 20,
          ),
          const SizedBox(width: 12),
          Text(
            title,
            style: TextStyle(
              fontSize: 14,
              color: isCupertino ? CupertinoColors.label : null,
            ),
          ),
          const Spacer(),
          Icon(
            isCupertino
                ? CupertinoIcons.chevron_right
                : Icons.arrow_forward_ios,
            size: 16,
            color: isCupertino ? CupertinoColors.inactiveGray : Colors.grey,
          ),
        ],
      ),
    );
  }
}

