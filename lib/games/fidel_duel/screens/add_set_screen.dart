import '../../../app/app_theme.dart';
import 'package:flutter/material.dart';
import '../../../app/localization.dart';
import '../services/data_service.dart';
import '../models/game_set.dart';
import '../models/question.dart';

class AddSetScreen extends StatefulWidget {
  const AddSetScreen({super.key});

  @override
  State<AddSetScreen> createState() => _AddSetScreenState();
}

class _AddSetScreenState extends State<AddSetScreen> {
  final DataService dataService = DataService();
  final List<QuestionData> newQuestions = [];
  int currentQuestionIndex = 0;

  void _addQuestion() {
    Navigator.pushNamed(
      context,
      '/add_question',
      arguments: {
        'onSave': (QuestionData question) {
          setState(() {
            newQuestions.add(question);
            if (newQuestions.length < 6) {
              currentQuestionIndex++;
              _addQuestion();
            } else {
              _completeSet();
            }
          });
        },
        'currentIndex': currentQuestionIndex,
      },
    );
  }

  Future<void> _completeSet() async {
    final newSet = GameSet(
      id: dataService.getNextId(),
      questions: newQuestions,
    );
    await dataService.addGameSet(newSet);
    if (!mounted) return;
    Navigator.popUntil(context, (route) => route.isFirst);
  }

  @override
  Widget build(BuildContext context) {
    final strings = AppStrings.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          strings.text('set.create'),
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: JebenaTheme.surface,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              JebenaTheme.surface,
              JebenaTheme.background,
            ],
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.3),
                      width: 1,
                    ),
                  ),
                  child: Column(
                    children: [
                      const Icon(
                        Icons.add_circle_outline,
                        size: 80,
                        color: JebenaTheme.saffron,
                      ),
                      const SizedBox(height: 20),
                      Text(
                        strings.text('set.createTitle'),
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white.withValues(alpha: 0.9),
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        strings.text('set.instructions'),
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white.withValues(alpha: 0.8),
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 32),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 40, vertical: 18),
                          backgroundColor: JebenaTheme.saffron,
                          foregroundColor: JebenaTheme.surface,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 5,
                          shadowColor:
                              JebenaTheme.saffron.withValues(alpha: 0.5),
                        ),
                        onPressed: _addQuestion,
                        child: Text(
                          strings.text('set.start'),
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
                const SizedBox(height: 40),
                Text(
                  strings.text('set.tip'),
                  style: TextStyle(
                    fontSize: 14,
                    fontStyle: FontStyle.italic,
                    color: Colors.white.withValues(alpha: 0.6),
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
