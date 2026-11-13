import 'package:flutter/material.dart';
import 'app/home_screen.dart';
import 'app/localization.dart';
import 'app/app_theme.dart';
import 'app/motion_settings.dart';
import 'games/fidel_duel/screens/triangle_screen.dart';
import 'games/fidel_duel/screens/start_screen.dart';
import 'games/fidel_duel/screens/question_screen.dart';
import 'games/fidel_duel/screens/add_set_screen.dart';
import 'games/fidel_duel/screens/add_question_screen.dart';
import 'games/fidel_duel/services/data_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DataService().loadGameSets();
  await MotionSettings.load();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      onGenerateTitle: (context) => AppStrings.of(context).text('app.title'),
      supportedLocales: const [Locale('am'), Locale('en')],
      localeResolutionCallback: (locale, supportedLocales) {
        if (locale?.languageCode == 'en') return const Locale('en');
        return const Locale('am');
      },
      theme: JebenaTheme.dark,
      builder: (context, child) => ValueListenableBuilder<bool>(
        valueListenable: MotionSettings.reducedMotion,
        builder: (context, reducedMotion, child) => MediaQuery(
          data:
              MediaQuery.of(context).copyWith(disableAnimations: reducedMotion),
          child: TickerMode(enabled: !reducedMotion, child: child!),
        ),
        child: child,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const HomeScreen(),
        '/triangle': (context) {
          final args = ModalRoute.of(context)!.settings.arguments;
          final setId =
              args is Map<String, dynamic> ? args['setId'] : args as int;
          return TriangleScreen(setId: setId);
        },
        '/start': (context) => const StartScreen(),
        '/question': (context) => const QuestionScreen(),
        '/add_set': (context) => const AddSetScreen(),
        '/add_question': (context) => const AddQuestionScreen(),
      },
    );
  }
}
