import 'package:flutter/widgets.dart';

import 'game_session.dart';

abstract class JebenaGame {
  String get id;
  String get titleAm;
  String get titleEn;
  int get minPlayers;
  int get maxPlayers;
  DateTime get addedOn;

  Widget buildPreview(BuildContext context, GameSession session);
  Widget buildGame(BuildContext context, GameSession session);
}
