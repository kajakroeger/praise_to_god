// Stellt sicher, dass die BottomNavBar korrekt angezeigt wird und alle erwarteten Elemente enthält.
// Prüft, ob Text und Icons zu den Screens Dashboard, Service und Profil vorhanden sind

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

    // Prüfen, ob die NavBarIcons mit Label vorhanden sind
    expect(find.byKey(const Key('homeNavBarIcon')), findsOneWidget);
    expect(find.byKey(const Key('serviceNavBarIcon')), findsOneWidget);
    expect(find.byKey(const Key('profileNavBarIcon')), findsOneWidget);
  });
}
