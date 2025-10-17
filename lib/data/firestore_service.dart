import 'package:cloud_firestore/cloud_firestore.dart';

import '../domain/models/shared_result.dart';

class FirestoreService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Отправляет квиз с вопросами в Firestore
  static Future<void> uploadQuiz({
    required String quizId,
    required String quizTitle,
    required List<Map<String, dynamic>> questions,
  }) async {
    try {
      await _firestore.collection('quizzes').doc(quizId).set({
        'name': quizTitle,
        'questions': questions,
      });
    } catch (e) {
      throw Exception('Ошибка при загрузке квиза: $e');
    }
  }

  /// Сохраняет результат теста в Firestore
  static Future<void> saveSharedResult(SharedResult result) async {
    try {
      await _firestore.collection('shared_results').add(result.toMap());
    } catch (e) {
      throw Exception('Ошибка при сохранении результата: $e');
    }
  }
}
