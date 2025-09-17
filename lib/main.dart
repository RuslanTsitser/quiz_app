import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:provider/provider.dart';

import 'app/router/app_router.dart';
import 'data/questions_repository_impl.dart';
import 'firebase_options.dart';
import 'presentation/state_manager/questions_notifier.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  usePathUrlStrategy();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const QuizApp());
}

class QuizApp extends StatelessWidget {
  const QuizApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => QuestionsNotifier(questionsRepository: QuestionsRepositoryImpl()),
      child: MaterialApp.router(
        routerConfig: getRouter(),
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
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
