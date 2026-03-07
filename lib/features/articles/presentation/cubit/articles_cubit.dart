import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/di/injection.dart';

import '../../data/models/article_model.dart';
import '../../data/repos/article_repository.dart';
import 'articles_state.dart';

class ArticlesCubit extends Cubit<ArticlesState> {
  final ArticleRepository _repository = getIt<ArticleRepository>();

  ArticlesCubit() : super(const ArticlesInitial());

  Future<void> fetchArticles() async {
    emit(const ArticlesLoading());
    try {
      final articles = await _repository.getArticles();
      emit(ArticlesLoaded(articles));
    } catch (e) {
      emit(ArticlesError(e.toString()));
    }
  }

  Future<void> addArticle(ArticleModel article) async {
    try {
      await _repository.addArticle(article);
      await fetchArticles();
    } catch (e) {
      emit(ArticlesError(e.toString()));
    }
  }

  Future<void> editArticle(ArticleModel article) async {
    try {
      final state = this.state;
      if (state is ArticlesLoaded) {
        // Find index in custom articles list
        final customArticles = state.articles.where((a) => a.isCustom).toList();
        final indexInCustom = customArticles.indexWhere(
          (a) => a.id == article.id,
        );

        if (indexInCustom != -1) {
          await _repository.editArticle(indexInCustom, article);
          await fetchArticles();
        }
      }
    } catch (e) {
      emit(ArticlesError(e.toString()));
    }
  }

  Future<void> deleteArticle(String id) async {
    try {
      final state = this.state;
      if (state is ArticlesLoaded) {
        final customArticles = state.articles.where((a) => a.isCustom).toList();
        final indexInCustom = customArticles.indexWhere((a) => a.id == id);

        if (indexInCustom != -1) {
          await _repository.deleteArticle(indexInCustom);
          await fetchArticles();
        }
      }
    } catch (e) {
      emit(ArticlesError(e.toString()));
    }
  }
}
