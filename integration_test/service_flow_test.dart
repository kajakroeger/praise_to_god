// E2E-Test, der prüft, ob User sich auf dem Service-Screen zu einem Dienst eintraggen können
// Der User sollte auf der Karte der verfügbaren Dienst angezeigt werden, sowie im Dashboard in der NextServiceCard

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:flutter/material.dart';
import 'package:praise_to_god/app.dart';
import 'package:praise_to_god/services/firebase_options.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'test_utils.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    await dotenv.load(fileName: '.env');
    await initializeDateFormatting('de_DE', null);

    if (Firebase.apps.isEmpty) {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
    }

    await signInTestUser();
  });

  tearDownAll(() async {
    await signOutTestUser();
  });

  group('Service Flow E2E', () {
    const expectedUserName = 'Kaja';

    testWidgets(
      'User kann sich für einen Dienst eintragen und es wird korrekt angezeigt',
      (tester) async {
        await tester.pumpWidget(const MyApp());
        await tester.pumpAndSettle(const Duration(seconds: 5));

        // Zum Service-Screen wechseln
        final serviceTab = find.byKey(const Key('serviceNavBarIcon'));
        expect(serviceTab, findsOneWidget);
        await tester.tap(serviceTab);
        await tester.pumpAndSettle(const Duration(seconds: 3));

        // Finde eine Karte ohne den User (für neue Eintragung)
        final allCards = find.byType(Card);
        expect(allCards, findsWidgets);

        Finder? availableCardFinder;
        String? selectedDate;

        for (int i = 0; i < allCards.evaluate().length; i++) {
          final cardFinder = allCards.at(i);

          final userInCard = find.descendant(
            of: cardFinder,
            matching: find.text(expectedUserName),
          );
          // Suche eine Karte, auf der der User noch NICHT eingetragen ist
          if (userInCard.evaluate().isEmpty) {
            availableCardFinder = cardFinder;

            // Extrahiere das Datum aus der Karte für spätere Validierung
            final cardTexts = find.descendant(
              of: cardFinder,
              matching: find.byType(Text),
            );

            for (final textElement in cardTexts.evaluate()) {
              final textWidget = textElement.widget as Text;
              final textData = textWidget.data ?? '';

              // Suche nach Service-Screen Format "DD SO"
              final datePattern = RegExp(r'(\d{2}) (MO|DI|MI|DO|FR|SA|SO)');
              final match = datePattern.firstMatch(textData);
              if (match != null) {
                selectedDate = match.group(0); // z.B. "27 SO"
                break;
              }
            }
            break;
          }
        }

        expect(
          availableCardFinder,
          isNotNull,
          reason: 'Verfügbare Service-Karte sollte gefunden werden',
        );
        expect(
          selectedDate,
          isNotNull,
          reason: 'Datum sollte aus der Karte extrahiert werden',
        );

        // In verfügbare Karte eintragen
        await tester.tap(availableCardFinder!);
        await tester.pumpAndSettle(const Duration(seconds: 2));

        final confirmButton = find.widgetWithText(ElevatedButton, 'Eintragen');
        expect(confirmButton, findsOneWidget);
        await tester.tap(confirmButton);
        await tester.pumpAndSettle(const Duration(seconds: 5));

        // Service-Screen Validierung: User und Avatar sollten jetzt sichtbar sein
        expect(find.text(expectedUserName), findsWidgets);
        expect(find.byType(CircleAvatar), findsWidgets);

        // Zurück zum Dashboard
        final homeTab = find.byKey(const Key('homeNavBarIcon'));
        expect(homeTab, findsOneWidget);
        await tester.tap(homeTab);
        await tester.pumpAndSettle(const Duration(seconds: 5));

        expect(
          find.text(expectedUserName),
          findsWidgets,
          reason: 'User-Name sollte auf Dashboard sichtbar sein',
        );
        expect(
          find.byType(CircleAvatar),
          findsWidgets,
          reason: 'Avatar sollte auf Dashboard sichtbar sein',
        );

        // Prüfe, ob der Service-Name angezeigt wird
        final serviceNames = ['TECH', 'WORSHIP', 'KITCHEN', 'WELCOME'];
        bool serviceFound = false;
        for (final serviceName in serviceNames) {
          if (find.textContaining(serviceName).evaluate().isNotEmpty) {
            serviceFound = true;
            break;
          }
        }
        expect(
          serviceFound,
          isTrue,
          reason: 'Ein Service-Name sollte auf Dashboard angezeigt werden',
        );

        // ignore: avoid_print
        print(
          '✅ Test erfolgreich: User hat sich eingetragen und wird korrekt angezeigt',
        );
      },
    );
  });
}
