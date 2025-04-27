
// screens/search_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quiz_system/models/level_model.dart';
import 'package:quiz_system/provider/quiz_provider.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final quizProvider = Provider.of<QuizProvider>(context, listen: false);
    _searchController.text = quizProvider.searchQuery;
    _searchController.addListener(() {
      quizProvider.setSearchQuery(_searchController.text);
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final quizProvider = Provider.of<QuizProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _searchController,
          decoration: InputDecoration(
            hintText: 'Search for quizzes...',
            border: InputBorder.none,
            suffixIcon: _searchController.text.isNotEmpty
                ? IconButton(
              icon: const Icon(Icons.clear),
              onPressed: () {
                _searchController.clear();
                quizProvider.setSearchQuery('');
              },
            )
                : null,
          ),
          autofocus: true,
        ),
      ),
      body: quizProvider.searchQuery.isEmpty
          ? const Center(
        child: Text(
          'Type to search for quizzes',
          style: TextStyle(
            color: Colors.grey,
            fontSize: 16,
          ),
        ),
      )
          : quizProvider.filteredLevels.isEmpty
          ? const Center(
        child: Text(
          'No quizzes found',
          style: TextStyle(
            color: Colors.grey,
            fontSize: 16,
          ),
        ),
      )
          : ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: quizProvider.filteredLevels.length,
        itemBuilder: (context, index) {
          final level = quizProvider.filteredLevels[index];
          return _SearchResultItem(
            level: level,
            onTap: () {
              if (!level.isLocked) {
                quizProvider.setCurrentLevel(level.levelNumber - 1);
                Navigator.pushNamed(context, '/quiz');
              }
            },
          );
        },
      ),
    );
  }
}

class _SearchResultItem extends StatelessWidget {
  final Level level;
  final VoidCallback onTap;

  const _SearchResultItem({
    required this.level,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: level.isLocked ? null : onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: level.isLocked
                      ? Colors.grey.shade200
                      : Theme.of(context).colorScheme.primary.withOpacity(0.1),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: level.isLocked
                        ? Colors.grey.shade400
                        : Theme.of(context).colorScheme.primary,
                  ),
                ),
                child: Center(
                  child: level.isLocked
                      ? const Icon(Icons.lock, color: Colors.grey)
                      : Text(
                    level.levelNumber.toString(),
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      level.title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      level.description,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (!level.isLocked) ...[
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(4),
                              child: LinearProgressIndicator(
                                value: level.completionPercentage / 100,
                                minHeight: 4,
                                backgroundColor: Colors.grey.shade200,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Theme.of(context).colorScheme.primary,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '${level.completionPercentage.toStringAsFixed(0)}%',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
              if (!level.isLocked)
                Icon(
                  Icons.chevron_right,
                  color: Theme.of(context).colorScheme.primary,
                ),
            ],
          ),
        ),
      ),
    );
  }
}