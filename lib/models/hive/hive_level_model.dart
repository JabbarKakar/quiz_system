import 'package:hive/hive.dart';
import 'package:quiz_system/models/level_model.dart';
import 'package:quiz_system/models/hive/hive_question_model.dart';

part 'hive_level_model.g.dart';

@HiveType(typeId: 1)
class HiveLevel {
  @HiveField(0)
  final int levelNumber;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final String description;

  @HiveField(3)
  final List<HiveQuestion> questions;

  @HiveField(4)
  bool isLocked;

  @HiveField(5)
  int highScore;

  @HiveField(6)
  int questionsAnswered;

  HiveLevel({
    required this.levelNumber,
    required this.title,
    required this.description,
    required this.questions,
    this.isLocked = true,
    this.highScore = 0,
    this.questionsAnswered = 0,
  });

  // Convert from Level to HiveLevel
  factory HiveLevel.fromLevel(Level level) {
    return HiveLevel(
      levelNumber: level.levelNumber,
      title: level.title,
      description: level.description,
      questions: level.questions.map((q) => HiveQuestion.fromQuestion(q)).toList(),
      isLocked: level.isLocked,
      highScore: level.highScore,
      questionsAnswered: level.questionsAnswered,
    );
  }

  // Convert from HiveLevel to Level
  Level toLevel() {
    return Level(
      levelNumber: levelNumber,
      title: title,
      description: description,
      questions: questions.map((q) => q.toQuestion()).toList(),
      isLocked: isLocked,
      highScore: highScore,
      questionsAnswered: questionsAnswered,
    );
  }

  double get completionPercentage =>
      questions.isEmpty ? 0 : (questionsAnswered / questions.length) * 100;
}
