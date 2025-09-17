import 'package:flutter/material.dart';

import '../../domain/models/question.dart';
import '../../domain/questions_repository.dart';

class QuestionsNotifier with ChangeNotifier {
  final QuestionsRepository _questionsRepository;

  QuestionsNotifier({required QuestionsRepository questionsRepository}) : _questionsRepository = questionsRepository;

  final List<Question> _questions = [];

  List<Question> get questions => _questions;

  bool _isLoading = true;
  bool get isLoading => _isLoading;

  Future<void> getQuestions(String id) async {
    final questions = await _questionsRepository.getQuestions(id);
    _questions.clear();
    _questions.addAll(questions);
    _isLoading = false;
    notifyListeners();
  }
}
