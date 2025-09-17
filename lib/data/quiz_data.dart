import '../models/question.dart';

class QuizData {
  static const List<Question> questions = [
    Question(
      questionText: 'Какая столица России?',
      options: ['Москва', 'Санкт-Петербург', 'Новосибирск', 'Екатеринбург'],
      correctAnswerIndex: 0,
    ),
    Question(
      questionText: 'Сколько планет в Солнечной системе?',
      options: ['7', '8', '9', '10'],
      correctAnswerIndex: 1,
    ),
    Question(
      questionText: 'Кто написал роман "Война и мир"?',
      options: ['Достоевский', 'Толстой', 'Чехов', 'Тургенев'],
      correctAnswerIndex: 1,
    ),
    Question(
      questionText: 'Какая самая большая планета в Солнечной системе?',
      options: ['Земля', 'Сатурн', 'Юпитер', 'Нептун'],
      correctAnswerIndex: 2,
    ),
    Question(
      questionText: 'В каком году был основан Санкт-Петербург?',
      options: ['1700', '1703', '1705', '1710'],
      correctAnswerIndex: 1,
    ),
    Question(questionText: 'Какая формула воды?', options: ['H2O', 'CO2', 'O2', 'H2SO4'], correctAnswerIndex: 0),
    Question(
      questionText: 'Кто изобрел лампочку?',
      options: ['Эдисон', 'Тесла', 'Белл', 'Морзе'],
      correctAnswerIndex: 0,
    ),
    Question(questionText: 'Сколько континентов на Земле?', options: ['5', '6', '7', '8'], correctAnswerIndex: 2),
    Question(
      questionText: 'Какая самая длинная река в мире?',
      options: ['Амазонка', 'Нил', 'Янцзы', 'Миссисипи'],
      correctAnswerIndex: 1,
    ),
    Question(
      questionText: 'В каком океане находится Марианская впадина?',
      options: ['Атлантический', 'Тихий', 'Индийский', 'Северный Ледовитый'],
      correctAnswerIndex: 1,
    ),
  ];
}
