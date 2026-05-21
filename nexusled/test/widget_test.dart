import 'package:flutter_test/flutter_test.dart';

import 'package:nexusled/main.dart';

void main() {
  testWidgets('NexusLED app boots', (WidgetTester tester) async {
    await tester.pumpWidget(const NexusLedApp());

    await tester.pump();

    expect(find.text('NexusLED'), findsWidgets);
  });
}
