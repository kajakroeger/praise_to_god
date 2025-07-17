import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:praise_to_god/screens/dashboard.dart';

void main() {
  testWidgets('Dashboard enthält alle erwarteten Komponenten', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: DashboardScreen()));

    // Prüfe, ob NextServiceCard vorhanden ist
    expect(find.byKey(const Key('nextServiceCard')), findsOneWidget);

    // Prüfe, ob BottomMenuBar vorhanden ist
    expect(find.byKey(const Key('bottomMenuBar')), findsOneWidget);

    // Falls weitere Komponenten kommen, kannst du sie hier ergänzen
    // expect(find.byKey(Key('eventOverview')), findsOneWidget);
  });
}
