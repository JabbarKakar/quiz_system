import 'package:hive/hive.dart';
import 'package:quiz_system/models/quiz_attempt_model.dart';

part 'hive_quiz_attempt_model.g.dart';

@HiveType(typeId: 2)
class HiveQuizAttempt {
  @HiveField(0)
  final int levelNumber;

  @HiveField(1)
  final DateTime dateTime;

  @HiveField(2)
  final int score;

  @HiveField(3)
  final int totalQuestions;

  @HiveField(4)
  final Map<String, bool> questionResults;

  HiveQuizAttempt({
    required this.levelNumber,
    required this.dateTime,
    required this.score,
    required this.totalQuestions,
    required this.questionResults,
  });

  // Convert from QuizAttempt to HiveQuizAttempt
  factory HiveQuizAttempt.fromQuizAttempt(QuizAttempt attempt) {
    return HiveQuizAttempt(
      levelNumber: attempt.levelNumber,
      dateTime: attempt.dateTime,
      score: attempt.score,
      totalQuestions: attempt.totalQuestions,
      questionResults: Map<String, bool>.from(attempt.questionResults),
    );
  }

  // Convert from HiveQuizAttempt to QuizAttempt
  QuizAttempt toQuizAttempt() {
    return QuizAttempt(
      levelNumber: levelNumber,
      dateTime: dateTime,
      score: score,
      totalQuestions: totalQuestions,
      questionResults: Map<String, bool>.from(questionResults),
    );
  }
}
