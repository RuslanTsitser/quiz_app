import 'models/question.dart';

abstract class QuestionsRepository {
  Future<List<Question>> getQuestions(String id);
}
