import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme.dart';
import '../../data/models/article_model.dart';
import '../cubit/articles_cubit.dart';
import '../screens/add_edit_article_screen.dart';
import '../screens/article_details_screen.dart';

class ArticleCard extends StatelessWidget {
  final ArticleModel article;

  const ArticleCard({super.key, required this.article});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: AppTheme.cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ArticleDetailsScreen(article: article),
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        _DifficultyBadge(difficulty: article.difficulty),
                        if (article.isCustom) ...[
                          const SizedBox(width: 8),
                          _CustomBadge(),
                        ],
                      ],
                    ),
                    if (article.isCustom)
                      Row(
                        children: [
                          IconButton(
                            constraints: const BoxConstraints(),
                            padding: EdgeInsets.zero,
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => BlocProvider.value(
                                    value: context.read<ArticlesCubit>(),
                                    child: AddEditArticleScreen(
                                      article: article,
                                    ),
                                  ),
                                ),
                              );
                            },
                            icon: const Icon(
                              Icons.edit_rounded,
                              color: AppTheme.accentColor,
                              size: 20,
                            ),
                          ),
                          const SizedBox(width: 12),
                          IconButton(
                            constraints: const BoxConstraints(),
                            padding: EdgeInsets.zero,
                            onPressed: () {
                              context.read<ArticlesCubit>().deleteArticle(
                                article.id,
                              );
                            },
                            icon: const Icon(
                              Icons.delete_outline_rounded,
                              color: AppTheme.errorColor,
                              size: 20,
                            ),
                          ),
                        ],
                      )
                    else
                      const Icon(
                        Icons.arrow_forward_ios_rounded,
                        color: AppTheme.accentColor,
                        size: 14,
                      ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  article.title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  article.content,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white.withValues(alpha: 0.7),
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _CustomBadge extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: AppTheme.accentColor.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppTheme.accentColor.withValues(alpha: 0.5)),
      ),
      child: const Text(
        'Custom',
        style: TextStyle(
          color: AppTheme.accentColor,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class _DifficultyBadge extends StatelessWidget {
  final String difficulty;

  const _DifficultyBadge({required this.difficulty});

  @override
  Widget build(BuildContext context) {
    Color badgeColor;
    switch (difficulty.toLowerCase()) {
      case 'beginner':
        badgeColor = AppTheme.successColor;
        break;
      case 'intermediate':
        badgeColor = Colors.orange;
        break;
      case 'advanced':
        badgeColor = AppTheme.errorColor;
        break;
      default:
        badgeColor = AppTheme.accentColor;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: badgeColor.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: badgeColor.withValues(alpha: 0.5)),
      ),
      child: Text(
        difficulty,
        style: TextStyle(
          color: badgeColor,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
