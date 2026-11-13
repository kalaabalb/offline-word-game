import 'package:flutter/material.dart';

import '../core/game_session.dart';
import '../games/registry.dart';
import 'localization.dart';
import 'motion_settings.dart';
import 'player_setup_screen.dart';
import 'scoreboard_screen.dart';

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
      appBar: AppBar(
        title: Text(strings.text('app.title')),
        actions: [
          IconButton(
            tooltip: strings.text('scoreboard.title'),
            icon: const Icon(Icons.leaderboard),
            onPressed: () => Navigator.of(context).push(MaterialPageRoute(
              builder: (_) => const ScoreboardScreen(),
            )),
          ),
          IconButton(
            tooltip: strings.text('settings.title'),
            icon: const Icon(Icons.settings),
            onPressed: () async {
              await MotionSettings.load();
              if (!context.mounted) return;
              showDialog<void>(
                context: context,
                builder: (dialogContext) => AlertDialog(
                  title: Text(strings.text('settings.title')),
                  content: ValueListenableBuilder<bool>(
                    valueListenable: MotionSettings.reducedMotion,
                    builder: (context, value, _) => SwitchListTile(
                      title: Text(strings.text('settings.reducedMotion')),
                      value: value,
                      onChanged: MotionSettings.setReducedMotion,
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
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
                      builder: (_) => PlayerSetupScreen(
                        game: game,
                        playerCount: tier.minPlayers,
                      ),
                    )),
                  ),
                )),
        ],
      ),
    );
  }
}
