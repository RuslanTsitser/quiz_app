import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../components/ant_design_components.dart';
import '../state_manager/questions_notifier.dart';
import '../theme/ant_design_theme.dart';
import 'quiz_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key, required this.id});
  final String id;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AntDesignTheme.backgroundColor,
      appBar: AppBar(
        title: const Text('Квиз-приложение'),
        centerTitle: true,
      ),
      body: _Body(id: id),
    );
  }
}

class _Body extends StatefulWidget {
  const _Body({required this.id});
  final String id;

  @override
  State<_Body> createState() => _BodyState();
}

class _BodyState extends State<_Body> {
  @override
  void initState() {
    context.read<QuestionsNotifier>().getQuestions(widget.id);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<QuestionsNotifier>(
      builder: (context, notifier, child) {
        if (notifier.isLoading) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 16),
                Text(
                  'Загрузка вопросов...',
                  style: TextStyle(
                    color: AntDesignTheme.textSecondary,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          );
        }

        final questions = notifier.questions;
        return SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 20),

              // Заголовочная карточка
              AntCard(
                padding: const EdgeInsets.all(32),
                child: Column(
                  children: [
                    // Иконка квиза
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        gradient: AntDesignTheme.primaryGradient,
                        borderRadius: BorderRadius.circular(40),
                        boxShadow: AntDesignTheme.buttonShadow,
                      ),
                      child: const Icon(
                        Icons.quiz,
                        size: 40,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Заголовок
                    const Text(
                      'Добро пожаловать в квиз!',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                        color: AntDesignTheme.textPrimary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 12),

                    // Описание
                    Text(
                      'Проверьте свои знания в увлекательной викторине. '
                      'Ответьте на ${questions.length} вопросов и узнайте свой результат!',
                      style: const TextStyle(
                        fontSize: 14,
                        color: AntDesignTheme.textSecondary,
                        height: 1.5,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Информация о квизе
              AntCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Информация о квизе',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AntDesignTheme.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 16),

                    _buildInfoRow(
                      Icons.help_outline,
                      'Количество вопросов',
                      '${questions.length}',
                      AntDesignTheme.primaryColor,
                    ),
                    const SizedBox(height: 12),
                    _buildInfoRow(
                      Icons.timer_outlined,
                      'Время прохождения',
                      'Без ограничений',
                      AntDesignTheme.successColor,
                    ),
                    const SizedBox(height: 12),
                    _buildInfoRow(
                      Icons.emoji_events_outlined,
                      'Результат',
                      'Оценка в конце',
                      AntDesignTheme.warningColor,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Кнопка начала квиза
              AntButton(
                text: 'Начать квиз',
                type: AntButtonType.primary,
                size: AntButtonSize.large,
                icon: Icons.play_arrow,
                block: true,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => QuizScreen(questions: questions, quizId: widget.id),
                    ),
                  );
                },
              ),

              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value, Color color) {
    return Row(
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Icon(
            icon,
            size: 16,
            color: color,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 12,
                  color: AntDesignTheme.textSecondary,
                ),
              ),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: AntDesignTheme.textPrimary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
