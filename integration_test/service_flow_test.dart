import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:flutter/material.dart';

import 'test_utils.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Service Flow E2E', () {
    String? selectedDateText;
    const expectedServiceName = 'TECHNIK';
    const expectedUserName = 'Kaja';

    setUpAll(() async {
      await initializeTestEnvironment();
      await signInTestUser();
      addTearDown(() async => signOutTestUser());
    });

    testWidgets(
      'User kann sich für Dienst eintragen und Dashboard zeigt es an',
      (tester) async {
        // Auf UI warten
        await tester.pumpAndSettle(const Duration(seconds: 4));

        // Navigation zur Service-Seite
        final serviceTab = find.byIcon(Icons.volunteer_activism);
        expect(serviceTab, findsOneWidget);
        await tester.tap(serviceTab);
        await tester.pumpAndSettle(const Duration(seconds: 2));

        // Dienstkarte finden & Daten merken
        final serviceCard = find.byType(Card).first;
        expect(serviceCard, findsOneWidget);

        // Datum merken (aus dem Text in der Card, z.B. „21 SO“)
        final dateTextFinder = find
            .descendant(of: serviceCard, matching: find.byType(Text))
            .first;

        final Text dateTextWidget = tester.widget<Text>(dateTextFinder);
        selectedDateText = dateTextWidget.data;

        // Dienstdialog öffnen
        await tester.tap(serviceCard);
        await tester.pumpAndSettle();

        // Eintragen bestätigen
        final confirmButton = find.widgetWithText(ElevatedButton, 'Eintragen');
        expect(confirmButton, findsOneWidget);
        await tester.tap(confirmButton);
        await tester.pumpAndSettle(const Duration(seconds: 3));

        // Zurück zum Dashboard
        final homeTab = find.byIcon(Icons.home);
        expect(homeTab, findsOneWidget);
        await tester.tap(homeTab);
        await tester.pumpAndSettle(const Duration(seconds: 2));

        // 🔍 Verifikation auf Dashboard (NextServiceCard)
        expect(find.byKey(const Key('serviceName')), findsOneWidget);
        expect(find.textContaining(expectedServiceName), findsWidgets);

        // 🔍 Benutzername prüfen
        expect(find.text(expectedUserName), findsWidgets);

        // Optional: Avatar prüfen
        expect(find.byType(CircleAvatar), findsWidgets);

        // Optional: Datum prüfen
        if (selectedDateText != null) {
          expect(find.text(selectedDateText!), findsWidgets);
        }
      },
    );
  });
}
