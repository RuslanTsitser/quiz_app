import 'package:flutter/material.dart';

import '../../domain/models/question.dart';
import '../../domain/models/quiz_result.dart';
import 'quiz_screen.dart';

class ResultScreen extends StatelessWidget {
  final QuizResult result;
  final List<Question> questions;

  const ResultScreen({super.key, required this.result, required this.questions});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Результаты квиза'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Иконка результата
            Icon(_getResultIcon(), size: 100, color: _getResultColor()),
            const SizedBox(height: 24),

            // Оценка
            Text(
              result.grade,
              style: Theme.of(
                context,
              ).textTheme.headlineLarge?.copyWith(color: _getResultColor(), fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),

            // Процент правильных ответов
            Text(
              '${result.percentage.toStringAsFixed(1)}%',
              style: Theme.of(
                context,
              ).textTheme.displayMedium?.copyWith(color: _getResultColor(), fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),

            // Детальная статистика
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Theme.of(context).colorScheme.outline.withOpacity(0.3)),
              ),
              child: Column(
                children: [
                  _buildStatRow(context, 'Правильных ответов', result.correctAnswers.toString(), Colors.green),
                  const SizedBox(height: 12),
                  _buildStatRow(context, 'Неправильных ответов', result.wrongAnswers.toString(), Colors.red),
                  const SizedBox(height: 12),
                  _buildStatRow(
                    context,
                    'Всего вопросов',
                    result.totalQuestions.toString(),
                    Theme.of(context).colorScheme.primary,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),

            // Кнопки действий
            ElevatedButton.icon(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => QuizScreen(questions: questions),
                  ),
                );
              },
              icon: const Icon(Icons.refresh),
              label: const Text('Пройти квиз снова'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 12),
            OutlinedButton.icon(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(Icons.home),
              label: const Text('На главную'),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatRow(BuildContext context, String label, String value, Color color) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: Theme.of(context).textTheme.bodyLarge),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: color.withOpacity(0.3)),
          ),
          child: Text(
            value,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: color, fontWeight: FontWeight.bold),
          ),
        ),
      ],
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
