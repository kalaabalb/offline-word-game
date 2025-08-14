import 'package:flutter/material.dart';
import '../services/data_service.dart';
import '../widgets/triangle_box.dart';
import '../models/game_set.dart';

class TriangleScreen extends StatelessWidget {
  const TriangleScreen({super.key});

  void _navigateToQuestion(BuildContext context, int setId, int questionIndex) {
    Navigator.pushNamed(
      context,
      '/start',
      arguments: {
        'setId': setId,
        'questionIndex': questionIndex,
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final int setId = ModalRoute.of(context)!.settings.arguments as int;
    final GameSet? gameSet = DataService().getGameSetById(setId);

    if (gameSet == null) {
      return Scaffold(
        appBar: AppBar(title: const Text("Error")),
        body: const Center(child: Text("Set not found")),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("Set $setId"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFE1F5FE), Color(0xFFB3E5FC)],
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Top box
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TriangleBox(
                      text: gameSet.questions[0].word,
                      color: Colors.purple,
                      onTap: () => _navigateToQuestion(context, setId, 0),
                    ),
                    const SizedBox(width: 20),
                  ],
                ),

                const SizedBox(height: 20),

                // Middle boxes
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TriangleBox(
                      text: gameSet.questions[1].word,
                      color: Colors.blue,
                      onTap: () => _navigateToQuestion(context, setId, 1),
                    ),
                    const SizedBox(width: 20),
                    TriangleBox(
                      text: gameSet.questions[2].word,
                      color: Colors.green,
                      onTap: () => _navigateToQuestion(context, setId, 2),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                // Bottom boxes
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TriangleBox(
                      text: gameSet.questions[3].word,
                      color: Colors.orange,
                      onTap: () => _navigateToQuestion(context, setId, 3),
                    ),
                    const SizedBox(width: 20),
                    TriangleBox(
                      text: gameSet.questions[4].word,
                      color: Colors.red,
                      onTap: () => _navigateToQuestion(context, setId, 4),
                    ),
                    const SizedBox(width: 20),
                    TriangleBox(
                      text: gameSet.questions[5].word,
                      color: Colors.teal,
                      onTap: () => _navigateToQuestion(context, setId, 5),
                    ),
                  ],
                ),

                const SizedBox(height: 30),

                // Instructions
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: Text(
                    "Tap any word to start the question round",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[700],
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}