import 'package:flutter/material.dart';

import '../core/game_session.dart';
import '../games/registry.dart';
import 'localization.dart';

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
    final strings = AppStrings.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(strings.text('app.title'))),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text(strings.text('home.prompt'),
              style: const TextStyle(fontSize: 24)),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            children: PlayerTier.values
                .map((option) => ChoiceChip(
                      label: Text(strings.text(option.localizationKey)),
                      selected: option == tier,
                      onSelected: (_) => setState(() => tier = option),
                    ))
                .toList(),
          ),
          const SizedBox(height: 20),
          if (games.isEmpty)
            Text(strings.text('home.empty'))
          else
            ...games.map((game) => Card(
                  child: ListTile(
                    title:
                        Text(strings.isEnglish ? game.titleEn : game.titleAm),
                    trailing:
                        isNewGame(game) ? Text(strings.text('game.new')) : null,
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
