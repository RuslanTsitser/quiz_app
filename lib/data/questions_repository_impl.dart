import '../domain/models/question.dart';
import '../domain/questions_repository.dart';
import 'quiz_data.dart';

class QuestionsRepositoryImpl implements QuestionsRepository {
  @override
  Future<List<Question>> getQuestions(String id) async {
    await Future.delayed(const Duration(seconds: 2));
    return QuizData.questions;
  }
}
