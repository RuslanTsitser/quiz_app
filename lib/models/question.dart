class Question {
  final String questionText;
  final List<String> options;
  final List<int> correctAnswerIndexes;

  const Question({
    required this.questionText,
    required this.options,
    required this.correctAnswerIndexes,
  });
}
