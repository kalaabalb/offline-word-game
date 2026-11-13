import 'package:flutter/material.dart';

import '../../core/game_session.dart';
import '../../core/jebena_game.dart';
import '../../app/localization.dart';
import 'screens/home_screen.dart';

final class FidelDuelGame implements JebenaGame {
  const FidelDuelGame();

  @override
  String get id => 'fidel_duel';
  @override
  String get titleAm => 'ፊደል ቃል ዱኤል';
  @override
  String get titleEn => 'Fidel Word Duel';
  @override
  int get minPlayers => 2;
  @override
  int get maxPlayers => 2;
  @override
  DateTime get addedOn => DateTime(2026, 11, 14);

  @override
  Widget buildPreview(BuildContext context, GameSession session) =>
      _FidelDuelPreview(game: this, session: session);

  @override
  Widget buildGame(BuildContext context, GameSession session) =>
      const FidelDuelLibraryScreen();
}

const fidelDuelGame = FidelDuelGame();

class _FidelDuelPreview extends StatelessWidget {
  const _FidelDuelPreview({required this.game, required this.session});

  final FidelDuelGame game;
  final GameSession session;

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text(
              AppStrings.of(context).isEnglish ? game.titleEn : game.titleAm),
        ),
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(game.titleAm,
                  style: Theme.of(context).textTheme.headlineMedium),
              const SizedBox(height: 16),
              Text(AppStrings.of(context).text('game.summary')),
              const SizedBox(height: 24),
              FilledButton(
                onPressed: () => Navigator.of(context).push(MaterialPageRoute(
                  builder: (_) => game.buildGame(context, session),
                )),
                child: Text(AppStrings.of(context).text('game.chooseSet')),
              ),
            ],
          ),
        ),
      );
}
