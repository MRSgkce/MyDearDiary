import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'dart:io';
import 'screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('tr_TR', null);
  runApp(const ProviderScope(child: MyDearDiaryApp()));
}

class MyDearDiaryApp extends StatelessWidget {
  const MyDearDiaryApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Platform kontrolü
    if (Platform.isIOS) {
      return CupertinoApp(
        title: 'MyDearDiary',
        theme: const CupertinoThemeData(
          primaryColor: Color(0xFFA68A38), // Golden brown
          brightness: Brightness.light,
          scaffoldBackgroundColor: Color(0xFFF2F2F2), // Soft grey
        ),
        home: const HomeScreen(),
      );
    } else {
      return MaterialApp(
        title: 'MyDearDiary',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFFA68A38), // Golden brown
            brightness: Brightness.light,
          ),
          useMaterial3: true,
          scaffoldBackgroundColor: const Color(0xFFF2F2F2), // Soft grey
          fontFamily: 'Inter',
          textTheme: const TextTheme(
            displayLarge: TextStyle(fontFamily: 'Inter'),
            displayMedium: TextStyle(fontFamily: 'Inter'),
            displaySmall: TextStyle(fontFamily: 'Inter'),
            headlineLarge: TextStyle(fontFamily: 'Inter'),
            headlineMedium: TextStyle(fontFamily: 'Inter'),
            headlineSmall: TextStyle(fontFamily: 'Inter'),
            titleLarge: TextStyle(fontFamily: 'Inter'),
            titleMedium: TextStyle(fontFamily: 'Inter'),
            titleSmall: TextStyle(fontFamily: 'Inter'),
            bodyLarge: TextStyle(fontFamily: 'Inter'),
            bodyMedium: TextStyle(fontFamily: 'Inter'),
            bodySmall: TextStyle(fontFamily: 'Inter'),
            labelLarge: TextStyle(fontFamily: 'Inter'),
            labelMedium: TextStyle(fontFamily: 'Inter'),
            labelSmall: TextStyle(fontFamily: 'Inter'),
          ),
          appBarTheme: const AppBarTheme(
            centerTitle: true,
            elevation: 0,
            backgroundColor: Color(0xFFF2F2F2), // Soft grey
          ),
          cardTheme: CardThemeData(
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
        ),
        home: const HomeScreen(),
      );
    }
  }
}
