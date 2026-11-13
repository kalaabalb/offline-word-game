# Jebena

Jebena is an offline party-game app for families and friends. It puts Amharic
first, with English available on English-language devices.

## What works today

The app has a player-tier picker and one playable game, **Fidel Word Duel**.
Two players take turns as two teams. A board contains six questions; each
question has a clue word and seven answers. A team has 30 seconds to mark the
answers it finds. It earns one point per marked answer plus one point for every
five seconds remaining. Turns alternate until all six questions have been
played. See [the game rules](lib/games/fidel_duel/README.md).

Player names and avatar choices are remembered on the device. Completed game
scores are saved locally and shown on the scoreboard. The app does not require
an account or internet access.

Other games in the product plan are not implemented yet. See
[the product specification](docs/SPEC.md) for the direction and open questions.

## Run it

Install Flutter with Dart 3.4.1 or later, then run:

```sh
git clone https://github.com/kalaabalb/jebena.git
cd jebena
flutter pub get
flutter run
```

Check the project with:

```sh
flutter analyze
flutter test
flutter build apk --release --split-per-abi
```

GitHub Actions runs these checks and reports the size of each release APK. The
size target is under 20 MB per architecture.

## Contributing

Read [CONTRIBUTING.md](CONTRIBUTING.md) before proposing a change. Bug reports,
Amharic language improvements, and testing on lower-end Android phones are
welcome.

## Licence

The project is licensed under MIT. The Noto Sans Ethiopic font is separately
licensed under the SIL Open Font License; see [its licence](assets/fonts/OFL.txt).
