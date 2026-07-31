// Smoke test dasar untuk CMMS SIGMA.
import 'package:flutter_test/flutter_test.dart';
import 'package:cmms_sigma/main.dart';

void main() {
  testWidgets('App boots without crashing', (WidgetTester tester) async {
    await tester.pumpWidget(const CmmsSigmaApp());
    expect(tester.takeException(), isNull);
  });
}
