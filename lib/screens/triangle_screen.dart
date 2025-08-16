import 'package:flutter/material.dart';
import '../services/data_service.dart';
import '../widgets/triangle_box.dart';
import '../models/game_set.dart';

class TriangleScreen extends StatefulWidget {
  final int setId;

  const TriangleScreen({super.key, required this.setId});

  @override
  State<TriangleScreen> createState() => _TriangleScreenState();
}

class _TriangleScreenState extends State<TriangleScreen> {
  late GameSet gameSet;
  String? currentTeam;
  int team1Score = 0;
  int team2Score = 0;
  List<bool> playedQuestions = List.filled(6, false);
  String team1Name = 'ቡድን 1';
  String team2Name = 'ቡድን 2';
  bool showWinner = false;

  @override
  void initState() {
    super.initState();
    gameSet = DataService().getGameSetById(widget.setId)!;
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
      if (shouldProceed == true) {
        Navigator.pushNamed(
          context,
          '/question',
          arguments: {
            'setId': widget.setId,
            'questionIndex': questionIndex,
            'currentTeam': currentTeam,
          },

        ).then((score) {
          if (score != null) {
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
              }
            });
          }
        });
      }
    });
  }

  void _editTeamName(bool isTeam1) {
    showDialog(
      context: context,
      builder: (context) {
        final controller = TextEditingController(
            text: isTeam1 ? team1Name : team2Name);
        return AlertDialog(
          title: Text('ማስተካከል ${isTeam1 ? team1Name : team2Name}'),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(
              labelText: 'የቡድን ስም',
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('ሰርዝ'),
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
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("አዘጋጅ ${widget.setId}"),
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
                    title: const Text('አበቃ!'),
                    content: Text(
                      team1Score > team2Score
                          ? '$team1Name አሸንፈዋል! ($team1Score - $team2Score)'
                          : team2Score > team1Score
                          ? '$team2Name አሸንፈዋል! ($team2Score - $team1Score)'
                          : 'አቻ! ($team1Score - $team2Score)',
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
                        child: const Text('እንደገና ይጫወቱ'),
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