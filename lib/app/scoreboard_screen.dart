import 'package:flutter/material.dart';

import '../core/score_entry.dart';
import '../core/storage.dart';
import 'localization.dart';

class ScoreboardScreen extends StatefulWidget {
  const ScoreboardScreen({super.key});

  @override
  State<ScoreboardScreen> createState() => _ScoreboardScreenState();
}

class _ScoreboardScreenState extends State<ScoreboardScreen> {
  late final Future<List<ScoreEntry>> _scores = _load();

  Future<List<ScoreEntry>> _load() async =>
      (await const JebenaStorage().readJsonList('scoreboard'))
          .map(ScoreEntry.fromJson)
          .toList()
        ..sort((a, b) => b.playedAt.compareTo(a.playedAt));

  @override
  Widget build(BuildContext context) {
    final strings = AppStrings.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(strings.text('scoreboard.title'))),
      body: FutureBuilder<List<ScoreEntry>>(
        future: _scores,
        builder: (context, snapshot) {
          final scores = snapshot.data ?? const [];
          if (scores.isEmpty) {
            return Center(child: Text(strings.text('scoreboard.empty')));
          }
          return ListView.builder(
            itemCount: scores.length,
            itemBuilder: (context, index) {
              final entry = scores[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                child: ListTile(
                  title: Text(entry.gameId),
                  subtitle: Text(
                      entry.playedAt.toLocal().toString().split('.').first),
                  trailing: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: entry.scores.entries
                        .map((score) => Text(
                              strings.text('scoreboard.score', {
                                'name': score.key,
                                'score': score.value,
                              }),
                            ))
                        .toList(),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
