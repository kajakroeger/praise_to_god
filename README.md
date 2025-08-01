# PraiseToGod
Eine Gemeinde-App, die sich in das Gemeindeleben fördert und für Gottest Wort begeistert!!
<br><br>
Die App befindet sich derzeit noch im Aufbau. Eine Testversion für Android kann unter dem folgenden Link heruntergeladen werden: [Download der aktuellen Testversion](https://github.com/kajakroeger/praise_to_god/releases/download/dev-14/app-dev-release.apk)
<br><br>

## Die App umfasst derzeit folgende Funktionen

- 🔐 **Benutzer-Login** mit Firebase Authentication (E-Mail/Passwort)
- 📆 **Dienstplan-Verwaltung**: Mitglieder können sich für Dienste (Technik, Küche etc.) eintragen

<br><br>

## Coming Soon

- 🛎️ **Benachrichtigungen**  
  Erinnern an bevorstehende Dienste & Events – um motiviert und rechtzeitig dabei zu sein.

- ✉️ **Thematische Gruppenchats**  
  Austausch zu Event-Planungen, Geburtstagsgrüßen, Gebetsanliegen u. v. m. – direkt mit dem richtigen Team oder Thema.

- 📚 **Gemeinde-Bibliothek**  
  Bücher ausleihen, Glauben vertiefen, Begeisterung für das Wort Gottes fördern.

- 🎥 **Livestream von Gottesdiensten**  
  Auch von zu Hause oder unterwegs am Gottesdienst teilhaben – verbunden bleiben trotz Entfernung.

- 📸 **Fotos teilen**  
  Eindrücke von Festen, Diensten oder Freizeiten gemeinsam erleben – Erinnerungen mit der Gemeinde teilen.

- ...

<br><br>

## ⚙️ Tech-Stack

| Bereich              | Technologie                             | Beschreibung
|----------------------|-----------------------------------------|----------------------------------------------------------------|
| Frontend             | Flutter Dart (Material Design)          | UI-Toolkit                                                     |
| Plattform            | Android (iOS folgt)                     | Entwickelt für Android plattformübergreifend mit Flutter       |
| Datenbank            | Firebase Firestore                      | NoSQL Datenbank zum Speichern von Daten wie zu User und Events |
| Authentifizierung    | Firebase Auth                           | Login per E-Mail und Passwort oder Google                      |
| Umgebungen           | flutter_dotenv, flutter_flavor          | Trennung von Dev- und Prod-Umgebungen mit Umgebungsvariablen   |
| CI/CD                | GitHub Actions                          | Automatischer Build & Release bei Push auf main / dev          |
| Testing              | flutter_test, flutter_integration_test  | Widget- und Integrationstests                                  |

<br><br>

## 🛠️ Voraussetzungen

Um dieses Projekt lokal nutzen oder weiterentwickeln zu können, brauchst du:
- Firebaseprojekt mit Firebase Auth & Firestore

<br><br>

## 🧑‍💻 Projekt lokal starten
1. Flutter SDK installieren (Version 3.32.6 oder höher)
2. Projekt klonen und zum Ordner navigieren
```
git clone https://github.com/kajakroeger/praise_to_god.git
cd praise_to_god
```

3. Abhängigkeiten installieren
```
flutter pub get
 ```

4. Lokale Umgebungsvariablen für Testuser setzen (`.env`-Datei) Beispiel
   - achte darauf, die .env-Datei ins .gitignore aufzunehmen 

```
TEST_USER_EMAIL=test@example.com
TEST_USER_PASSWORD=Gott1sGut
```

5. Firebase-Projekt einrichten
- [Flutter SDK](https://flutter.dev/docs/get-started/install)
- Eigene Firebase-Projektkonfiguration:
  - Erstelle ein neues Projekt unter https://console.firebase.google.com
  - Aktiviere Firebase Authentication und Firestore
  - Lade die Datei `google-services.json` herunter und platziere sie in `android/app/`

5. App starten (z. B. mit Dev-Flavor)
```
flutter run --flavor dev -t lib/main_dev.dart
```
<br><br>

## 🔍 Tests ausführen
Widget-Tests
```
flutter test
```
Integrationstests
```
flutter test integration_test/ --flavor dev        # testen mit dev-Ungebung
flutter test integration_test/ --flavor prod       # testen mit prod-Umgebung
```
<br><br>

## 📦 APK Build (für Dev & Prod)
```
flutter build apk --release --flavor dev -t lib/main_dev.dart     # Build für dev 
flutter build apk --release --flavor prod -t lib/main_prod.dart   # Build für prod
```

<br><br>


## 🌱 Weiterentwicklung & Feedback
Du hast Ideen, Anregungen oder Verbesserungsvorschläge hast, dann öffne gerne ein [Issue](https://github.com/kajakroeger/praise_to_god/issues) 
