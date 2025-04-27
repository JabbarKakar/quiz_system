import 'package:quiz_system/models/question_model.dart';

class Level {
  final int levelNumber;
  final String title;
  final String description;
  final List<Question> questions;
  late final bool isLocked;
  int highScore;
  int questionsAnswered;

  Level({
    required this.levelNumber,
    required this.title,
    required this.description,
    required this.questions,
    this.isLocked = true,
    this.highScore = 0,
    this.questionsAnswered = 0,
  });

  double get completionPercentage =>
      questions.isEmpty ? 0 : (questionsAnswered / questions.length) * 100;
}