import 'package:flutter_test/flutter_test.dart';
import 'package:margin/app/app.dart';

void main() {
  testWidgets('MARGIN smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const MarginApp());
    expect(find.byType(MarginApp), findsOneWidget);
    // Advance time past the splash delay without waiting indefinitely for Margo's idle repeat
    await tester.pump(const Duration(milliseconds: 2500));
    await tester.pump(const Duration(milliseconds: 100));
    expect(find.text("Your thoughts\ndeserve somewhere to go."), findsOneWidget);
  });
}
