import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // ✅ Tam ekran için
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // ✅ Status bar'ı tamamen gizle
  SystemChrome.setEnabledSystemUIMode(
    SystemUiMode.immersiveSticky,
    overlays: [],
  );
  
  // Firebase'i başlat
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  // Authentication olmadan Firebase kullanıyoruz
  
  await initializeDateFormatting('tr_TR', null);
  runApp(const ProviderScope(child: MyDearDiaryApp()));
}

class MyDearDiaryApp extends StatelessWidget {
  const MyDearDiaryApp({super.key});

  @override
  Widget build(BuildContext context) {
    // ✅ Tam ekran MaterialApp
    return MaterialApp(
      title: 'MyDearDiary',
      debugShowCheckedModeBanner: false, // ✅ Debug banner'ı kaldır
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF6366F1), // Modern indigo
          brightness: Brightness.light,
        ),
        useMaterial3: true,
        scaffoldBackgroundColor: Colors.white, // ✅ Sade beyaz arka plan
        fontFamily: 'Inter',
        // ✅ Geliştirilmiş text theme
        textTheme: const TextTheme(
          displayLarge: TextStyle(
            fontFamily: 'Inter',
            fontWeight: FontWeight.w700,
            letterSpacing: -0.5,
          ),
          displayMedium: TextStyle(
            fontFamily: 'Inter',
            fontWeight: FontWeight.w600,
            letterSpacing: -0.3,
          ),
          displaySmall: TextStyle(
            fontFamily: 'Inter',
            fontWeight: FontWeight.w600,
            letterSpacing: -0.2,
          ),
          headlineLarge: TextStyle(
            fontFamily: 'Inter',
            fontWeight: FontWeight.w600,
            letterSpacing: -0.3,
          ),
          headlineMedium: TextStyle(
            fontFamily: 'Inter',
            fontWeight: FontWeight.w500,
            letterSpacing: -0.2,
          ),
          headlineSmall: TextStyle(
            fontFamily: 'Inter',
            fontWeight: FontWeight.w500,
            letterSpacing: -0.1,
          ),
          titleLarge: TextStyle(
            fontFamily: 'Inter',
            fontWeight: FontWeight.w600,
            letterSpacing: -0.2,
          ),
          titleMedium: TextStyle(
            fontFamily: 'Inter',
            fontWeight: FontWeight.w500,
            letterSpacing: -0.1,
          ),
          titleSmall: TextStyle(
            fontFamily: 'Inter',
            fontWeight: FontWeight.w500,
            letterSpacing: 0,
          ),
          bodyLarge: TextStyle(
            fontFamily: 'Inter',
            fontWeight: FontWeight.w400,
            letterSpacing: 0,
          ),
          bodyMedium: TextStyle(
            fontFamily: 'Inter',
            fontWeight: FontWeight.w400,
            letterSpacing: 0,
          ),
          bodySmall: TextStyle(
            fontFamily: 'Inter',
            fontWeight: FontWeight.w400,
            letterSpacing: 0,
          ),
          labelLarge: TextStyle(
            fontFamily: 'Inter',
            fontWeight: FontWeight.w500,
            letterSpacing: 0,
          ),
          labelMedium: TextStyle(
            fontFamily: 'Inter',
            fontWeight: FontWeight.w500,
            letterSpacing: 0,
          ),
          labelSmall: TextStyle(
            fontFamily: 'Inter',
            fontWeight: FontWeight.w500,
            letterSpacing: 0,
          ),
        ),
        // ✅ Sade beyaz app bar theme
        appBarTheme: const AppBarTheme(
          centerTitle: true,
          elevation: 0,
          backgroundColor: Colors.white, // ✅ Beyaz arka plan
          foregroundColor: Colors.black, // ✅ Siyah yazı/ikon
          surfaceTintColor: Colors.transparent,
          systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: Colors.white, // ✅ Beyaz status bar
            statusBarIconBrightness: Brightness.dark,
            statusBarBrightness: Brightness.light,
            systemNavigationBarColor: Colors.white,
            systemNavigationBarIconBrightness: Brightness.dark,
          ),
        ),
        // ✅ Geliştirilmiş card theme
        cardTheme: CardThemeData(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.zero, // Düz köşeler
          ),
          color: Colors.white,
          shadowColor: Colors.black.withOpacity(0.08),
          margin: EdgeInsets.zero,
        ),
      ),
      home: const HomeScreen(),
    );
  }
}
