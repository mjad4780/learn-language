import 'package:flutter/material.dart';

import '../../../../core/theme.dart';
import '../../data/models/article_model.dart';

class ArticleDetailsScreen extends StatelessWidget {
  final ArticleModel article;

  const ArticleDetailsScreen({super.key, required this.article});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppTheme.backgroundGradient),
        child: SafeArea(
          child: Column(
            children: [
              const _DetailsAppBar(),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        article.title,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.accentColor,
                        ),
                      ),
                      const SizedBox(height: 24),
                      _SectionTitle(title: 'English'),
                      const SizedBox(height: 12),
                      Text(
                        article.content,
                        style: const TextStyle(
                          fontSize: 16,
                          height: 1.6,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 32),
                      if (article.translation != null &&
                          article.translation!.isNotEmpty) ...[
                        _SectionTitle(title: 'Arabic Translation'),
                        const SizedBox(height: 12),
                        Text(
                          article.translation!,
                          textDirection: TextDirection.rtl,
                          style: TextStyle(
                            fontSize: 16,
                            height: 1.6,
                            color: Colors.white.withValues(alpha: 0.9),
                          ),
                        ),
                        const SizedBox(height: 32),
                      ],
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DetailsAppBar extends StatelessWidget {
  const _DetailsAppBar();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(
              Icons.arrow_back_ios_new_rounded,
              color: Colors.white,
            ),
          ),
          const Expanded(
            child: Text(
              'Article Details',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(width: 48), // Balance for centering
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;

  const _SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 4,
          height: 18,
          decoration: BoxDecoration(
            color: AppTheme.accentColor,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          title,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
            color: Colors.white.withValues(alpha: 0.5),
          ),
        ),
      ],
    );
  }
}
