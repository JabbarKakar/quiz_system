
// screens/results_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quiz_system/provider/quiz_provider.dart';

class ResultsScreen extends StatelessWidget {
  const ResultsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final quizProvider = Provider.of<QuizProvider>(context);
    final level = quizProvider.currentLevel;
    final score = quizProvider.currentScore;
    final totalQuestions = level.questions.length;
    final correctAnswers = quizProvider.currentAttemptResults.values.where((v) => v).length;
    final percentage = (correctAnswers / totalQuestions) * 100;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: percentage >= 70 ? Colors.green : Colors.orange,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              child: Column(
                children: [
                  Text(
                    percentage >= 70 ? 'Congratulations!' : 'Quiz Completed',
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Text(
                        '${percentage.toStringAsFixed(0)}%',
                        style: TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                          color: percentage >= 70 ? Colors.green : Colors.orange,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Level ${level.levelNumber}',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Score: $score/${totalQuestions * 10}',
                    style: const TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '$correctAnswers of $totalQuestions questions answered correctly',
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ),

            // Results details
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Performance Summary',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Stats cards
                    Row(
                      children: [
                        Expanded(
                          child: _StatCard(
                            title: 'Correct',
                            value: correctAnswers,
                            icon: Icons.check_circle,
                            color: Colors.green,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _StatCard(
                            title: 'Incorrect',
                            value: totalQuestions - correctAnswers,
                            icon: Icons.cancel,
                            color: Colors.red,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _StatCard(
                            title: 'Score',
                            value: score,
                            icon: Icons.star,
                            color: Colors.amber,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),

                    // Message based on performance
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: percentage >= 70
                            ? Colors.green.withOpacity(0.1)
                            : Colors.orange.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: percentage >= 70 ? Colors.green : Colors.orange,
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            percentage >= 70 ? Icons.emoji_events : Icons.info,
                            size: 32,
                            color: percentage >= 70 ? Colors.green : Colors.orange,
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Text(
                              percentage >= 70
                                  ? 'Great job! You\'ve unlocked the next level.'
                                  : 'You need at least 70% to unlock the next level. Try again!',
                              style: TextStyle(
                                fontSize: 16,
                                color: percentage >= 70 ? Colors.green.shade800 : Colors.orange.shade800,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const Spacer(),

                    // Action buttons
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () {
                              Navigator.popUntil(context, ModalRoute.withName('/'));
                            },
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              side: BorderSide(
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                            child: const Text('Home'),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              if (percentage >= 70 && level.levelNumber < quizProvider.levels.length) {
                                // Go to next level
                                quizProvider.setCurrentLevel(level.levelNumber);
                                Navigator.pushReplacementNamed(context, '/quiz');
                              } else {
                                // Retry current level
                                quizProvider.setCurrentLevel(level.levelNumber - 1);
                                Navigator.pushReplacementNamed(context, '/quiz');
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              backgroundColor: Theme.of(context).colorScheme.primary,
                              foregroundColor: Colors.white,
                            ),
                            child: Text(percentage >= 70 ? 'Next Level' : 'Try Again'),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    Center(
                      child: TextButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/statistics');
                        },
                        child: const Text('View Detailed Statistics'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final int value;
  final IconData icon;
  final Color color;

  const _StatCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 28,
            color: color,
          ),
          const SizedBox(height: 8),
          Text(
            value.toString(),
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: TextStyle(
              fontSize: 14,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}