import '../core/jebena_game.dart';
import 'fidel_duel/fidel_duel_game.dart';

/// Games available to the shell. Modules register here as they are added.
final List<JebenaGame> gameRegistry = [fidelDuelGame];

enum PlayerTier {
  solo('Solo', 1, 1),
  pair('Pair', 2, 2),
  trio('Trio', 3, 5),
  party('Party', 6, 999999);

  const PlayerTier(this.label, this.minPlayers, this.maxPlayers);

  final String label;
  final int minPlayers;
  final int maxPlayers;

  bool includes(int count) => count >= minPlayers && count <= maxPlayers;

  String get localizationKey => switch (this) {
        PlayerTier.solo => 'tier.solo',
        PlayerTier.pair => 'tier.pair',
        PlayerTier.trio => 'tier.trio',
        PlayerTier.party => 'tier.party',
      };
}

List<JebenaGame> gamesForTier(PlayerTier tier, {DateTime? now}) {
  return gameRegistry
      .where((game) =>
          game.minPlayers <= tier.maxPlayers &&
          game.maxPlayers >= tier.minPlayers)
      .toList()
    ..sort((a, b) => b.addedOn.compareTo(a.addedOn));
}

bool isNewGame(JebenaGame game, {DateTime? now}) {
  final today = now ?? DateTime.now();
  return !game.addedOn.isAfter(today) &&
      today.difference(game.addedOn).inDays < 14;
}
