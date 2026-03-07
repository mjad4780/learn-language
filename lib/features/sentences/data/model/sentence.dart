/// Model representing an English learning sentence with Arabic translation.
class Sentence {
  final int id;
  final String english;
  final String arabic;
  final bool isLearned;

  const Sentence({
    required this.id,
    required this.english,
    required this.arabic,
    this.isLearned = false,
  });

  factory Sentence.fromJson(Map<String, dynamic> json) {
    return Sentence(
      id: json['id'] as int,
      english: json['english'] as String,
      arabic: json['arabic'] as String,
    );
  }

  Sentence copyWith({bool? isLearned}) {
    return Sentence(
      id: id,
      english: english,
      arabic: arabic,
      isLearned: isLearned ?? this.isLearned,
    );
  }
}
