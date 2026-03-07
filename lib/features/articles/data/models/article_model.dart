class ArticleModel {
  final String id;
  final String title;
  final String content;
  final String? translation;
  final String difficulty;
  final bool isCustom;

  const ArticleModel({
    required this.id,
    required this.title,
    required this.content,
    this.translation,
    required this.difficulty,
    this.isCustom = false,
  });

  factory ArticleModel.fromJson(Map<String, dynamic> json) {
    return ArticleModel(
      id: json['id'] as String,
      title: json['title'] as String,
      content: json['content'] as String,
      translation: json['translation'] as String?,
      difficulty: json['difficulty'] as String,
      isCustom: json['isCustom'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'translation': translation,
      'difficulty': difficulty,
      'isCustom': isCustom,
    };
  }

  ArticleModel copyWith({
    String? id,
    String? title,
    String? content,
    String? translation,
    String? difficulty,
    bool? isCustom,
  }) {
    return ArticleModel(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      translation: translation ?? this.translation,
      difficulty: difficulty ?? this.difficulty,
      isCustom: isCustom ?? this.isCustom,
    );
  }
}
