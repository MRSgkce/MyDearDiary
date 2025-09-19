import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'dart:io';
import 'screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('tr_TR', null);
  runApp(const MyDearDiaryApp());
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
          primaryColor: Color(0xFF6B46C1),
          brightness: Brightness.light,
        ),
        home: const HomeScreen(),
      );
    } else {
      return MaterialApp(
        title: 'MyDearDiary',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF6B46C1), // Mor ton
            brightness: Brightness.light,
          ),
          useMaterial3: true,
          appBarTheme: const AppBarTheme(centerTitle: true, elevation: 0),
          cardTheme: CardThemeData(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
        home: const HomeScreen(),
      );
    }
  }
}
