class QuizResult {
  final int totalQuestions;
  final int correctAnswers;
  final int wrongAnswers;
  final double percentage;

  const QuizResult({
    required this.totalQuestions,
    required this.correctAnswers,
    required this.wrongAnswers,
    required this.percentage,
  });

  String get grade {
    if (percentage >= 90) return 'Отлично!';
    if (percentage >= 80) return 'Хорошо!';
    if (percentage >= 70) return 'Удовлетворительно';
    if (percentage >= 60) return 'Почти хорошо';
    return 'Нужно подтянуться';
  }
}
