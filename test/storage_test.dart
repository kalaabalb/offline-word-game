import 'package:flutter_test/flutter_test.dart';
import 'package:jebena/core/storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() => SharedPreferences.setMockInitialValues({}));

  test('round trips JSON objects and lists', () async {
    const storage = JebenaStorage();
    await storage.writeJson('settings', {'language': 'am'});
    await storage.writeJsonList('players', [
      {'name': 'ሀና', 'avatarId': 2},
    ]);

    expect(await storage.readJson('settings'), {'language': 'am'});
    expect(await storage.readJsonList('players'), [
      {'name': 'ሀና', 'avatarId': 2},
    ]);
  });
}
