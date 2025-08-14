import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'screens/triangle_screen.dart';
import 'screens/start_screen.dart';
import 'screens/question_screen.dart';
import 'screens/add_set_screen.dart';
import 'screens/add_question_screen.dart';

void main() {
  runApp(const ManYashenifalApp());
}

class ManYashenifalApp extends StatelessWidget {
  const ManYashenifalApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Man Yashenifal',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.white,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const HomeScreen(),
        '/triangle': (context) => const TriangleScreen(),
        '/start': (context) => const StartScreen(),
        '/question': (context) => const QuestionScreen(),
        '/add_set': (context) => const AddSetScreen(),
        '/add_question': (context) => const AddQuestionScreen(),
      },
    );
  }
}
