import 'dart:async';
import 'package:flutter/material.dart';
import '../../../app/localization.dart';
import '../services/data_service.dart';
import '../models/game_set.dart';
import '../scoring.dart';

class QuestionScreen extends StatefulWidget {
  const QuestionScreen({super.key});

  @override
  State<QuestionScreen> createState() => _QuestionScreenState();
}

class _QuestionScreenState extends State<QuestionScreen> {
  late GameSet gameSet;
  late int setId;
  late int questionIndex;
  late String currentTeam;

  int currentAnswerIndex = 0;
  int answeredCount = 0;
  List<bool> answered = [];
  int timerSeconds = 30;
  Timer? timer;
  bool isTimeUp = false;
  bool showResults = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)!.settings.arguments as Map;
    setId = args['setId'];
    questionIndex = args['questionIndex'];
    currentTeam = args['currentTeam'];

    gameSet = DataService().getGameSetById(setId)!;
    answered =
        List.filled(gameSet.questions[questionIndex].answers.length, false);
    startTimer();
  }

  void startTimer() {
    timer?.cancel();
    timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (timerSeconds > 0) {
        setState(() => timerSeconds--);
      } else {
        t.cancel();
        setState(() {
          isTimeUp = true;
          showResults = true;
        });
      }
    });
  }

  void markAnswered() {
    if (answeredCount >= 7 || answered[currentAnswerIndex]) return;

    setState(() {
      answered[currentAnswerIndex] = true;
      answeredCount++;
      final nextUnanswered = _getNextUnansweredIndex();
      if (nextUnanswered != -1) {
        currentAnswerIndex = nextUnanswered;
      } else if (answeredCount >= 7) {
        timer?.cancel();
        setState(() {
          isTimeUp = true;
          showResults = true;
        });
      }
    });
  }

  void nextAnswer() {
    final nextUnanswered = _getNextUnansweredIndex();
    if (nextUnanswered != -1) {
      setState(() => currentAnswerIndex = nextUnanswered);
    } else if (answeredCount >= 7) {
      setState(() {
        isTimeUp = true;
        showResults = true;
      });
    }
  }

  int _getNextUnansweredIndex() {
    for (int i = (currentAnswerIndex + 1) %
            gameSet.questions[questionIndex].answers.length;
        i != currentAnswerIndex;
        i = (i + 1) % gameSet.questions[questionIndex].answers.length) {
      if (!answered[i]) return i;
    }
    return -1;
  }

  int calculateScore() {
    return calculateQuizScore(
      answeredCount: answeredCount,
      timerSeconds: timerSeconds,
    );
  }

  @override
  Widget build(BuildContext context) {
    final strings = AppStrings.of(context);
    if (showResults) {
      return _buildResultsScreen();
    }

    final question = gameSet.questions[questionIndex];
    final currentAnswer = question.answers[currentAnswerIndex];

    return Scaffold(
      appBar: AppBar(
        title: Text(question.word.toUpperCase()),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: isTimeUp ? Colors.red[100] : Colors.green[100],
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isTimeUp ? Colors.red : Colors.green,
                width: 2,
              ),
            ),
            child: Text(
              "$timerSeconds s",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: isTimeUp ? Colors.red : Colors.green,
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  question.question,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
            const Spacer(),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
              decoration: BoxDecoration(
                color: answered[currentAnswerIndex]
                    ? Colors.green[50]
                    : Colors.blue[50],
                borderRadius: BorderRadius.circular(15),
                border: Border.all(
                  color:
                      answered[currentAnswerIndex] ? Colors.green : Colors.blue,
                  width: 2,
                ),
              ),
              child: Text(
                currentAnswer,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: answered[currentAnswerIndex]
                      ? Colors.green[800]
                      : Colors.blue[800],
                ),
              ),
            ),
            const Spacer(),
            LinearProgressIndicator(
              value: answeredCount / 7,
              backgroundColor: Colors.grey[200],
              color: Colors.green,
              minHeight: 10,
            ),
            const SizedBox(height: 8),
            Text(
              strings.text('question.answered', {'count': answeredCount}),
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed:
                        answered[currentAnswerIndex] ? null : markAnswered,
                    child: Text(
                      strings.text('question.mark'),
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      side: const BorderSide(color: Colors.blue),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: nextAnswer,
                    child: Text(
                      strings.text('question.skip'),
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResultsScreen() {
    final strings = AppStrings.of(context);
    final question = gameSet.questions[questionIndex];
    final score = calculateScore();

    return Scaffold(
      appBar: AppBar(
        title: Text(question.word),
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                Text(
                  strings.text('question.gameOver'),
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  strings.text(
                      'question.score', {'team': currentTeam, 'score': score}),
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  strings.text('question.resultsTitle'),
                  style: const TextStyle(fontSize: 18),
                ),
                const SizedBox(height: 10),
                ...question.answers.asMap().entries.map((entry) {
                  final index = entry.key;
                  final answer = entry.value;
                  return Container(
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color:
                          answered[index] ? Colors.green[100] : Colors.red[100],
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: answered[index] ? Colors.green : Colors.red,
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          answered[index] ? Icons.check : Icons.close,
                          color: answered[index] ? Colors.green : Colors.red,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            answer,
                            style: TextStyle(
                              fontSize: 18,
                              decoration: answered[index]
                                  ? TextDecoration.lineThrough
                                  : null,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }),
                const SizedBox(height: 30),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 40, vertical: 15),
                  ),
                  onPressed: () => Navigator.pop(context, score),
                  child: Text(
                    strings.text('question.return'),
                    style: const TextStyle(fontSize: 18),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }
}
