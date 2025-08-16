import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'screens/triangle_screen.dart';
import 'screens/start_screen.dart';
import 'screens/question_screen.dart';
import 'screens/add_set_screen.dart';
import 'screens/add_question_screen.dart';
import 'services/data_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DataService().loadGameSets();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ማን ያሸንፋል?',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const HomeScreen(),
        '/triangle': (context) {
          final args = ModalRoute.of(context)!.settings.arguments;
          final setId = args is Map<String, dynamic>
              ? args['setId']
              : args as int;
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