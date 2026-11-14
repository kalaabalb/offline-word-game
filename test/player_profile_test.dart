import 'package:flutter_test/flutter_test.dart';
import 'package:jebena/core/player_profile.dart';

void main() {
  test('serializes and restores an Amharic player name and avatar', () {
    const profile = PlayerProfile(name: 'ሀና', avatarId: 4);

    expect(PlayerProfile.fromJson(profile.toJson()).name, 'ሀና');
    expect(PlayerProfile.fromJson(profile.toJson()).avatarId, 4);
  });
}
