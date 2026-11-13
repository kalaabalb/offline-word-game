class ScoreEntry {
  const ScoreEntry({
    required this.gameId,
    required this.playedAt,
    required this.scores,
  });

  final String gameId;
  final DateTime playedAt;
  final Map<String, int> scores;

  Map<String, Object> toJson() => {
        'gameId': gameId,
        'playedAt': playedAt.toIso8601String(),
        'scores': scores,
      };

  factory ScoreEntry.fromJson(Map<String, dynamic> json) => ScoreEntry(
        gameId: json['gameId'] as String,
        playedAt: DateTime.parse(json['playedAt'] as String),
        scores: Map<String, int>.from(json['scores'] as Map),
      );
}
