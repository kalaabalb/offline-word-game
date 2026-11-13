import 'package:flutter/material.dart';
import '../../../app/localization.dart';
import '../../../core/score_entry.dart';
import '../../../core/storage.dart';
import '../services/data_service.dart';
import '../widgets/triangle_box.dart';
import '../models/game_set.dart';

class TriangleScreen extends StatefulWidget {
  final int setId;
  final List<String> playerNames;

  const TriangleScreen(
      {super.key, required this.setId, this.playerNames = const []});

  @override
  State<TriangleScreen> createState() => _TriangleScreenState();
}

class _TriangleScreenState extends State<TriangleScreen> {
  late GameSet gameSet;
  String? currentTeam;
  int team1Score = 0;
  int team2Score = 0;
  List<bool> playedQuestions = List.filled(6, false);
  late String team1Name;
  late String team2Name;
  bool _teamNamesInitialized = false;
  bool showWinner = false;

  @override
  void initState() {
    super.initState();
    gameSet = DataService().getGameSetById(widget.setId)!;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_teamNamesInitialized) return;
    final strings = AppStrings.of(context);
    team1Name = widget.playerNames.length >= 2
        ? widget.playerNames[0]
        : strings.text('team.one');
    team2Name = widget.playerNames.length >= 2
        ? widget.playerNames[1]
        : strings.text('team.two');
    _teamNamesInitialized = true;
  }

  void _navigateToQuestion(int questionIndex) {
    if (currentTeam == null) return;
    if (playedQuestions[questionIndex]) return;

    Navigator.pushNamed(
      context,
      '/start',
      arguments: {
        'setId': widget.setId,
        'questionIndex': questionIndex,
        'currentTeam': currentTeam,
      },
    ).then((shouldProceed) {
      if (mounted && shouldProceed == true) {
        Navigator.pushNamed(
          context,
          '/question',
          arguments: {
            'setId': widget.setId,
            'questionIndex': questionIndex,
            'currentTeam': currentTeam,
          },
        ).then((score) async {
          if (score != null) {
            var completed = false;
            setState(() {
              playedQuestions[questionIndex] = true;
              if (currentTeam == team1Name) {
                team1Score += score as int;
              } else {
                team2Score += score as int;
              }

              if (!playedQuestions.every((played) => played)) {
                currentTeam = currentTeam == team1Name ? team2Name : team1Name;
              } else {
                showWinner = true;
                completed = true;
              }
            });
            if (completed) await _saveScore();
          }
        });
      }
    });
  }

  Future<void> _saveScore() async {
    const storage = JebenaStorage();
    final entries = await storage.readJsonList('scoreboard');
    entries.add(ScoreEntry(
      gameId: 'fidel_duel',
      playedAt: DateTime.now(),
      scores: {team1Name: team1Score, team2Name: team2Score},
    ).toJson());
    if (entries.length > 100) entries.removeRange(0, entries.length - 100);
    await storage.writeJsonList('scoreboard', entries);
  }

  void _editTeamName(bool isTeam1) {
    showDialog(
      context: context,
      builder: (context) {
        final strings = AppStrings.of(context);
        final controller =
            TextEditingController(text: isTeam1 ? team1Name : team2Name);
        return AlertDialog(
          title: Text(strings
              .text('quiz.edit', {'team': isTeam1 ? team1Name : team2Name})),
          content: TextField(
            controller: controller,
            decoration: InputDecoration(
              labelText: strings.text('quiz.teamName'),
              border: const OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(strings.text('common.cancel')),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  if (isTeam1) {
                    team1Name = controller.text;
                  } else {
                    team2Name = controller.text;
                  }
                });
                Navigator.pop(context);
              },
              child: Text(strings.text('common.save')),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final strings = AppStrings.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(strings.text('quiz.prepare', {'set': widget.setId})),
        backgroundColor: Colors.deepPurple,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF4A90E2), Color(0xFF50E3C2)],
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Team Selection
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildTeamButton(team1Name, team1Score, true),
                      const SizedBox(width: 20),
                      _buildTeamButton(team2Name, team2Score, false),
                    ],
                  ),
                ),

                // Current turn indicator
                if (currentTeam != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: Text(
                      "$currentTeam' ተራ",
                      style: const TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TriangleBox(
                      text: gameSet.questions[0].word,
                      color: playedQuestions[0] ? Colors.grey : Colors.purple,
                      onTap: () => _navigateToQuestion(0),
                      enabled: currentTeam != null && !playedQuestions[0],
                    ),
                  ],
                ),
                // Triangle structure
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TriangleBox(
                      text: gameSet.questions[1].word,
                      color: playedQuestions[1] ? Colors.grey : Colors.blue,
                      onTap: () => _navigateToQuestion(1),
                      enabled: currentTeam != null && !playedQuestions[1],
                    ),
                    const SizedBox(width: 20),
                    TriangleBox(
                      text: gameSet.questions[2].word,
                      color: playedQuestions[2] ? Colors.grey : Colors.green,
                      onTap: () => _navigateToQuestion(2),
                      enabled: currentTeam != null && !playedQuestions[2],
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TriangleBox(
                      text: gameSet.questions[3].word,
                      color: playedQuestions[3] ? Colors.grey : Colors.orange,
                      onTap: () => _navigateToQuestion(3),
                      enabled: currentTeam != null && !playedQuestions[3],
                    ),
                    const SizedBox(width: 20),
                    TriangleBox(
                      text: gameSet.questions[4].word,
                      color: playedQuestions[4] ? Colors.grey : Colors.red,
                      onTap: () => _navigateToQuestion(4),
                      enabled: currentTeam != null && !playedQuestions[4],
                    ),
                    const SizedBox(width: 20),
                    TriangleBox(
                      text: gameSet.questions[5].word,
                      color: playedQuestions[5] ? Colors.grey : Colors.teal,
                      onTap: () => _navigateToQuestion(5),
                      enabled: currentTeam != null && !playedQuestions[5],
                    ),
                  ],
                ),

                if (showWinner)
                  AlertDialog(
                    title: Text(strings.text('quiz.finished')),
                    content: Text(
                      team1Score > team2Score
                          ? strings.text('winner.team', {
                              'team': team1Name,
                              'score': team1Score,
                              'otherScore': team2Score,
                            })
                          : team2Score > team1Score
                              ? strings.text('winner.team', {
                                  'team': team2Name,
                                  'score': team2Score,
                                  'otherScore': team1Score,
                                })
                              : strings.text('winner.draw', {
                                  'score': team1Score,
                                  'otherScore': team2Score,
                                }),
                      style: const TextStyle(fontSize: 18),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          setState(() {
                            showWinner = false;
                            currentTeam = null;
                            team1Score = 0;
                            team2Score = 0;
                            playedQuestions = List.filled(6, false);
                          });
                        },
                        child: Text(strings.text('quiz.playAgain')),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTeamButton(String teamName, int score, bool isTeam1) {
    return Column(
      children: [
        ElevatedButton(
          onPressed: () {
            setState(() {
              currentTeam = teamName;
            });
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: currentTeam == teamName
                ? (isTeam1 ? Colors.blue : Colors.green)
                : Colors.grey,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(teamName, style: const TextStyle(fontSize: 16)),
              IconButton(
                icon: const Icon(Icons.edit, size: 16),
                onPressed: () => _editTeamName(isTeam1),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'ነጥብ: $score',
          style: const TextStyle(
            fontSize: 16,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
