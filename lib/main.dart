import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quiz_system/provider/quiz_provider.dart';
import 'package:quiz_system/services/hive_service.dart';
import 'package:quiz_system/view/Result/result_view.dart';
import 'package:quiz_system/view/home/home_view.dart';
import 'package:quiz_system/view/levelSelection/level_selection_view.dart';
import 'package:quiz_system/view/quiz/quiz_view.dart';
import 'package:quiz_system/view/search/search_view.dart';
import 'package:quiz_system/view/statistics/statistics_view.dart';
import 'package:flutter/services.dart';

void main() async {
  // Ensure Flutter is initialized before calling native code
  WidgetsFlutterBinding.ensureInitialized();
  
  // Add error handling for plugin initialization
  try {
    // Initialize Hive
    await HiveService.init();
  } catch (e) {
    // Log error but continue app execution
    debugPrint('Error initializing plugins: $e');
  }
  
  runApp(
    ChangeNotifierProvider(
      create: (context) => QuizProvider(),
      child: const QuizApp(),
    ),
  );
}

class QuizApp extends StatelessWidget {
  const QuizApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Quiz Master',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF6C63FF),
          brightness: Brightness.light,
        ),
        useMaterial3: true,
        fontFamily: 'Poppins',
      ),
      home: const HomeScreen(),
      routes: {
        '/level_select': (context) => const LevelSelectScreen(),
        '/quiz': (context) => const QuizScreen(),
        '/results': (context) => const ResultsScreen(),
        '/statistics': (context) => const StatisticsScreen(),
        '/search': (context) => const SearchScreen(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}
