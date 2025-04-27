// screens/quiz_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quiz_system/provider/quiz_provider.dart';

class QuizScreen extends StatelessWidget {
  const QuizScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final quizProvider = Provider.of<QuizProvider>(context);
    final currentQuestion = quizProvider.currentQuestion;
    final currentQuestionIndex = quizProvider.currentQuestionIndex;
    final totalQuestions = quizProvider.currentLevel.questions.length;

    return WillPopScope(
      onWillPop: () async {
        // Show confirmation dialog
        final shouldPop = await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Quit Quiz?'),
            content: const Text('Your progress will be lost. Are you sure you want to quit?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('CANCEL'),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: const Text('QUIT'),
              ),
            ],
          ),
        );
        return shouldPop ?? false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('Level ${quizProvider.currentLevel.levelNumber}'),
          centerTitle: true,
        ),
        body: Column(
          children: [
            // Progress indicator
            LinearProgressIndicator(
              value: (currentQuestionIndex + 1) / totalQuestions,
              minHeight: 8,
              backgroundColor: Colors.grey.shade200,
              valueColor: AlwaysStoppedAnimation<Color>(
                Theme.of(context).colorScheme.primary,
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Question ${currentQuestionIndex + 1} of $totalQuestions',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    'Score: ${quizProvider.currentScore}',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            // Question
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
                        ),
                      ),
                      child: Text(
                        currentQuestion.question,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Options
                    ...List.generate(
                      currentQuestion.options.length,
                          (index) => _OptionItem(
                        option: currentQuestion.options[index],
                        optionLetter: String.fromCharCode(65 + index), // A, B, C, D
                        isSelected: quizProvider.currentAttemptResults.containsKey(currentQuestion.id) &&
                            index == currentQuestion.correctAnswerIndex,
                        isCorrect: quizProvider.currentAttemptResults.containsKey(currentQuestion.id) &&
                            index == currentQuestion.correctAnswerIndex,
                        isIncorrect: quizProvider.currentAttemptResults.containsKey(currentQuestion.id) &&
                            quizProvider.currentAttemptResults[currentQuestion.id] == false &&
                            index != currentQuestion.correctAnswerIndex,
                        onTap: () {
                          if (!quizProvider.currentAttemptResults.containsKey(currentQuestion.id)) {
                            quizProvider.answerQuestion(index);
                          }
                        },
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Explanation (only shown after answering)
                    if (quizProvider.currentAttemptResults.containsKey(currentQuestion.id))
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: Colors.grey.shade300),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Explanation:',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              currentQuestion.explanation,
                              style: const TextStyle(fontSize: 16),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            ),

            // Navigation buttons
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (currentQuestionIndex > 0)
                    ElevatedButton(
                      onPressed: () => quizProvider.previousQuestion(),
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Theme.of(context).colorScheme.primary,
                        backgroundColor: Colors.white,
                        side: BorderSide(
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                      child: const Text('Previous'),
                    )
                  else
                    const SizedBox(width: 100),

                  if (currentQuestionIndex < totalQuestions - 1)
                    ElevatedButton(
                      onPressed: quizProvider.currentAttemptResults.containsKey(currentQuestion.id)
                          ? () => quizProvider.nextQuestion()
                          : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        foregroundColor: Colors.white,
                      ),
                      child: const Text('Next'),
                    )
                  else
                    ElevatedButton(
                      onPressed: quizProvider.currentAttemptResults.containsKey(currentQuestion.id)
                          ? () {
                        quizProvider.finishQuiz();
                        Navigator.pushReplacementNamed(context, '/results');
                      }
                          : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                      ),
                      child: const Text('Finish'),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _OptionItem extends StatelessWidget {
  final String option;
  final String optionLetter;
  final bool isSelected;
  final bool isCorrect;
  final bool isIncorrect;
  final VoidCallback onTap;

  const _OptionItem({
    required this.option,
    required this.optionLetter,
    required this.isSelected,
    required this.isCorrect,
    required this.isIncorrect,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    Color backgroundColor;
    Color borderColor;
    Color textColor;

    if (isCorrect) {
      backgroundColor = Colors.green.shade100;
      borderColor = Colors.green;
      textColor = Colors.green.shade800;
    } else if (isIncorrect) {
      backgroundColor = Colors.red.shade100;
      borderColor = Colors.red;
      textColor = Colors.red.shade800;
    } else if (isSelected) {
      backgroundColor = Theme.of(context).colorScheme.primary.withOpacity(0.1);
      borderColor = Theme.of(context).colorScheme.primary;
      textColor = Theme.of(context).colorScheme.primary;
    } else {
      backgroundColor = Colors.white;
      borderColor = Colors.grey.shade300;
      textColor = Colors.black87;
    }

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(12),
          // border: Border.all
          border: Border.all(color: borderColor),
        ),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: borderColor.withOpacity(0.1),
                shape: BoxShape.circle,
                border: Border.all(color: borderColor),
              ),
              child: Center(
                child: Text(
                  optionLetter,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                option,
                style: TextStyle(
                  fontSize: 16,
                  color: textColor,
                ),
              ),
            ),
            if (isCorrect)
              const Icon(
                Icons.check_circle,
                color: Colors.green,
              )
            else if (isIncorrect)
              const Icon(
                Icons.cancel,
                color: Colors.red,
              ),
          ],
        ),
      ),
    );
  }
}