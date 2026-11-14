import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jebena/core/game_session.dart';
import 'package:jebena/core/jebena_game.dart';
import 'package:jebena/games/registry.dart';

class _TestGame implements JebenaGame {
  _TestGame(this.id, this.minPlayers, this.maxPlayers, this.addedOn);

  @override
  final String id;
  @override
  String get titleAm => id;
  @override
  String get titleEn => id;
  @override
  final int minPlayers;
  @override
  final int maxPlayers;
  @override
  final DateTime addedOn;
  @override
  Widget buildPreview(BuildContext context, GameSession session) =>
      const SizedBox();
  @override
  Widget buildGame(BuildContext context, GameSession session) =>
      const SizedBox();
}

void main() {
  group('gamesForTier', () {
    final original = List<JebenaGame>.of(gameRegistry);
    tearDown(() => gameRegistry
      ..clear()
      ..addAll(original));

    test('filters by overlapping player range and sorts newest first', () {
      gameRegistry
        ..clear()
        ..addAll([
          _TestGame('pair', 2, 2, DateTime(2025)),
          _TestGame('trio-old', 4, 5, DateTime(2025)),
          _TestGame('trio-new', 4, 5, DateTime(2026)),
          _TestGame('solo', 1, 1, DateTime(2027)),
        ]);

      expect(gamesForTier(PlayerTier.pair).map((game) => game.id), ['pair']);
      expect(gamesForTier(PlayerTier.trio).map((game) => game.id), [
        'trio-new',
        'trio-old',
      ]);
      expect(gamesForTier(PlayerTier.solo).map((game) => game.id), ['solo']);
    });
  });

  group('isNewGame', () {
    final now = DateTime(2026, 11, 14, 12);

    test('includes a game added 13 days ago', () {
      final game =
          _TestGame('thirteen', 1, 2, now.subtract(const Duration(days: 13)));
      expect(isNewGame(game, now: now), isTrue);
    });

    test('excludes a game added 14 days ago', () {
      final game =
          _TestGame('fourteen', 1, 2, now.subtract(const Duration(days: 14)));
      expect(isNewGame(game, now: now), isFalse);
    });

    test('excludes future-dated games', () {
      final game = _TestGame('future', 1, 2, now.add(const Duration(days: 1)));
      expect(isNewGame(game, now: now), isFalse);
    });
  });
}
