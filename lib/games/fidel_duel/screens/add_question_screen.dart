import 'package:flutter/material.dart';
import '../../../app/localization.dart';
import '../models/question.dart';

class AddQuestionScreen extends StatefulWidget {
  const AddQuestionScreen({super.key});

  @override
  State<AddQuestionScreen> createState() => _AddQuestionScreenState();
}

class _AddQuestionScreenState extends State<AddQuestionScreen> {
  final TextEditingController wordController = TextEditingController();
  final TextEditingController questionController = TextEditingController();
  final List<TextEditingController> answerControllers =
      List.generate(7, (_) => TextEditingController());

  @override
  void dispose() {
    wordController.dispose();
    questionController.dispose();
    for (var c in answerControllers) {
      c.dispose();
    }
    super.dispose();
  }

  void saveQuestion() {
    final strings = AppStrings.of(context);
    if (wordController.text.isEmpty ||
        questionController.text.isEmpty ||
        answerControllers.any((c) => c.text.isEmpty)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(strings.text('question.fillAll'))),
      );
      return;
    }

    final newQuestion = QuestionData(
      word: wordController.text.trim(),
      question: questionController.text.trim(),
      answers: answerControllers.map((c) => c.text.trim()).toList(),
    );

    final args = ModalRoute.of(context)!.settings.arguments as Map;
    final Function(QuestionData) onSave = args['onSave'];
    onSave(newQuestion);

    if (args['currentIndex'] < 5) {
      wordController.clear();
      questionController.clear();
      for (var c in answerControllers) {
        c.clear();
      }
      Navigator.pushNamed(
        context,
        '/add_question',
        arguments: {
          'onSave': onSave,
          'currentIndex': args['currentIndex'] + 1,
        },
      );
    } else {
      Navigator.popUntil(context, (route) => route.isFirst);
    }
  }

  @override
  Widget build(BuildContext context) {
    final strings = AppStrings.of(context);
    final args = ModalRoute.of(context)!.settings.arguments as Map;
    final int currentIndex = args['currentIndex'];

    return Scaffold(
      appBar: AppBar(
        title:
            Text(strings.text('question.title', {'index': currentIndex + 1})),
        backgroundColor: Colors.blue,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFFE3F2FD), Color(0xFFBBDEFB)],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Card(
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        TextField(
                          controller: wordController,
                          decoration: InputDecoration(
                            labelText: strings.text('question.wordLabel'),
                            border: OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextField(
                          controller: questionController,
                          decoration: InputDecoration(
                            labelText: strings.text('question.promptLabel'),
                            border: OutlineInputBorder(),
                          ),
                          maxLines: 3,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  '7 ${strings.text('question.answers')}',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                ListView.separated(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: 7,
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 8),
                  itemBuilder: (context, index) {
                    return TextField(
                      controller: answerControllers[index],
                      decoration: InputDecoration(
                        labelText: strings
                            .text('question.answerLabel', {'index': index + 1}),
                        border: const OutlineInputBorder(),
                        filled: true,
                        fillColor: Colors.white.withOpacity(0.8),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 20),
                if (currentIndex < 5)
                  ElevatedButton(
                    onPressed: saveQuestion,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      minimumSize: const Size(double.infinity, 50),
                    ),
                    child: Text(strings.text('question.saveNext')),
                  ),
                if (currentIndex == 5)
                  ElevatedButton(
                    onPressed: saveQuestion,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      minimumSize: const Size(double.infinity, 50),
                    ),
                    child: Text(strings.text('question.finish')),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
