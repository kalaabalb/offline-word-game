import 'package:flutter/material.dart';

import '../core/game_session.dart';
import '../games/registry.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  PlayerTier tier = PlayerTier.pair;

  @override
  Widget build(BuildContext context) {
    final games = gamesForTier(tier);
    return Scaffold(
      appBar: AppBar(title: const Text('Jebena')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const Text('How many are playing?', style: TextStyle(fontSize: 24)),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            children: PlayerTier.values
                .map((option) => ChoiceChip(
                      label: Text(option.label),
                      selected: option == tier,
                      onSelected: (_) => setState(() => tier = option),
                    ))
                .toList(),
          ),
          const SizedBox(height: 20),
          if (games.isEmpty)
            const Text('Games for this group are coming soon.')
          else
            ...games.map((game) => Card(
                  child: ListTile(
                    title: Text(game.titleEn),
                    subtitle: Text(game.titleAm),
                    trailing: isNewGame(game) ? const Text('New') : null,
                    onTap: () => Navigator.of(context).push(MaterialPageRoute(
                      builder: (_) => game.buildPreview(
                        context,
                        GameSession(
                            playerCount: tier.minPlayers, gameId: game.id),
                      ),
                    )),
                  ),
                )),
        ],
      ),
    );
  }
}
