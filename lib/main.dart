import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'data/questions_repository_impl.dart';
import 'presentation/screens/home_screen.dart';
import 'presentation/state_manager/questions_notifier.dart';

void main() {
  runApp(const QuizApp());
}

class QuizApp extends StatelessWidget {
  const QuizApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => QuestionsNotifier(questionsRepository: QuestionsRepositoryImpl()),
      child: MaterialApp(
        title: 'Квиз-приложение',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue, brightness: Brightness.light),
          useMaterial3: true,
          appBarTheme: const AppBarTheme(centerTitle: true, elevation: 0),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              elevation: 2,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
          cardTheme: CardThemeData(
            elevation: 2,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
        home: const HomeScreen(id: '1'),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
