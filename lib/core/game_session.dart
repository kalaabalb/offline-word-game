class GameSession {
  const GameSession({
    required this.playerCount,
    this.playerNames = const [],
    this.gameId,
  });

  final int playerCount;
  final List<String> playerNames;
  final String? gameId;
}
