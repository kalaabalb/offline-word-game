import 'package:flutter_test/flutter_test.dart';
import 'package:jebena/screens/quiz_scoring.dart';

void main() {
  group('calculateQuizScore', () {
    test('adds one point for each answer and each five seconds left', () {
      expect(calculateQuizScore(answeredCount: 4, timerSeconds: 20), 8);
    });

    test('rounds a partial five-second interval down', () {
      expect(calculateQuizScore(answeredCount: 2, timerSeconds: 19), 5);
    });

    test('awards no time bonus when the timer is empty', () {
      expect(calculateQuizScore(answeredCount: 7, timerSeconds: 0), 7);
    });
  });
}
