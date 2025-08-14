import 'package:flutter/material.dart';
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
  final List<FocusNode> answerFocusNodes = List.generate(7, (_) => FocusNode());
  int currentAnswerIndex = 0;

  @override
  void dispose() {
    wordController.dispose();
    questionController.dispose();
    for (var c in answerControllers) c.dispose();
    for (var f in answerFocusNodes) f.dispose();
    super.dispose();
  }

  void saveQuestion() {
    if (wordController.text.isEmpty ||
        questionController.text.isEmpty ||
        answerControllers.any((c) => c.text.isEmpty)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill all fields")),
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

    // Reset form for next question
    if (args['currentIndex'] < 5) {
      wordController.clear();
      questionController.clear();
      for (var c in answerControllers) c.clear();
      currentAnswerIndex = 0;
      FocusScope.of(context).requestFocus(answerFocusNodes[0]);
    } else {
      Navigator.popUntil(context, (route) => route.isFirst);
    }
  }

  void _nextAnswerField() {
    if (currentAnswerIndex < 6) {
      setState(() {
        currentAnswerIndex++;
      });
      FocusScope.of(context).requestFocus(answerFocusNodes[currentAnswerIndex]);
    }
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as Map;
    final int currentIndex = args['currentIndex'];

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text("Question ${currentIndex + 1}/6"),
        actions: [
          if (currentIndex == 5)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton.icon(
                icon: const Icon(Icons.done_all, color: Colors.white),
                label: const Text("FINISH SET", style: TextStyle(color: Colors.white)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  elevation: 4,
                ),
                onPressed: saveQuestion,
              ),
            ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            _buildInputField("Triangle Word", wordController),
            const SizedBox(height: 20),
            _buildInputField("Question", questionController, maxLines: 3),
            const SizedBox(height: 30),
            const Text("ANSWERS (7 required)",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 10),
            ...List.generate(7, (index) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: TextField(
                controller: answerControllers[index],
                focusNode: answerFocusNodes[index],
                decoration: InputDecoration(
                  labelText: "Answer ${index + 1}",
                  border: const OutlineInputBorder(),
                  suffixIcon: index < 6 ? IconButton(
                    icon: const Icon(Icons.arrow_forward),
                    onPressed: _nextAnswerField,
                  ) : null,
                ),
                textInputAction: index < 6 ? TextInputAction.next : TextInputAction.done,
                onSubmitted: (_) => index < 6 ? _nextAnswerField() : null,
              ),
            )),
            const SizedBox(height: 30),
            if (currentIndex < 5) ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
                backgroundColor: Colors.orange,
              ),
              onPressed: saveQuestion,
              child: const Text("SAVE & NEXT QUESTION",
                  style: TextStyle(fontSize: 16)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputField(String label, TextEditingController controller, {int maxLines = 1}) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
      maxLines: maxLines,
    );
  }
}