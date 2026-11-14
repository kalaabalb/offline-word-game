class GameSession {
  GameSession({
    required this.playerCount,
    this.playerNames = const [],
    this.gameId,
    this.avatarIds = const [],
    this.roundNumber = 1,
    this.onScore,
  });

  final int playerCount;
  final List<String> playerNames;
  final List<int> avatarIds;
  final String? gameId;
  final int roundNumber;
  final void Function(String player, int points)? onScore;

  void reportScore(String player, int points) => onScore?.call(player, points);
}
