import 'question.dart';

class GameSet {
  final int id; // Numbered box ID
  final List<QuestionData> questions; // 6 questions for the triangle

  GameSet({
    required this.id,
    required this.questions,
  });
}
