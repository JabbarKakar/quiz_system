import 'package:hive/hive.dart';
import 'package:quiz_system/models/question_model.dart';

part 'hive_question_model.g.dart';

@HiveType(typeId: 0)
class HiveQuestion {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String question;

  @HiveField(2)
  final List<String> options;

  @HiveField(3)
  final int correctAnswerIndex;

  @HiveField(4)
  final String explanation;

  HiveQuestion({
    required this.id,
    required this.question,
    required this.options,
    required this.correctAnswerIndex,
    this.explanation = '',
  });

  // Convert from Question to HiveQuestion
  factory HiveQuestion.fromQuestion(Question question) {
    return HiveQuestion(
      id: question.id,
      question: question.question,
      options: question.options,
      correctAnswerIndex: question.correctAnswerIndex,
      explanation: question.explanation,
    );
  }

  // Convert from HiveQuestion to Question
  Question toQuestion() {
    return Question(
      id: id,
      question: question,
      options: options,
      correctAnswerIndex: correctAnswerIndex,
      explanation: explanation,
    );
  }
}
