import 'package:flutter/material.dart';

import '../../data/firestore_service.dart';
import '../../domain/models/quiz_result.dart';
import '../../domain/models/shared_result.dart';
import '../components/ant_design_components.dart';
import '../theme/ant_design_theme.dart';

class ShareResultScreen extends StatefulWidget {
  final QuizResult result;
  final String quizId;

  const ShareResultScreen({
    super.key,
    required this.result,
    required this.quizId,
  });

  @override
  State<ShareResultScreen> createState() => _ShareResultScreenState();
}

class _ShareResultScreenState extends State<ShareResultScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AntDesignTheme.backgroundColor,
      appBar: AppBar(
        title: const Text('Поделиться результатом'),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Заголовочная карточка с результатом
              AntCard(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    // Иконка результата
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        gradient: _getResultGradient(),
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: AntDesignTheme.buttonShadow,
                      ),
                      child: Icon(
                        _getResultIcon(),
                        size: 30,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Оценка
                    Text(
                      widget.result.grade,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: _getResultColor(),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),

                    // Процент правильных ответов
                    Text(
                      '${widget.result.percentage.toStringAsFixed(1)}%',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w700,
                        color: _getResultColor(),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),

                    // Статистика
                    Text(
                      '${widget.result.correctAnswers}/${widget.result.totalQuestions} правильных ответов',
                      style: const TextStyle(
                        fontSize: 14,
                        color: AntDesignTheme.textSecondary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Форма ввода данных
              AntCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Введите ваше имя',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AntDesignTheme.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Поле имени
                    TextFormField(
                      controller: _nameController,
                      decoration: const InputDecoration(
                        labelText: 'Имя *',
                        hintText: 'Введите ваше имя',
                        border: OutlineInputBorder(),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: AntDesignTheme.primaryColor),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Пожалуйста, введите имя';
                        }
                        return null;
                      },
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Информация о том, что будет сохранено
              const AntCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.info_outline,
                          color: AntDesignTheme.primaryColor,
                          size: 20,
                        ),
                        SizedBox(width: 8),
                        Text(
                          'Информация',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: AntDesignTheme.textPrimary,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Ваш результат будет сохранен в базе данных и доступен для просмотра другими пользователями.',
                      style: TextStyle(
                        fontSize: 13,
                        color: AntDesignTheme.textSecondary,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              // Кнопки действий
              AntButton(
                text: _isLoading ? 'Сохранение...' : 'Поделиться результатом',
                type: AntButtonType.primary,
                size: AntButtonSize.large,
                icon: _isLoading ? null : Icons.share,
                block: true,
                loading: _isLoading,
                onPressed: _isLoading ? null : _shareResult,
              ),
              const SizedBox(height: 12),
              AntButton(
                text: 'Отмена',
                type: AntButtonType.default_,
                size: AntButtonSize.large,
                icon: Icons.close,
                block: true,
                onPressed: () {
                  Navigator.pop(context);
                },
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _shareResult() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // Создаем объект SharedResult
      final result = SharedResult(
        quizId: widget.quizId,
        completionDate: DateTime.now(),
        userName: _nameController.text.trim(),
        totalQuestions: widget.result.totalQuestions,
        correctAnswers: widget.result.correctAnswers,
        percentage: widget.result.percentage,
      );

      // Сохраняем результат
      await FirestoreService.saveSharedResult(result);

      // Показываем успешное сообщение
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Результат успешно сохранен!'),
            backgroundColor: AntDesignTheme.successColor,
            behavior: SnackBarBehavior.floating,
          ),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Ошибка при сохранении: $e'),
            backgroundColor: AntDesignTheme.errorColor,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  LinearGradient _getResultGradient() {
    if (widget.result.percentage >= 90) return AntDesignTheme.successGradient;
    if (widget.result.percentage >= 70) return AntDesignTheme.primaryGradient;
    if (widget.result.percentage >= 50) return AntDesignTheme.warningGradient;
    return AntDesignTheme.errorGradient;
  }

  IconData _getResultIcon() {
    if (widget.result.percentage >= 90) return Icons.emoji_events;
    if (widget.result.percentage >= 70) return Icons.thumb_up;
    if (widget.result.percentage >= 50) return Icons.sentiment_neutral;
    return Icons.sentiment_dissatisfied;
  }

  Color _getResultColor() {
    if (widget.result.percentage >= 90) return Colors.amber;
    if (widget.result.percentage >= 70) return Colors.green;
    if (widget.result.percentage >= 50) return Colors.orange;
    return Colors.red;
  }
}
