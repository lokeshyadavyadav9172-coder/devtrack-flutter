import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:devtrack/main.dart';

void main() {
  testWidgets('DevTrack app launches on mobile', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 3.0;

    await tester.pumpWidget(const DevTrackApp());

    expect(find.text('Good morning, Developer 👋'), findsOneWidget);
    expect(find.text('Active Projects'), findsOneWidget);
    expect(find.byType(NavigationBar), findsOneWidget);

    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
  });
}
