import 'package:flutter_test/flutter_test.dart';
import 'package:xiishopy_erp/app.dart';

void main() {
  testWidgets('Xiishopy ERP splash screen renders', (WidgetTester tester) async {
    await tester.pumpWidget(const XiishopyERPApp());
    expect(find.text('Xiishopy ERP'), findsOneWidget);
  });
}