import 'package:learn_english/features/articles/data/models/article_model.dart';
import '../../../../core/services/storage_service.dart';
import '../../../../core/di/injection.dart';

class ArticleRepository {
  final StorageService _storage = getIt<StorageService>();

  ArticleRepository();

  /// Fetches a list of articles (built-in mock + user-added).
  Future<List<ArticleModel>> getArticles() async {
    // Simulate network delay for built-in articles
    await Future.delayed(const Duration(milliseconds: 500));

    // Load custom articles
    final customRaw = _storage.getCustomArticles();
    final customArticles = customRaw
        .map((e) => ArticleModel.fromJson(e))
        .toList();

    return [...customArticles];
  }

  Future<void> addArticle(ArticleModel article) async {
    await _storage.addCustomArticle(article.toJson());
  }

  Future<void> editArticle(int indexInCustom, ArticleModel article) async {
    await _storage.editCustomArticle(indexInCustom, article.toJson());
  }

  Future<void> deleteArticle(int indexInCustom) async {
    await _storage.deleteCustomArticle(indexInCustom);
  }
}
