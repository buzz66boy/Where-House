import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wherehouse/login_screen.dart';
import 'package:video_player/video_player.dart';

void main() {
  testWidgets('BackgroundVideo widget test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(MaterialApp(
      home: BackgroundVideo(),
    ));

    // Verify that the video player is rendered.
    expect(find.byType(VideoPlayer), findsOneWidget);

    // Verify that the "SIGN IN" button is rendered.
    expect(find.text('SIGN IN'), findsOneWidget);

    // Tap the "SIGN IN" button and trigger a frame.
    await tester.tap(find.text('SIGN IN'));
    await tester.pump();

    // Verify that MyApp is navigated to.
    expect(find.text('Where?House Main Menu'), findsOneWidget);
  });
}
