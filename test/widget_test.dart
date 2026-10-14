

import 'package:alpha_products/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';


void main() {
  testWidgets('AlphaApp loads successfully test', (WidgetTester tester) async {
    await tester.pumpWidget(const AlphaApp());
    await tester.pumpAndSettle();

    // Verify app renders
    expect(find.text('Alpha Products'), findsWidgets);
  });
}
