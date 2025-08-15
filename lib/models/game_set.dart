import 'question.dart';

class GameSet {
  final int id;
  final List<QuestionData> questions;

  GameSet({
    required this.id,
    required this.questions,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'questions': questions.map((q) => q.toJson()).toList(),
  };

  factory GameSet.fromJson(Map<String, dynamic> json) => GameSet(
    id: json['id'],
    questions: List<QuestionData>.from(
        json['questions'].map((q) => QuestionData.fromJson(q))),
  );
}