import 'package:flutter/material.dart';

import '../../domain/models/question.dart';
import '../../domain/models/quiz_result.dart';
import '../components/ant_design_components.dart';
import '../theme/ant_design_theme.dart';
import 'result_screen.dart';

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key, required this.questions, required this.quizId});
  final List<Question> questions;
  final String quizId;

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  int currentQuestionIndex = 0;
  int correctAnswers = 0;
  Set<int> selectedAnswerIndex = {};
  List<Set<int>> selectedAnswersForEachQuestion = [];

  void _selectAnswer(int answerIndex) {
    setState(() {
      if (selectedAnswerIndex.contains(answerIndex)) {
        selectedAnswerIndex.remove(answerIndex);
      } else {
        selectedAnswerIndex.add(answerIndex);
      }
    });
  }

  void _nextQuestion() {
    if (selectedAnswerIndex.isEmpty) return;

    // Сохраняем выбранные ответы для текущего вопроса
    selectedAnswersForEachQuestion.add(Set.from(selectedAnswerIndex));

    // Проверяем, правильно ли отвечен вопрос
    final question = widget.questions[currentQuestionIndex];
    final isCorrect = _isQuestionAnsweredCorrectly(question, selectedAnswerIndex);

    if (isCorrect) {
      correctAnswers++;
    }

    if (currentQuestionIndex < widget.questions.length - 1) {
      setState(() {
        currentQuestionIndex++;
        selectedAnswerIndex.clear();
      });
    } else {
      _finishQuiz();
    }
  }

  bool _isQuestionAnsweredCorrectly(Question question, Set<int> selectedAnswers) {
    // Проверяем, что выбраны все правильные ответы
    final correctAnswersSet = question.correctAnswerIndexes.toSet();
    if (!selectedAnswers.containsAll(correctAnswersSet)) {
      return false;
    }

    // Проверяем, что не выбраны неправильные ответы
    if (selectedAnswers.any((index) => !correctAnswersSet.contains(index))) {
      return false;
    }

    return true;
  }

  void _finishQuiz() {
    final result = QuizResult(
      totalQuestions: widget.questions.length,
      correctAnswers: correctAnswers,
      wrongAnswers: widget.questions.length - correctAnswers,
      percentage: (correctAnswers / widget.questions.length) * 100,
    );

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => ResultScreen(
          result: result,
          questions: widget.questions,
          selectedAnswers: selectedAnswersForEachQuestion,
          quizId: widget.quizId,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final question = widget.questions[currentQuestionIndex];
    final isLastQuestion = currentQuestionIndex == widget.questions.length - 1;
    final progress = (currentQuestionIndex + 1) / widget.questions.length;

    return Scaffold(
      backgroundColor: AntDesignTheme.backgroundColor,
      appBar: AppBar(
        title: const Text('Квиз'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Прогресс-бар
          Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Вопрос ${currentQuestionIndex + 1} из ${widget.questions.length}',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: AntDesignTheme.textPrimary,
                      ),
                    ),
                    Text(
                      '${(progress * 100).toInt()}%',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: AntDesignTheme.textSecondary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                AntProgress(
                  percent: progress * 100,
                  strokeColor: AntDesignTheme.primaryColor,
                  trailColor: AntDesignTheme.borderColor,
                ),
              ],
            ),
          ),
          
          // Основной контент
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Карточка с вопросом
                  AntCard(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 32,
                              height: 32,
                              decoration: BoxDecoration(
                                color: AntDesignTheme.primaryColor.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: const Icon(
                                Icons.help_outline,
                                size: 16,
                                color: AntDesignTheme.primaryColor,
                              ),
                            ),
                            const SizedBox(width: 12),
                            const Text(
                              'Вопрос',
                              style: TextStyle(
                                fontSize: 12,
                                color: AntDesignTheme.textSecondary,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          question.questionText,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: AntDesignTheme.textPrimary,
                            height: 1.4,
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Варианты ответов
                  const Text(
                    'Выберите правильные ответы:',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: AntDesignTheme.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 12),
                  
                  ...question.options.asMap().entries.map((entry) {
                    final index = entry.key;
                    final option = entry.value;
                    final isSelected = selectedAnswerIndex.contains(index);
                    
                    return Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      child: _buildAnswerOption(
                        context,
                        index,
                        option,
                        isSelected,
                        () => _selectAnswer(index),
                      ),
                    );
                  }),
                  
                  const SizedBox(height: 32),
                  
                  // Кнопка "Далее"
                  AntButton(
                    text: isLastQuestion ? 'Завершить квиз' : 'Следующий вопрос',
                    type: AntButtonType.primary,
                    size: AntButtonSize.large,
                    icon: isLastQuestion ? Icons.check : Icons.arrow_forward,
                    block: true,
                    onPressed: selectedAnswerIndex.isNotEmpty ? _nextQuestion : null,
                  ),
                  
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildAnswerOption(
    BuildContext context,
    int index,
    String option,
    bool isSelected,
    VoidCallback onTap,
  ) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isSelected 
                ? AntDesignTheme.primaryColor.withOpacity(0.1)
                : AntDesignTheme.surfaceColor,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isSelected 
                  ? AntDesignTheme.primaryColor
                  : AntDesignTheme.borderColor,
              width: isSelected ? 2 : 1,
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isSelected 
                      ? AntDesignTheme.primaryColor
                      : AntDesignTheme.borderColor,
                ),
                child: Center(
                  child: Text(
                    String.fromCharCode(65 + index), // A, B, C, D
                    style: TextStyle(
                      color: isSelected ? Colors.white : AntDesignTheme.textSecondary,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  option,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: isSelected ? FontWeight.w500 : FontWeight.normal,
                    color: isSelected 
                        ? AntDesignTheme.primaryColor
                        : AntDesignTheme.textPrimary,
                  ),
                ),
              ),
              if (isSelected)
                const Icon(
                  Icons.check_circle,
                  size: 20,
                  color: AntDesignTheme.primaryColor,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
