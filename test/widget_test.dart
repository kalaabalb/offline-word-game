import 'package:flutter_test/flutter_test.dart';
import 'package:jebena/main.dart';

void main() {
  testWidgets('the app opens on the player tier picker', (tester) async {
    await tester.pumpWidget(const MyApp());

    expect(find.text('How many are playing?'), findsOneWidget);
    expect(find.text('Solo'), findsOneWidget);
    expect(find.text('Party'), findsOneWidget);
  });
}
