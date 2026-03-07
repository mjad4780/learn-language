import '../../data/models/article_model.dart';

abstract class ArticlesState {
  const ArticlesState();
}

class ArticlesInitial extends ArticlesState {
  const ArticlesInitial();
}

class ArticlesLoading extends ArticlesState {
  const ArticlesLoading();
}

class ArticlesLoaded extends ArticlesState {
  final List<ArticleModel> articles;

  const ArticlesLoaded(this.articles);
}

class ArticlesError extends ArticlesState {
  final String message;

  const ArticlesError(this.message);
}
