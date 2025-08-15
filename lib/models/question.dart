class QuestionData {
  final String word;
  final String question;
  final List<String> answers;

  QuestionData({
    required this.word,
    required this.question,
    required this.answers,
  });

  Map<String, dynamic> toJson() => {
    'word': word,
    'question': question,
    'answers': answers,
  };

  factory QuestionData.fromJson(Map<String, dynamic> json) => QuestionData(
    word: json['word'],
    question: json['question'],
    answers: List<String>.from(json['answers']),
  );
}