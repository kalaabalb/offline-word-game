import 'package:flutter/material.dart';
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
    Navigator.popUntil(context, (route) => route.isFirst);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Create New Set",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.deepPurple.shade800,
              Colors.indigo.shade900,
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
                    color: Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                  child: Column(
                    children: [
                      const Icon(
                        Icons.add_circle_outline,
                        size: 80,
                        color: Colors.amber,
                      ),
                      const SizedBox(height: 20),
                      Text(
                        "አዲስ የጥያቄ ስብስብ ይፍጠሩ",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white.withOpacity(0.9),
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        " ለመጫወት የ 6 ጥያቄዎች ስብስብ ይፍጠሩ.  7 ሊሆኑ የሚችሉ መልሶች እና 1 ቃል ለመምረጥ",
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white.withOpacity(0.8),
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 32),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 40, vertical: 18),
                          backgroundColor: Colors.amber,
                          foregroundColor: Colors.deepPurple,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 5,
                          shadowColor: Colors.amber.withOpacity(0.5),
                        ),
                        onPressed: _addQuestion,
                        child: const Text(
                          "BEGIN CREATION",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        "Step 1 of 1",
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white.withOpacity(0.6),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 40),
                Text(
                  "ጠቃሚ: ከመጀመርዎ በፊት የእርስዎን ቃላት እና ትርጓሜዎች ያዘጋጁ",
                  style: TextStyle(
                    fontSize: 14,
                    fontStyle: FontStyle.italic,
                    color: Colors.white.withOpacity(0.6),
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