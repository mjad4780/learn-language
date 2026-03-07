import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme.dart';
import '../cubit/articles_cubit.dart';
import '../cubit/articles_state.dart';
import '../widgets/article_card.dart';
import 'add_edit_article_screen.dart';
import '../../../../core/di/injection.dart';

class ArticlesScreen extends StatelessWidget {
  const ArticlesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<ArticlesCubit>()..fetchArticles(),
      child: Builder(
        builder: (builderContext) => Scaffold(
          body: Container(
            decoration: const BoxDecoration(
              gradient: AppTheme.backgroundGradient,
            ),
            child: SafeArea(
              child: Column(
                children: [
                  const _CustomAppBar(),
                  Expanded(
                    child: BlocBuilder<ArticlesCubit, ArticlesState>(
                      builder: (blocContext, state) {
                        if (state is ArticlesLoading ||
                            state is ArticlesInitial) {
                          return const Center(
                            child: CircularProgressIndicator(
                              color: AppTheme.accentColor,
                            ),
                          );
                        } else if (state is ArticlesError) {
                          return Center(
                            child: Text(
                              'Error: ${state.message}',
                              style: const TextStyle(
                                color: AppTheme.errorColor,
                              ),
                            ),
                          );
                        } else if (state is ArticlesLoaded) {
                          if (state.articles.isEmpty) {
                            return Center(
                              child: Text(
                                'No articles found.',
                                style: TextStyle(
                                  color: Colors.white.withValues(alpha: 0.5),
                                ),
                              ),
                            );
                          }
                          return ListView.builder(
                            padding: const EdgeInsets.all(20),
                            itemCount: state.articles.length,
                            itemBuilder: (listContext, index) {
                              return ArticleCard(
                                article: state.articles[index],
                              );
                            },
                          );
                        }
                        return const SizedBox.shrink();
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              Navigator.push(
                builderContext,
                MaterialPageRoute(
                  builder: (routeContext) => BlocProvider.value(
                    value: BlocProvider.of<ArticlesCubit>(builderContext),
                    child: const AddEditArticleScreen(),
                  ),
                ),
              );
            },
            backgroundColor: AppTheme.accentColor,
            child: const Icon(Icons.add_rounded, color: Colors.white, size: 28),
          ),
        ),
      ),
    );
  }
}

class _CustomAppBar extends StatelessWidget {
  const _CustomAppBar();

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
              'English Articles',
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
