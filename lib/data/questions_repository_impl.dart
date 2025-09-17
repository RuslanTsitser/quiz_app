import 'package:cloud_firestore/cloud_firestore.dart';

import '../domain/models/question.dart';
import '../domain/questions_repository.dart';
import 'question_mapper.dart';

class QuestionsRepositoryImpl implements QuestionsRepository {
  @override
  Future<List<Question>> getQuestions(String id) async {
    final firestore = FirebaseFirestore.instance;
    final firestoreData = await firestore.collection('quizzes').doc(id).get();
    if (firestoreData.exists) {
      final data = firestoreData.data();
      final questionsData = data?['questions'] as List<dynamic>;
      final result = questionsData.map((question) => QuestionMapper.fromJson(question)).toList();
      return result;
    }
    return [];
  }
}
