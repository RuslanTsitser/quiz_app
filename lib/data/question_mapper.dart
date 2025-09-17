import '../domain/models/question.dart';

class QuestionMapper {
  static Question fromJson(Map<String, dynamic> json) {
    return Question(
      questionText: json['questionText'],
      options: (json['options'] is List) ? (json['options'] as List).map((e) => e.toString()).toList() : <String>[],
      correctAnswerIndexes: (json['correctAnswerIndexes'] is List)
          ? (json['correctAnswerIndexes'] as List).map((e) => (e as num).toInt()).toList()
          : <int>[],
    );
  }
}
