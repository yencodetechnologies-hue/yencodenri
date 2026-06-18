import 'package:flutter_test/flutter_test.dart';
import 'package:nri/main.dart';

void main() {
  testWidgets('Login screen loads', (WidgetTester tester) async {
    await tester.pumpWidget(const NriApp());
    expect(find.text('NRI Property Management'), findsOneWidget);
    expect(find.text('Login'), findsOneWidget);
  });
}
