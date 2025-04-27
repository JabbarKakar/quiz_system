// screens/level_select_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quiz_system/models/level_model.dart';
import 'package:quiz_system/provider/quiz_provider.dart';

class LevelSelectScreen extends StatelessWidget {
  const LevelSelectScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final quizProvider = Provider.of<QuizProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Level'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () => Navigator.pushNamed(context, '/search'),
          ),
        ],
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          childAspectRatio: 1,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
        ),
        itemCount: quizProvider.levels.length,
        itemBuilder: (context, index) {
          final level = quizProvider.levels[index];
          return _LevelCard(
            level: level,
            onTap: () {
              if (!level.isLocked) {
                quizProvider.setCurrentLevel(index);
                Navigator.pushNamed(context, '/quiz');
              }
            },
          );
        },
      ),
    );
  }
}

class _LevelCard extends StatelessWidget {
  final Level level;
  final VoidCallback onTap;

  const _LevelCard({
    required this.level,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: level.isLocked
              ? Colors.grey.shade200
              : Theme.of(context).colorScheme.primary.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: level.isLocked
                ? Colors.grey.shade400
                : Theme.of(context).colorScheme.primary,
            width: 2,
          ),
        ),
        child: Stack(
          children: [
            if (level.isLocked)
              const Center(
                child: Icon(
                  Icons.lock,
                  size: 32,
                  color: Colors.grey,
                ),
              )
            else
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      level.levelNumber.toString(),
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${level.completionPercentage.toStringAsFixed(0)}%',
                      style: TextStyle(
                        fontSize: 14,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ],
                ),
              ),
            if (level.highScore > 0 && !level.isLocked)
              Positioned(
                top: 8,
                right: 8,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '${level.highScore}',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}