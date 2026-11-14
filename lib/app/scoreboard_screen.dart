import 'package:flutter/material.dart';

import '../core/score_entry.dart';
import '../core/ethiopian_calendar.dart';
import '../core/storage.dart';
import '../games/registry.dart';
import 'localization.dart';

class ScoreboardScreen extends StatefulWidget {
  const ScoreboardScreen({super.key});

  @override
  State<ScoreboardScreen> createState() => _ScoreboardScreenState();
}

class _ScoreboardScreenState extends State<ScoreboardScreen> {
  late Future<List<ScoreEntry>> _scores = _load();
  bool _useEthiopianCalendar = true;

  Future<List<ScoreEntry>> _load() async =>
      (await const JebenaStorage().readJsonList('scoreboard'))
          .map(ScoreEntry.fromJson)
          .toList()
        ..sort((a, b) => b.playedAt.compareTo(a.playedAt));

  Future<void> _startNewEvening() async {
    final strings = AppStrings.of(context);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        content: Text(strings.text('scoreboard.resetConfirm')),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(strings.text('common.cancel')),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(strings.text('scoreboard.reset')),
          ),
        ],
      ),
    );
    if (confirmed != true) return;
    await const JebenaStorage().writeJsonList('scoreboard', []);
    if (!mounted) return;
    setState(() => _scores = _load());
  }

  @override
  void initState() {
    super.initState();
    _scores = _load();
    _loadCalendarPreference();
  }

  Future<void> _loadCalendarPreference() async {
    final preference =
        await const JebenaStorage().readString('scoreboard_calendar');
    if (!mounted || preference == null) return;
    setState(() => _useEthiopianCalendar = preference != 'gregorian');
  }

  @override
  Widget build(BuildContext context) {
    final strings = AppStrings.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(strings.text('scoreboard.title')),
        actions: [
          IconButton(
            tooltip: strings.text(
              _useEthiopianCalendar
                  ? 'calendar.gregorian'
                  : 'calendar.ethiopian',
            ),
            onPressed: _toggleCalendar,
            icon: const Icon(Icons.calendar_month),
          ),
          TextButton.icon(
            onPressed: _startNewEvening,
            icon: const Icon(Icons.restart_alt),
            label: Text(strings.text('scoreboard.newEvening')),
          ),
        ],
      ),
      body: FutureBuilder<List<ScoreEntry>>(
        future: _scores,
        builder: (context, snapshot) {
          final scores = snapshot.data ?? const [];
          if (scores.isEmpty) {
            return Center(child: Text(strings.text('scoreboard.empty')));
          }
          final playerEntries =
              <String, List<({ScoreEntry entry, int score})>>{};
          for (final entry in scores) {
            for (final score in entry.scores.entries) {
              (playerEntries[score.key] ??= [])
                  .add((entry: entry, score: score.value));
            }
          }
          final players = playerEntries.entries.toList()
            ..sort((a, b) => _total(b.value).compareTo(_total(a.value)));
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              for (final player in players) ...[
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(player.key,
                            style: Theme.of(context).textTheme.titleLarge),
                        const SizedBox(height: 4),
                        Text(strings.text('scoreboard.total', {
                          'score': _total(player.value),
                        })),
                        const Divider(),
                        for (final result in player.value)
                          ListTile(
                            contentPadding: EdgeInsets.zero,
                            title:
                                Text(_gameTitle(result.entry.gameId, strings)),
                            subtitle: Text(_formatDate(result.entry.playedAt)),
                            trailing: Text('${result.score}'),
                          ),
                      ],
                    ),
                  ),
                ),
              ],
            ],
          );
        },
      ),
    );
  }

  Future<void> _toggleCalendar() async {
    setState(() => _useEthiopianCalendar = !_useEthiopianCalendar);
    await const JebenaStorage().writeString(
      'scoreboard_calendar',
      _useEthiopianCalendar ? 'ethiopian' : 'gregorian',
    );
  }

  String _formatDate(DateTime dateTime) {
    final date = dateTime.toLocal();
    if (_useEthiopianCalendar) {
      return EthiopianCalendar.fromGregorian(date).toString();
    }
    return '${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  int _total(List<({ScoreEntry entry, int score})> entries) =>
      entries.fold(0, (sum, result) => sum + result.score);

  String _gameTitle(String gameId, AppStrings strings) {
    for (final game in gameRegistry) {
      if (game.id == gameId) {
        return strings.isEnglish ? game.titleEn : game.titleAm;
      }
    }
    return strings.text('game.unknown');
  }
}
