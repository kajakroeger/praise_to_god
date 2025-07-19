import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:praise_to_god/components/bottom_nav_bar.dart';

void main() {
  testWidgets('BottomNavBar zeigt alle erwarteten Navigationspunkte', (
    WidgetTester tester,
  ) async {
    // Widget einbetten
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          bottomNavigationBar: BottomNavBar(currentRoute: '/dashboard'),
        ),
      ),
    );

    // Prüfen, ob alle erwarteten Labels vorhanden sind
    expect(find.text('Home'), findsOneWidget);
    expect(find.text('Chats'), findsOneWidget);
    expect(find.text('Events'), findsOneWidget);
    expect(find.text('Dienste'), findsOneWidget);
    expect(find.text('mehr'), findsOneWidget);

    // Prüfen, ob alle Icons korrekt angezeigt werden
    expect(find.byIcon(Icons.home), findsOneWidget);
    expect(find.byIcon(Icons.chat), findsOneWidget);
    expect(find.byIcon(Icons.event), findsOneWidget);
    expect(find.byIcon(Icons.volunteer_activism), findsOneWidget);
    expect(find.byIcon(Icons.menu), findsOneWidget);
  });
}
