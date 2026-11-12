# Jebena: product and technical spec

Short version of the full plan. The longer research write-up, with sources, lives in the author's Claude project.

## Vision

One phone, one group, many games, no internet. Games are grouped by how many people are playing, so the app only shows what the room can play. Amharic first, English second.

## Principles

1. Fits the room: games are filtered by player count.
2. Small and fast: offline, no account, no heavy SDKs; target under 20 MB per architecture.
3. Feels like a game: motion, sound and haptics on every tap.
4. Cheap to extend: a game is one module plus JSON content packs.
5. Original branding: generic game names and original art.

## Launch games

| Game | Players | Notes |
| --- | --- | --- |
| Word quiz | 2 teams | Existing game; becomes the first module |
| Gebeta | 1-2 | Traditional seed-sowing board game; rule variant to be confirmed by the author |
| Spy | 3-10 | Word-impostor game: one player does not know the secret word |
| Truth or Dare | 2-10 | Spinner plus question packs |
| Act It Out | 3-10 | Charades with phone-tilt scoring |
| Tap Duels | 2-4 | Three tiny split-screen games |

Later candidates: Mafia narrator, family quiz packs, Lamlameta, Who's Most Likely, a daily word puzzle, Draw and Guess, nearby-device play.

Not suited to a phone: Genna, Akukulu, Demo, Kebeto, Kelebosh, Arenguade, Suzi.

## Player tiers

| Tier | Players |
| --- | --- |
| Solo | 1 |
| Pair | 2 |
| Trio | 3-5 |
| Party | 6+ |

A game is shown in every tier its `minPlayers..maxPlayers` range touches. The home list sorts by `addedOn`, newest first, with a "New" ribbon for 14 days.

## Session flow

1. Choose player count.
2. Enter names and pick avatars (remembered for next time).
3. Pick a game from the carousel.
4. Play three rounds.
5. Winner screen with confetti and a shareable score image; "play another" keeps the players and the running scoreboard.

## Technology

- Flutter, Android first.
- Plain Flutter widgets and `CustomPainter` for most games; Flame only where a real-time loop is needed.
- Rive for the mascot and the winner scene; built-in animation elsewhere.
- Key-value storage for players, scores and settings.
- JSON content packs loaded when a game opens.
- One Ethiopic font, subset to the glyphs used.
- No network access in v1.

## Visual direction

Dark roasted-brown background, cream text, terracotta and saffron accents. Chunky rounded shapes, large Ethiopic type, a jebena mascot that steams, pours and wobbles. Every game has one animated signature moment. Short mono sound clips with a mute switch. Haptics where they help. A reduced-motion setting.

## Roadmap

| Week | Goal |
| --- | --- |
| 1 | Rename, shell, plugin interface, tier picker, theme, scoreboard, size check, port the word quiz |
| 2 | Gebeta and Truth or Dare |
| 3 | Spy and Act It Out |
| 4 | Tap Duels, mascot and winner scene, low-end phone test, size pass, `v0.1.0` |

## Open questions for the author

1. Rules of the other TV and family games, as your family plays them.
2. Which Gebeta variant your family uses.
3. Spelling and use of the three coffee-ceremony round names.
4. Whether the store names "Jebena" are available.
