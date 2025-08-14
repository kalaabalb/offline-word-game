import 'package:flutter/material.dart';
import '../models/question.dart';
import 'add_question_screen.dart';
import '../services/data_service.dart';
import '../models/game_set.dart';

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

  void _completeSet() {
    final newSet = GameSet(
      id: dataService.gameSets.length + 1,
      questions: newQuestions,
    );
    dataService.addGameSet(newSet);
    Navigator.popUntil(context, ModalRoute.withName('/'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Create New Set"),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFE1F5FE), Color(0xFFB3E5FC)],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.add_circle_outline, size: 80, color: Colors.orange),
              const SizedBox(height: 20),
              const Text(
                "Create a new set of 6 questions",
                style: TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  backgroundColor: Colors.orange,
                ),
                onPressed: _addQuestion,
                child: const Text(
                  "BEGIN CREATION",
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}