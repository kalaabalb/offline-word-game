import 'package:flutter/material.dart';

import '../core/game_session.dart';
import '../core/jebena_game.dart';
import '../core/player_profile.dart';
import '../core/storage.dart';
import 'localization.dart';

class PlayerSetupScreen extends StatefulWidget {
  const PlayerSetupScreen({
    required this.game,
    required this.playerCount,
    super.key,
  });

  final JebenaGame game;
  final int playerCount;

  @override
  State<PlayerSetupScreen> createState() => _PlayerSetupScreenState();
}

class _PlayerSetupScreenState extends State<PlayerSetupScreen> {
  static const _avatars = [
    Icons.face,
    Icons.face_3,
    Icons.face_4,
    Icons.face_5,
    Icons.face_6,
    Icons.emoji_people,
  ];
  final _storage = const JebenaStorage();
  late final List<TextEditingController> _names;
  late final List<int> _avatarIds;

  @override
  void initState() {
    super.initState();
    _names = List.generate(widget.playerCount, (_) => TextEditingController());
    _avatarIds =
        List.generate(widget.playerCount, (index) => index % _avatars.length);
    _loadProfiles();
  }

  Future<void> _loadProfiles() async {
    final stored = await _storage.readJsonList('remembered_players');
    if (!mounted) return;
    for (var i = 0; i < stored.length && i < _names.length; i++) {
      final profile = PlayerProfile.fromJson(stored[i]);
      _names[i].text = profile.name;
      _avatarIds[i] = profile.avatarId.clamp(0, _avatars.length - 1);
    }
    setState(() {});
  }

  Future<void> _continue() async {
    final strings = AppStrings.of(context);
    final profiles = List.generate(
      widget.playerCount,
      (i) => PlayerProfile(
        name: _names[i].text.trim().isEmpty
            ? strings.text('players.name', {'index': i + 1})
            : _names[i].text.trim(),
        avatarId: _avatarIds[i],
      ),
    );
    await _storage.writeJsonList(
      'remembered_players',
      profiles.map((profile) => profile.toJson()).toList(),
    );
    if (!mounted) return;
    final session = GameSession(
      playerCount: widget.playerCount,
      playerNames: profiles.map((profile) => profile.name).toList(),
      avatarIds: profiles.map((profile) => profile.avatarId).toList(),
      gameId: widget.game.id,
    );
    Navigator.of(context).pushReplacement(MaterialPageRoute(
      builder: (_) => widget.game.buildPreview(context, session),
    ));
  }

  @override
  void dispose() {
    for (final controller in _names) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final strings = AppStrings.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(strings.text('players.title'))),
      body: ListView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: widget.playerCount + 1,
        itemBuilder: (context, index) {
          if (index == widget.playerCount) {
            return Padding(
              padding: const EdgeInsets.only(top: 16),
              child: FilledButton(
                onPressed: _continue,
                child: Text(strings.text('players.save')),
              ),
            );
          }
          return Card(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                children: [
                  TextField(
                    controller: _names[index],
                    textCapitalization: TextCapitalization.words,
                    decoration: InputDecoration(
                      labelText:
                          strings.text('players.name', {'index': index + 1}),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    children: List.generate(
                        _avatars.length,
                        (avatar) => IconButton(
                              tooltip: strings
                                  .text('players.name', {'index': index + 1}),
                              onPressed: () =>
                                  setState(() => _avatarIds[index] = avatar),
                              icon: Icon(
                                _avatars[avatar],
                                color: _avatarIds[index] == avatar
                                    ? Theme.of(context).colorScheme.secondary
                                    : Theme.of(context).colorScheme.onSurface,
                              ),
                            )),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
