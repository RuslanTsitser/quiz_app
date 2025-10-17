class SharedResult {
  final String quizId;
  final DateTime completionDate;
  final String userName;
  final int totalQuestions;
  final int correctAnswers;
  final double percentage;

  const SharedResult({
    required this.quizId,
    required this.completionDate,
    required this.userName,
    required this.totalQuestions,
    required this.correctAnswers,
    required this.percentage,
  });

  Map<String, dynamic> toMap() {
    return {
      'quizId': quizId,
      'completionDate': completionDate.toIso8601String(),
      'userName': userName,
      'totalQuestions': totalQuestions,
      'correctAnswers': correctAnswers,
      'percentage': percentage,
    };
  }

  factory SharedResult.fromMap(Map<String, dynamic> map) {
    return SharedResult(
      quizId: map['quizId'] ?? '',
      completionDate: DateTime.parse(map['completionDate']),
      userName: map['userName'] ?? '',
      totalQuestions: map['totalQuestions'] ?? 0,
      correctAnswers: map['correctAnswers'] ?? 0,
      percentage: (map['percentage'] ?? 0.0).toDouble(),
    );
  }
}
