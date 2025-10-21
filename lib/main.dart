import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Firebase'i başlat
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MyDearDiary',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
        scaffoldBackgroundColor: Colors.white,
        fontFamily: 'Inter',
      ),
      home: const InspirationScreen(),
    );
  }
}

class InspirationScreen extends StatefulWidget {
  const InspirationScreen({super.key});

  @override
  State<InspirationScreen> createState() => _InspirationScreenState();
}

class _InspirationScreenState extends State<InspirationScreen> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // ✅ Top App Bar
          SafeArea(
            bottom: false,
            child: _buildTopBar(context),
          ),
          
          // ✅ Main Content
          Expanded(
            child: _buildContentForTab(context, _selectedIndex),
          ),
          
          // ✅ Bottom Navigation
          _buildBottomNavigation(context),
        ],
      ),
    );
  }

  /// ✅ Tab içeriği
  Widget _buildContentForTab(BuildContext context, int index) {
    switch (index) {
      case 0:
        return _buildMainContent(context); // İlham
      case 1:
        return _buildMoodContent(context); // Ruh Hali
      case 2:
        return _buildMeditationContent(context); // Meditasyon
      case 3:
        return _buildProfileContent(context); // Profil
      default:
        return _buildMainContent(context);
    }
  }

  /// ✅ Mood Content - Resimdeki gibi
  Widget _buildMoodContent(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          
          // ✅ Başlık
          Text(
            'Bugün Nasıl Hissediyorsun?',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade800,
            ),
          ),
          
          const SizedBox(height: 8),
          
          Text(
            'halini seç ve kaydet',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey.shade600,
            ),
          ),
          
          const SizedBox(height: 30),
          
          // ✅ Mood Grid
          _buildMoodGrid(context),
          
          const SizedBox(height: 40),
          
          // ✅ Journal Prompts
          _buildJournalPrompts(context),
          
          const SizedBox(height: 30),
          
          // ✅ Save Button
          _buildSaveButton(context),
          
          const SizedBox(height: 40),
          
          // ✅ Past Records
          _buildPastRecords(context),
          
          const SizedBox(height: 100), // Bottom padding
        ],
      ),
    );
  }

  /// ✅ Meditation Content
  Widget _buildMeditationContent(BuildContext context) {
    return const Center(
      child: Text(
        'Meditasyon Sayfası',
        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
      ),
    );
  }

  /// ✅ Profile Content
  Widget _buildProfileContent(BuildContext context) {
    return const Center(
      child: Text(
        'Profil Sayfası',
        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
      ),
    );
  }

  /// ✅ Mood Grid - Resimdeki gibi
  Widget _buildMoodGrid(BuildContext context) {
    final moods = [
      {'icon': Icons.wb_sunny, 'label': 'Mutlu', 'color': Colors.yellow.shade300},
      {'icon': Icons.favorite_border, 'label': 'Sevgi Dolu', 'color': Colors.pink.shade300},
      {'icon': Icons.auto_awesome, 'label': 'Enerjik', 'color': Colors.purple.shade300},
      {'icon': Icons.sentiment_neutral, 'label': 'Normal', 'color': Colors.grey.shade200},
      {'icon': Icons.cloud, 'label': 'Hüzünlü', 'color': Colors.blue.shade300},
      {'icon': Icons.sentiment_dissatisfied, 'label': 'Stresli', 'color': Colors.red.shade300},
      {'icon': Icons.nightlight_round, 'label': 'Yorgun', 'color': Colors.indigo.shade300},
      {'icon': Icons.sentiment_satisfied, 'label': 'Huzurlu', 'color': Colors.green.shade300},
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 0.8,
      ),
      itemCount: moods.length,
      itemBuilder: (context, index) {
        final mood = moods[index];
        return GestureDetector(
          onTap: () {
            // Mood seçimi
          },
          child: Container(
            decoration: BoxDecoration(
              color: mood['color'] as Color,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  mood['icon'] as IconData,
                  size: 30,
                  color: Colors.white,
                ),
                const SizedBox(height: 8),
                Text(
                  mood['label'] as String,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  /// ✅ Journal Prompts - Resimdeki gibi
  Widget _buildJournalPrompts(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ✅ İlk prompt
        Text(
          'Bugün neyi iyi yaptım? ✨',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.grey.shade800,
          ),
        ),
        
        const SizedBox(height: 12),
        
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey.shade50,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: Text(
            'Bugün başardığın şeyleri yaz...',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade500,
            ),
          ),
        ),
        
        const SizedBox(height: 24),
        
        // ✅ İkinci prompt
        Text(
          'Neyi geliştirebilirim? 💭',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.grey.shade800,
          ),
        ),
        
        const SizedBox(height: 12),
        
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey.shade50,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: Text(
            'Geliştirebileceğin alanları düşün...',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade500,
            ),
          ),
        ),
      ],
    );
  }

  /// ✅ Save Button - Resimdeki gibi
  Widget _buildSaveButton(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 50,
      decoration: BoxDecoration(
        color: Colors.grey.shade900,
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Center(
        child: Text(
          'Kaydet',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  /// ✅ Past Records - Resimdeki gibi
  Widget _buildPastRecords(BuildContext context) {
    final records = [
      {'emoji': '😊', 'mood': 'Mutlu', 'date': '20 Eki'},
      {'emoji': '😌', 'mood': 'Huzurlu', 'date': '19 Eki'},
      {'emoji': '✨', 'mood': 'Enerjik', 'date': '18 Eki'},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Geçmiş Kayıtlar',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.grey.shade800,
          ),
        ),
        
        const SizedBox(height: 16),
        
        ...records.map((record) => Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Text(
                record['emoji']!,
                style: const TextStyle(fontSize: 24),
              ),
              const SizedBox(width: 12),
              Text(
                record['mood']!,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey.shade800,
                ),
              ),
              const Spacer(),
              Text(
                record['date']!,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ),
        )).toList(),
      ],
    );
  }

  /// ✅ Top App Bar - Resimdeki gibi
  Widget _buildTopBar(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          // Lightbulb button
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.grey.shade300, width: 1),
            ),
            child: Icon(
              Icons.lightbulb_outline,
              size: 20,
              color: Colors.grey.shade700,
            ),
          ),
        ],
      ),
    );
  }

  /// ✅ Main Content - Resimdeki gibi
  Widget _buildMainContent(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // ✅ Quote Icon - Resimdeki gibi
          Stack(
            children: [
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(50),
                ),
                child: Icon(
                  Icons.format_quote,
                  size: 50,
                  color: Colors.grey.shade400,
                ),
              ),
              // Preview overlay
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                bottom: 0,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey.shade800,
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: Center(
                    child: Text(
                      'Preview',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 40),
          
          // ✅ Quote Text
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Text(
              '"sen nasıl bakarsan onu görürsün"',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w600,
                height: 1.4,
                color: Colors.grey.shade800,
                letterSpacing: -0.5,
              ),
            ),
          ),
          
          const SizedBox(height: 30),
          
          // ✅ Author
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(
              '— Sen',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.grey.shade700,
              ),
            ),
          ),
          
          const SizedBox(height: 50),
          
          // ✅ Action Buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildActionButton(Icons.delete_outline),
              const SizedBox(width: 30),
              _buildActionButton(Icons.favorite_border),
              const SizedBox(width: 30),
              _buildActionButton(Icons.copy),
            ],
          ),
          
          const SizedBox(height: 40),
          
          // ✅ Scroll Button
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.grey.shade800,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Kaydır',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(width: 8),
                Icon(
                  Icons.arrow_downward,
                  color: Colors.white,
                  size: 16,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// ✅ Action Button - Resimdeki gibi
  Widget _buildActionButton(IconData icon) {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: Colors.grey.shade300, width: 1),
      ),
      child: Icon(
        icon,
        size: 24,
        color: Colors.grey.shade700,
      ),
    );
  }

  /// ✅ Bottom Navigation - Resimdeki gibi
  Widget _buildBottomNavigation(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        top: 10,
        bottom: MediaQuery.of(context).padding.bottom + 10,
        left: 20,
        right: 20,
      ),
      decoration: BoxDecoration(
        color: Colors.grey.shade900,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavItem(Icons.lightbulb, 'İlham', 0),
          _buildNavItem(Icons.favorite_border, 'Ruh Hali', 1),
          _buildNavItem(Icons.self_improvement, 'Meditasyon', 2),
          _buildNavItem(Icons.person_outline, 'Profil', 3),
        ],
      ),
    );
  }

  /// ✅ Navigation Item - Resimdeki gibi
  Widget _buildNavItem(IconData icon, String label, int index) {
    final isSelected = _selectedIndex == index;
    
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedIndex = index;
        });
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: isSelected ? Colors.grey.shade300 : Colors.transparent,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Icon(
              icon,
              size: 20,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}