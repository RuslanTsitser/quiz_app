import 'package:flutter/material.dart';

import '../models/question.dart';
import '../models/quiz_result.dart';
import 'result_screen.dart';

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key, required this.questions});
  final List<Question> questions;

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  int currentQuestionIndex = 0;
  int correctAnswers = 0;
  int? selectedAnswerIndex;

  void _selectAnswer(int answerIndex) {
    setState(() {
      selectedAnswerIndex = answerIndex;
    });
  }

  void _nextQuestion() {
    if (selectedAnswerIndex == null) return;

    if (widget.questions[currentQuestionIndex].correctAnswerIndexes.contains(selectedAnswerIndex)) {
      correctAnswers++;
    }

    if (currentQuestionIndex < widget.questions.length - 1) {
      setState(() {
        currentQuestionIndex++;
        selectedAnswerIndex = null;
      });
    } else {
      _finishQuiz();
    }
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
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final question = widget.questions[currentQuestionIndex];
    final isLastQuestion = currentQuestionIndex == widget.questions.length - 1;

    return Scaffold(
      appBar: AppBar(title: const Text('Квиз'), backgroundColor: Theme.of(context).colorScheme.inversePrimary),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Прогресс-бар
            LinearProgressIndicator(
              value: (currentQuestionIndex + 1) / widget.questions.length,
              backgroundColor: Colors.grey[300],
              valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).colorScheme.primary),
            ),
            const SizedBox(height: 20),

            // Номер вопроса
            Text(
              'Вопрос ${currentQuestionIndex + 1} из ${widget.questions.length}',
              style: Theme.of(context).textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),

            // Текст вопроса
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Theme.of(context).colorScheme.outline.withOpacity(0.3)),
              ),
              child: Text(
                question.questionText,
                style: Theme.of(context).textTheme.headlineSmall,
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 30),

            // Варианты ответов
            Expanded(
              child: ListView.builder(
                itemCount: question.options.length,
                itemBuilder: (context, index) {
                  final isSelected = selectedAnswerIndex == index;
                  final isCorrect = question.correctAnswerIndexes.contains(index);

                  Color? backgroundColor;
                  Color? borderColor;

                  if (isSelected) {
                    backgroundColor = isCorrect ? Colors.green.withOpacity(0.2) : Colors.red.withOpacity(0.2);
                    borderColor = isCorrect ? Colors.green : Colors.red;
                  } else {
                    backgroundColor = Theme.of(context).colorScheme.surface;
                    borderColor = Theme.of(context).colorScheme.outline.withOpacity(0.3);
                  }

                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    child: Material(
                      color: backgroundColor,
                      borderRadius: BorderRadius.circular(12),
                      child: InkWell(
                        onTap: () => _selectAnswer(index),
                        borderRadius: BorderRadius.circular(12),
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: borderColor, width: 2),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 24,
                                height: 24,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: isSelected ? (isCorrect ? Colors.green : Colors.red) : Colors.grey[300],
                                ),
                                child: Center(
                                  child: Text(
                                    String.fromCharCode(65 + index), // A, B, C, D
                                    style: TextStyle(
                                      color: isSelected ? Colors.white : Colors.black87,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Text(question.options[index], style: Theme.of(context).textTheme.bodyLarge),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            // Кнопка "Далее"
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: selectedAnswerIndex != null ? _nextQuestion : null,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: Text(
                isLastQuestion ? 'Завершить квиз' : 'Следующий вопрос',
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
