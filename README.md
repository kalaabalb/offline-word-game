# Jebena

**Gather around.** Offline party games in Amharic for families and friends, all in one light Android app.

> **Status: early.** Today this repo contains one playable game, a two-team Amharic word quiz. Jebena is the plan to grow it into a library of games sorted by how many people are playing. The roadmap is below; nothing listed there as "planned" exists yet.

## Why

Ethiopian families already gather for hours around the coffee ceremony. Jebena is for that time: one phone passed around the room, no internet, no account, and games that speak Amharic. It started when a family wanted to play a TV-style word game at home and the author built one.

## What works today

**Word quiz (two teams).**

- Two teams take turns picking one of six questions on a triangle board.
- Each question has a hidden word and up to seven answers to find.
- A 30-second timer runs per question; teams score for the answers found.
- Question sets are stored on the device, and you can add your own sets and questions inside the app.
- Amharic interface using the Noto Sans Ethiopic font.

## Planned

| Game | Players | Status |
| --- | --- | --- |
| Word quiz (the game above) | 2 teams | Playable |
| Gebeta (traditional seed-sowing board game) | 1-2 | Planned |
| Spy (find the player who does not know the word) | 3-10 | Planned |
| Truth or Dare | 2-10 | Planned |
| Act It Out (charades with phone tilt) | 3-10 | Planned |
| Tap Duels (tiny split-screen games) | 2-4 | Planned |

The home screen will ask "How many are playing?" and show only the games that fit, with the newest game on top. Full design: [docs/SPEC.md](docs/SPEC.md).

## Run it

You need [Flutter](https://docs.flutter.dev/get-started/install) (Dart SDK 3.4 or newer).

```bash
git clone https://github.com/kalaabalb/offline-word-game.git
cd offline-word-game
flutter pub get
flutter run
```

The repository is being renamed to `jebena`; GitHub redirects the old address.

## Contribute

You do not need to write code to help.

- **Add questions.** Write Amharic word-and-answers sets for the quiz.
- **Test on a cheap phone.** Report slow screens or crashes, with your phone model.
- **Suggest a game** your family plays, and explain the rules.

Read [CONTRIBUTING.md](CONTRIBUTING.md) once it exists, and see [AGENTS.md](AGENTS.md) if you are using an AI coding agent.

## Licence

No licence file has been added yet. The author will choose one (MIT is the plan) before accepting outside contributions.
