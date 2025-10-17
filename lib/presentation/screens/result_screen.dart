import 'package:flutter/material.dart';

import '../../domain/models/question.dart';
import '../../domain/models/quiz_result.dart';
import '../components/ant_design_components.dart';
import '../theme/ant_design_theme.dart';
import 'quiz_screen.dart';
import 'share_result_screen.dart';

class ResultScreen extends StatelessWidget {
  final QuizResult result;
  final List<Question> questions;
  final List<Set<int>> selectedAnswers;
  final String quizId;

  const ResultScreen({
    super.key,
    required this.result,
    required this.questions,
    required this.selectedAnswers,
    required this.quizId,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AntDesignTheme.backgroundColor,
      appBar: AppBar(
        title: const Text('Результаты квиза'),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Заголовочная карточка с результатом
            AntCard(
              padding: const EdgeInsets.all(32),
              child: Column(
                children: [
                  // Иконка результата
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      gradient: _getResultGradient(),
                      borderRadius: BorderRadius.circular(40),
                      boxShadow: AntDesignTheme.buttonShadow,
                    ),
                    child: Icon(
                      _getResultIcon(),
                      size: 40,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Оценка
                  Text(
                    result.grade,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                      color: _getResultColor(),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),

                  // Процент правильных ответов
                  Text(
                    '${result.percentage.toStringAsFixed(1)}%',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w700,
                      color: _getResultColor(),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Статистика
            AntCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Статистика',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AntDesignTheme.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 16),

                  Row(
                    children: [
                      Expanded(
                        child: AntStatistic(
                          title: 'Правильных',
                          value: result.correctAnswers.toString(),
                          valueColor: AntDesignTheme.successColor,
                        ),
                      ),
                      Expanded(
                        child: AntStatistic(
                          title: 'Неправильных',
                          value: result.wrongAnswers.toString(),
                          valueColor: AntDesignTheme.errorColor,
                        ),
                      ),
                      Expanded(
                        child: AntStatistic(
                          title: 'Всего',
                          value: result.totalQuestions.toString(),
                          valueColor: AntDesignTheme.primaryColor,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Детальный разбор
            AntCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Детальный разбор',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AntDesignTheme.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 16),

                  ...questions.asMap().entries.map((entry) {
                    final index = entry.key;
                    final question = entry.value;
                    final selectedAnswersForQuestion = index < selectedAnswers.length
                        ? selectedAnswers[index]
                        : <int>{};
                    return _buildQuestionCard(context, question, index + 1, selectedAnswersForQuestion);
                  }),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // Кнопки действий
            AntButton(
              text: 'Поделиться результатом',
              type: AntButtonType.primary,
              size: AntButtonSize.large,
              icon: Icons.share,
              block: true,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ShareResultScreen(
                      result: result,
                      quizId: quizId,
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 12),
            AntButton(
              text: 'Пройти квиз снова',
              type: AntButtonType.default_,
              size: AntButtonSize.large,
              icon: Icons.refresh,
              block: true,
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => QuizScreen(questions: questions, quizId: quizId),
                  ),
                );
              },
            ),
            const SizedBox(height: 12),
            AntButton(
              text: 'На главную',
              type: AntButtonType.default_,
              size: AntButtonSize.large,
              icon: Icons.home,
              block: true,
              onPressed: () {
                Navigator.pop(context);
              },
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  LinearGradient _getResultGradient() {
    if (result.percentage >= 90) return AntDesignTheme.successGradient;
    if (result.percentage >= 70) return AntDesignTheme.primaryGradient;
    if (result.percentage >= 50) return AntDesignTheme.warningGradient;
    return AntDesignTheme.errorGradient;
  }

  Widget _buildQuestionCard(BuildContext context, Question question, int questionNumber, Set<int> selectedAnswers) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AntDesignTheme.surfaceColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AntDesignTheme.borderColor),
        boxShadow: AntDesignTheme.cardShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Номер вопроса и текст
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: AntDesignTheme.primaryColor,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Center(
                  child: Text(
                    questionNumber.toString(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  question.questionText,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AntDesignTheme.textPrimary,
                    height: 1.4,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Варианты ответов
          ...question.options.asMap().entries.map((entry) {
            final index = entry.key;
            final option = entry.value;
            final isCorrect = question.correctAnswerIndexes.contains(index);
            final isSelected = selectedAnswers.contains(index);
            final isWrongSelected = isSelected && !isCorrect;

            Color backgroundColor;
            Color borderColor;
            Color textColor;
            Color circleColor;
            IconData? icon;

            if (isCorrect) {
              // Правильный ответ
              backgroundColor = AntDesignTheme.successColor.withOpacity(0.1);
              borderColor = AntDesignTheme.successColor.withOpacity(0.3);
              textColor = AntDesignTheme.successColor;
              circleColor = AntDesignTheme.successColor;
              icon = Icons.check_circle;
            } else if (isWrongSelected) {
              // Неправильно выбранный ответ
              backgroundColor = AntDesignTheme.errorColor.withOpacity(0.1);
              borderColor = AntDesignTheme.errorColor.withOpacity(0.3);
              textColor = AntDesignTheme.errorColor;
              circleColor = AntDesignTheme.errorColor;
              icon = Icons.cancel;
            } else {
              // Обычный ответ
              backgroundColor = AntDesignTheme.backgroundColor;
              borderColor = AntDesignTheme.borderColor;
              textColor = AntDesignTheme.textSecondary;
              circleColor = AntDesignTheme.borderColor;
            }

            return Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                color: backgroundColor,
                borderRadius: BorderRadius.circular(6),
                border: Border.all(
                  color: borderColor,
                  width: (isCorrect || isWrongSelected) ? 2 : 1,
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: circleColor,
                    ),
                    child: Center(
                      child: Text(
                        String.fromCharCode(65 + index), // A, B, C, D
                        style: TextStyle(
                          color: (isCorrect || isWrongSelected) ? Colors.white : AntDesignTheme.textSecondary,
                          fontWeight: FontWeight.bold,
                          fontSize: 10,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      option,
                      style: TextStyle(
                        color: textColor,
                        fontWeight: (isCorrect || isWrongSelected) ? FontWeight.w500 : FontWeight.normal,
                        fontSize: 13,
                      ),
                    ),
                  ),
                  if (icon != null)
                    Icon(
                      icon,
                      color: isCorrect ? AntDesignTheme.successColor : AntDesignTheme.errorColor,
                      size: 16,
                    ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  IconData _getResultIcon() {
    if (result.percentage >= 90) return Icons.emoji_events;
    if (result.percentage >= 70) return Icons.thumb_up;
    if (result.percentage >= 50) return Icons.sentiment_neutral;
    return Icons.sentiment_dissatisfied;
  }

  Color _getResultColor() {
    if (result.percentage >= 90) return Colors.amber;
    if (result.percentage >= 70) return Colors.green;
    if (result.percentage >= 50) return Colors.orange;
    return Colors.red;
  }
}
