import 'package:flutter_test/flutter_test.dart';
import 'package:jebena/main.dart';

void main() {
  testWidgets('the app opens on the player tier picker', (tester) async {
    await tester.pumpWidget(const MyApp());

    expect(find.text('ስንት ሰዎች ይጫወታሉ?'), findsOneWidget);
    expect(find.text('ብቻ'), findsOneWidget);
    expect(find.text('ስድስት እና ከዚያ በላይ'), findsOneWidget);
  });
}
