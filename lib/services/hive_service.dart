import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter/foundation.dart';
import 'package:quiz_system/models/hive/hive_level_model.dart';
import 'package:quiz_system/models/hive/hive_question_model.dart';
import 'package:quiz_system/models/hive/hive_quiz_attempt_model.dart';
import 'package:quiz_system/models/level_model.dart';
import 'package:quiz_system/models/quiz_attempt_model.dart';

class HiveService {
  static const String levelsBoxName = 'levels';
  static const String attemptsBoxName = 'attempts';
  static const String progressBoxName = 'progress';
  static bool _isInitialized = false;

  // Initialize Hive
  static Future<void> init() async {
    if (_isInitialized) return;
    
    try {
      // Initialize Hive
      await Hive.initFlutter();
      
      // Register adapters
      if (!Hive.isAdapterRegistered(0)) {
        Hive.registerAdapter(HiveQuestionAdapter());
      }
      
      if (!Hive.isAdapterRegistered(1)) {
        Hive.registerAdapter(HiveLevelAdapter());
      }
      
      if (!Hive.isAdapterRegistered(2)) {
        Hive.registerAdapter(HiveQuizAttemptAdapter());
      }
      
      // Open boxes
      await Hive.openBox<HiveLevel>(levelsBoxName);
      await Hive.openBox<HiveQuizAttempt>(attemptsBoxName);
      await Hive.openBox(progressBoxName);
      
      _isInitialized = true;
      debugPrint('Hive initialized successfully');
    } catch (e) {
      debugPrint('Error initializing Hive: $e');
      // Fall back to in-memory storage if Hive initialization fails
      _isInitialized = false;
    }
  }

  // Check if Hive is initialized
  static bool get isInitialized => _isInitialized;

  // Level operations
  static Future<void> saveLevels(List<Level> levels) async {
    if (!_isInitialized) return;
    
    try {
      final box = Hive.box<HiveLevel>(levelsBoxName);
      await box.clear();
      
      for (var level in levels) {
        await box.put(level.levelNumber.toString(), HiveLevel.fromLevel(level));
      }
    } catch (e) {
      debugPrint('Error saving levels: $e');
    }
  }

  static List<Level> getLevels() {
    if (!_isInitialized) return [];
    
    try {
      final box = Hive.box<HiveLevel>(levelsBoxName);
      return box.values.map((hiveLevel) => hiveLevel.toLevel()).toList()
        ..sort((a, b) => a.levelNumber.compareTo(b.levelNumber));
    } catch (e) {
      debugPrint('Error getting levels: $e');
      return [];
    }
  }

  // Quiz attempt operations
  static Future<void> saveAttempt(QuizAttempt attempt) async {
    if (!_isInitialized) return;
    
    try {
      final box = Hive.box<HiveQuizAttempt>(attemptsBoxName);
      await box.add(HiveQuizAttempt.fromQuizAttempt(attempt));
    } catch (e) {
      debugPrint('Error saving attempt: $e');
    }
  }

  static List<QuizAttempt> getAttempts() {
    if (!_isInitialized) return [];
    
    try {
      final box = Hive.box<HiveQuizAttempt>(attemptsBoxName);
      return box.values.map((hiveAttempt) => hiveAttempt.toQuizAttempt()).toList()
        ..sort((a, b) => b.dateTime.compareTo(a.dateTime)); // Sort by most recent
    } catch (e) {
      debugPrint('Error getting attempts: $e');
      return [];
    }
  }

  // Progress operations
  static Future<void> saveCurrentLevelIndex(int levelIndex) async {
    if (!_isInitialized) return;
    
    try {
      final box = Hive.box(progressBoxName);
      await box.put('currentLevelIndex', levelIndex);
    } catch (e) {
      debugPrint('Error saving current level index: $e');
    }
  }

  static int getCurrentLevelIndex() {
    if (!_isInitialized) return 0;
    
    try {
      final box = Hive.box(progressBoxName);
      return box.get('currentLevelIndex', defaultValue: 0);
    } catch (e) {
      debugPrint('Error getting current level index: $e');
      return 0;
    }
  }

  // Statistics operations
  static Future<void> saveStatistics({
    required int totalQuestionsAnswered,
    required int totalScore,
  }) async {
    if (!_isInitialized) return;
    
    try {
      final box = Hive.box(progressBoxName);
      await box.put('totalQuestionsAnswered', totalQuestionsAnswered);
      await box.put('totalScore', totalScore);
    } catch (e) {
      debugPrint('Error saving statistics: $e');
    }
  }

  static Map<String, dynamic> getStatistics() {
    if (!_isInitialized) {
      return {
        'totalQuestionsAnswered': 0,
        'totalScore': 0,
      };
    }
    
    try {
      final box = Hive.box(progressBoxName);
      return {
        'totalQuestionsAnswered': box.get('totalQuestionsAnswered', defaultValue: 0),
        'totalScore': box.get('totalScore', defaultValue: 0),
      };
    } catch (e) {
      debugPrint('Error getting statistics: $e');
      return {
        'totalQuestionsAnswered': 0,
        'totalScore': 0,
      };
    }
  }

  // Clear all data (for testing or reset functionality)
  static Future<void> clearAll() async {
    if (!_isInitialized) return;
    
    try {
      await Hive.box<HiveLevel>(levelsBoxName).clear();
      await Hive.box<HiveQuizAttempt>(attemptsBoxName).clear();
      await Hive.box(progressBoxName).clear();
    } catch (e) {
      debugPrint('Error clearing data: $e');
    }
  }
}
