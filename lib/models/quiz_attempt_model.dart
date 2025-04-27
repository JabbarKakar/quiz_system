class QuizAttempt {
  final int levelNumber;
  final DateTime dateTime;
  final int score;
  final int totalQuestions;
  final Map<String, bool> questionResults; // questionId -> correct/incorrect

  QuizAttempt({
    required this.levelNumber,
    required this.dateTime,
    required this.score,
    required this.totalQuestions,
    required this.questionResults,
  });
}