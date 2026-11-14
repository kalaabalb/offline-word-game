import 'package:flutter/material.dart';

import '../core/game_session.dart';
import '../core/jebena_game.dart';
import '../core/score_entry.dart';
import '../core/storage.dart';
import '../games/registry.dart';
import 'localization.dart';

class GameSessionFlowScreen extends StatefulWidget {
  const GameSessionFlowScreen({
    required this.game,
    required this.session,
    super.key,
  });

  final JebenaGame game;
  final GameSession session;

  @override
  State<GameSessionFlowScreen> createState() => _GameSessionFlowScreenState();
}

class _GameSessionFlowScreenState extends State<GameSessionFlowScreen> {
  static const _roundsPerEvening = 3;
  int _round = 1;
  bool _roundComplete = false;
  bool _eveningComplete = false;
  bool _playing = false;
  bool _selectingGame = false;
  late JebenaGame _selectedGame;
  Map<String, int> _roundScores = {};

  @override
  void initState() {
    super.initState();
    _selectedGame = widget.game;
  }

  Future<void> _playRound() async {
    if (_playing || _eveningComplete) return;
    setState(() {
      _playing = true;
      _roundComplete = false;
      _roundScores = {};
    });
    final session = GameSession(
      playerCount: widget.session.playerCount,
      playerNames: widget.session.playerNames,
      avatarIds: widget.session.avatarIds,
      gameId: _selectedGame.id,
      roundNumber: _round,
      onScore: (player, points) => _roundScores[player] = points,
    );
    await Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => _selectedGame.buildPreview(context, session),
    ));
    if (!mounted) return;
    if (_roundScores.isNotEmpty) {
      await _saveRoundScore();
      if (!mounted) return;
      setState(() {
        _roundComplete = true;
        _eveningComplete = _round == _roundsPerEvening;
      });
    }
    setState(() => _playing = false);
  }

  Future<void> _saveRoundScore() async {
    const storage = JebenaStorage();
    final entries = await storage.readJsonList('scoreboard');
    entries.add(ScoreEntry(
      gameId: _selectedGame.id,
      playedAt: DateTime.now(),
      scores: Map<String, int>.from(_roundScores),
    ).toJson());
    if (entries.length > 100) entries.removeRange(0, entries.length - 100);
    await storage.writeJsonList('scoreboard', entries);
  }

  void _continue() {
    if (_eveningComplete) {
      Navigator.of(context).popUntil((route) => route.isFirst);
      return;
    }
    setState(() {
      _round++;
      _roundComplete = false;
      _selectingGame = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final strings = AppStrings.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(strings.text('app.title'))),
      body: _selectingGame
          ? _buildGamePicker(strings)
          : Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      strings.text(
                        _eveningComplete
                            ? 'session.eveningComplete'
                            : _roundComplete
                                ? 'session.roundComplete'
                                : 'session.round',
                        {'round': _round},
                      ),
                      style: Theme.of(context).textTheme.headlineMedium,
                      textAlign: TextAlign.center,
                    ),
                    if (_roundComplete) ...[
                      const SizedBox(height: 16),
                      for (final score in _roundScores.entries)
                        Text(strings.text('scoreboard.score', {
                          'name': score.key,
                          'score': score.value,
                        })),
                    ],
                    const SizedBox(height: 24),
                    if (!_selectingGame)
                      FilledButton(
                        onPressed: _playing
                            ? null
                            : _roundComplete
                                ? _continue
                                : _playRound,
                        child: Text(strings.text(
                          _roundComplete
                              ? _eveningComplete
                                  ? 'session.finish'
                                  : 'session.nextRound'
                              : 'session.startRound',
                          {'round': _round},
                        )),
                      ),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildGamePicker(AppStrings strings) {
    final games = gameRegistry
        .where((game) =>
            game.minPlayers <= widget.session.playerCount &&
            game.maxPlayers >= widget.session.playerCount)
        .toList()
      ..sort((a, b) => b.addedOn.compareTo(a.addedOn));
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        Text(strings.text('session.chooseGame'),
            style: Theme.of(context).textTheme.titleLarge),
        for (final game in games)
          Card(
            child: ListTile(
              title: Text(strings.isEnglish ? game.titleEn : game.titleAm),
              onTap: () => setState(() {
                _selectedGame = game;
                _selectingGame = false;
              }),
            ),
          ),
      ],
    );
  }
}
