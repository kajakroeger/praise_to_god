/// Widget-Test für den ServiceScreen
///
/// Dieser Test überprüft die grundlegende Struktur des ServiceScreens.
/// Ziel ist es, sicherzustellen, dass die wichtigsten UI-Elemente korrekt
/// aufgebaut sind, bevor komplexere Logik oder dynamische Inhalte getestet werden.
///
/// Getestet wird:
/// - Ein Dropdown-Menü zur Auswahl des Teams ist sichtbar.
/// - Eine scrollbare Liste von Diensten (z. B. Cards) ist vorhanden.
/// - Die Dienstliste ist gruppiert nach Monaten (z. B. „Juli“, „August“).
/// - Eine BottomNavigationBar wird angezeigt.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:praise_to_god/screens/service.dart';

void main() {
  testWidgets('ServiceScreen zeigt Dropdown, Dienstliste und BottomNavigationBar', (
    tester,
  ) async {
    // App um den Screen herum aufbauen
    await tester.pumpWidget(
      const MaterialApp(
        home: ServiceScreen(), // 🔧 Diesen Screen willst du später erstellen
      ),
    );

    // Prüfe: Dropdown zur Teamauswahl ist vorhanden
    expect(find.byKey(const Key('teamDropdown')), findsOneWidget);

    // Prüfe: Eine Liste (ListView) ist vorhanden
    expect(find.byKey(const Key('serviceList')), findsOneWidget);

    // Prüfe: Monatsüberschriften wie „Juli“ und „August“ (können auch später dynamisch sein)
    // Da das dynamisch geladen wird, hier z. B. Platzhalter
    expect(find.textContaining('Juli'), findsOneWidget);
    expect(find.textContaining('August'), findsOneWidget);

    // Prüfe: BottomNavigationBar ist vorhanden
    expect(find.byType(BottomNavigationBar), findsOneWidget);

    // Optional: Scrollverhalten testen
    final scrollable = find.byKey(const Key('serviceList'));
    await tester.drag(scrollable, const Offset(0, -300)); // scroll nach oben
    await tester.pump();

    // Du kannst dann z. B. auf ein weiteres Element prüfen, das weiter unten erscheint
    // expect(find.text('31 SO'), findsOneWidget); // Wenn du z. B. diese Card erwartest
  });
}
