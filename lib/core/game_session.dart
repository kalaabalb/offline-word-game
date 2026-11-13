class GameSession {
  const GameSession({
    required this.playerCount,
    this.playerNames = const [],
    this.gameId,
    this.avatarIds = const [],
  });

  final int playerCount;
  final List<String> playerNames;
  final List<int> avatarIds;
  final String? gameId;
}
