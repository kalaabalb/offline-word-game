import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jebena/app/app_theme.dart';
import 'package:jebena/app/player_setup_screen.dart';
import 'package:jebena/games/fidel_duel/fidel_duel_game.dart';
import 'package:jebena/games/fidel_duel/models/question.dart';
import 'package:jebena/games/fidel_duel/screens/add_question_screen.dart';
import 'package:jebena/games/fidel_duel/screens/triangle_screen.dart';
import 'package:jebena/games/fidel_duel/services/data_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Amharic player names render and persist', (tester) async {
    SharedPreferences.setMockInitialValues({});
    await tester.pumpWidget(MaterialApp(
      locale: const Locale('am'),
      theme: JebenaTheme.dark,
      home: const PlayerSetupScreen(game: fidelDuelGame, playerCount: 2),
    ));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField).first, 'ሀና ገብረ');
    await tester.pump();
    expect(find.text('ሀና ገብረ'), findsOneWidget);

    await tester.scrollUntilVisible(
      find.byType(FilledButton),
      200,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.tap(find.byType(FilledButton));
    await tester.pumpAndSettle();

    final preferences = await SharedPreferences.getInstance();
    final profiles = jsonDecode(preferences.getString('remembered_players')!)
        as List<dynamic>;
    expect(profiles.first['name'], 'ሀና ገብረ');
  });

  testWidgets('Amharic quiz fields render and save their text', (tester) async {
    QuestionData? savedQuestion;
    final inputs = [
      'ቃል',
      'ጥያቄ አንድ',
      for (var i = 1; i <= 7; i++) 'መልስ $i',
    ];
    await tester.pumpWidget(MaterialApp(
      locale: const Locale('am'),
      theme: JebenaTheme.dark,
      home: Builder(
        builder: (context) => Scaffold(
          body: TextButton(
            onPressed: () => Navigator.pushNamed(
              context,
              '/add_question',
              arguments: {
                'currentIndex': 0,
                'onSave': (QuestionData question) => savedQuestion = question,
              },
            ),
            child: const Text('open'),
          ),
        ),
      ),
      routes: {'/add_question': (_) => const AddQuestionScreen()},
    ));
    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();

    for (var i = 0; i < inputs.length; i++) {
      final field = find.byType(TextField).at(i);
      await tester.ensureVisible(field);
      await tester.enterText(field, inputs[i]);
      await tester.pump();
      expect(find.text(inputs[i]), findsOneWidget);
    }
    await tester.ensureVisible(find.byType(ElevatedButton).first);
    await tester.tap(find.byType(ElevatedButton).first);
    await tester.pumpAndSettle();

    expect(savedQuestion?.word, inputs[0]);
    expect(savedQuestion?.question, inputs[1]);
    expect(savedQuestion?.answers, inputs.skip(2).toList());
  });

  testWidgets('Amharic team name renders and saves', (tester) async {
    SharedPreferences.setMockInitialValues({});
    await DataService().loadGameSets();
    await tester.pumpWidget(MaterialApp(
      locale: const Locale('am'),
      theme: JebenaTheme.dark,
      home: const TriangleScreen(
        setId: 1,
        playerNames: ['ቡድን አንድ', 'ቡድን ሁለት'],
      ),
    ));
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.edit).first);
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField), 'ሀና ቡድን');
    expect(find.text('ሀና ቡድን'), findsOneWidget);
    await tester.tap(
      find.descendant(
        of: find.byType(AlertDialog),
        matching: find.byType(ElevatedButton),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('ሀና ቡድን'), findsOneWidget);
  });
}
