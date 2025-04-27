// providers/quiz_provider.dart
import 'package:flutter/cupertino.dart';
import 'package:quiz_system/models/level_model.dart';
import 'package:quiz_system/models/question_model.dart';
import 'package:quiz_system/models/quiz_attempt_model.dart';
import 'package:quiz_system/services/hive_service.dart';

class QuizProvider with ChangeNotifier {
  List<Level> _levels = [];
  List<QuizAttempt> _attempts = [];
  int _currentLevelIndex = 0;
  int _currentQuestionIndex = 0;
  Map<String, bool> _currentAttemptResults = {};
  int _currentScore = 0;
  String _searchQuery = '';

  QuizProvider() {
    _loadData();
  }

  // Getters
  List<Level> get levels => _levels;
  List<QuizAttempt> get attempts => _attempts;
  int get currentLevelIndex => _currentLevelIndex;
  int get currentQuestionIndex => _currentQuestionIndex;
  Level get currentLevel => _levels[_currentLevelIndex];
  Question get currentQuestion => currentLevel.questions[_currentQuestionIndex];
  int get currentScore => _currentScore;
  Map<String, bool> get currentAttemptResults => _currentAttemptResults;
  String get searchQuery => _searchQuery;

  List<Level> get filteredLevels {
    if (_searchQuery.isEmpty) return _levels;

    return _levels.where((level) =>
    level.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
        level.description.toLowerCase().contains(_searchQuery.toLowerCase())
    ).toList();
  }

  // Total statistics
  int get totalQuestionsAnswered =>
      _levels.fold(0, (sum, level) => sum + level.questionsAnswered);

  int get totalQuestions =>
      _levels.fold(0, (sum, level) => sum + level.questions.length);

  double get totalCompletionPercentage =>
      totalQuestions == 0 ? 0 : (totalQuestionsAnswered / totalQuestions) * 100;

  int get totalScore =>
      _levels.fold(0, (sum, level) => sum + level.highScore);

  int get maxPossibleScore =>
      _levels.fold(0, (sum, level) => sum + level.questions.length * 10);

  // Load data from Hive
  Future<void> _loadData() async {
    // Try to load saved levels
    final savedLevels = HiveService.getLevels();
    
    if (savedLevels.isNotEmpty) {
      _levels = savedLevels;
    } else {
      // Initialize with default levels if none are saved
      _initializeLevels();
      // Save the initialized levels if Hive is initialized
      if (HiveService.isInitialized) {
        await HiveService.saveLevels(_levels);
      }
    }
    
    // Load attempts
    _attempts = HiveService.getAttempts();
    
    // Load current level index
    _currentLevelIndex = HiveService.getCurrentLevelIndex();
    
    notifyListeners();
  }

  // Save all data to Hive
  Future<void> _saveData() async {
    if (!HiveService.isInitialized) return;
    
    await HiveService.saveLevels(_levels);
    await HiveService.saveCurrentLevelIndex(_currentLevelIndex);
    await HiveService.saveStatistics(
      totalQuestionsAnswered: totalQuestionsAnswered,
      totalScore: totalScore,
    );
  }

  // Methods
  void setCurrentLevel(int levelIndex) {
    _currentLevelIndex = levelIndex;
    _currentQuestionIndex = 0;
    _currentScore = 0;
    _currentAttemptResults = {};
    HiveService.saveCurrentLevelIndex(_currentLevelIndex);
    notifyListeners();
  }

  void nextQuestion() {
    if (_currentQuestionIndex < currentLevel.questions.length - 1) {
      _currentQuestionIndex++;
      notifyListeners();
    }
  }

  void previousQuestion() {
    if (_currentQuestionIndex > 0) {
      _currentQuestionIndex--;
      notifyListeners();
    }
  }

  void answerQuestion(int selectedAnswerIndex) {
    final question = currentQuestion;
    final isCorrect = selectedAnswerIndex == question.correctAnswerIndex;

    // Add to results
    _currentAttemptResults[question.id] = isCorrect;

    // Update score (10 points for correct answer)
    if (isCorrect) {
      _currentScore += 10;
    }

    // Mark question as answered if not already
    if (currentLevel.questionsAnswered < currentLevel.questions.length) {
      currentLevel.questionsAnswered++;
    }

    // Unlock next level if this is the last question and at least 70% correct
    if (_currentQuestionIndex == currentLevel.questions.length - 1 &&
        _currentLevelIndex < _levels.length - 1) {
      final percentageCorrect = (_currentScore / (currentLevel.questions.length * 10)) * 100;
      if (percentageCorrect >= 70) {
        _levels[_currentLevelIndex + 1].isLocked = false;
      }
    }

    // Save progress
    _saveData();
    
    notifyListeners();
  }

  Future<void> finishQuiz() async {
    // Update high score if current score is higher
    if (_currentScore > currentLevel.highScore) {
      currentLevel.highScore = _currentScore;
    }

    // Create quiz attempt
    final attempt = QuizAttempt(
      levelNumber: currentLevel.levelNumber,
      dateTime: DateTime.now(),
      score: _currentScore,
      totalQuestions: currentLevel.questions.length,
      questionResults: Map.from(_currentAttemptResults),
    );

    // Add attempt to history
    _attempts.add(attempt);
    
    // Save attempt to Hive
    await HiveService.saveAttempt(attempt);
    
    // Save updated level data
    await _saveData();

    notifyListeners();
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void _initializeLevels() {
    _levels = List.generate(50, (levelIndex) {
      return Level(
        levelNumber: levelIndex + 1,
        title: 'Level ${levelIndex + 1}',
        description: 'This is a description for Level ${levelIndex + 1}',
        questions: _generateQuestionsForLevel(levelIndex + 1),
        isLocked: levelIndex > 0, // First level is unlocked
      );
    });
  }

  List<Question> _generateQuestionsForLevel(int levelNumber) {
    // In a real app, you would load these from a database or API
    return List.generate(50, (questionIndex) {
      return Question(
        id: 'L${levelNumber}Q${questionIndex + 1}',
        question: 'Question ${questionIndex + 1} for Level $levelNumber?',
        options: [
          'Option A',
          'Option B',
          'Option C',
          'Option D',
        ],
        correctAnswerIndex: (questionIndex % 4), // Alternates between 0, 1, 2, 3
        explanation: 'This is the explanation for Question ${questionIndex + 1}',
      );
    });
  }
  
  // Reset all progress (for testing)
  Future<void> resetProgress() async {
    await HiveService.clearAll();
    _initializeLevels();
    _currentLevelIndex = 0;
    _currentQuestionIndex = 0;
    _currentScore = 0;
    _currentAttemptResults = {};
    _attempts.clear();
    await _saveData();
    notifyListeners();
  }
}