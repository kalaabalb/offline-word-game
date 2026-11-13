/// Calculates a round's score: one point for each answer plus one point for
/// every five seconds remaining on the timer.
int calculateQuizScore({required int answeredCount, required int timerSeconds}) {
  return answeredCount + (timerSeconds ~/ 5);
}
