// Konfiguration für App-Flavors wie „dev“ (Entwicklung) und „prod“ (Produktion).
// Diese Datei ermöglicht es, Umgebungs-spezifische Einstellungen zu definieren,
// z.B. verschiedene API-URLs oder visuelle Hinweise.
//
// Verwendung:
// In der Dev-Version ein Banner anzeigen („Dev“)
// In der Prod-Version echte Datenbank verwenden

enum Flavor { dev, prod }

// Werte, die je Flavor unterschiedlich sein können
class FlavorValues {
  final String baseUrl;

  const FlavorValues({required this.baseUrl});
}

// Hauptkonfiguration für den aktuellen Flavor
class FlavorConfig {
  static late FlavorConfig _instance;

  final Flavor flavor;
  final String name;
  final FlavorValues values;
  final bool showBanner;
  final int color;

  static FlavorConfig get instance => _instance;

  FlavorConfig._internal({
    required this.flavor,
    required this.name,
    required this.values,
    this.showBanner = true,
    this.color = 0xFF00BFA5,
  });

  // Initialisierung – wird beim App-Start aufgerufen
  static void initialize({
    required Flavor flavor,
    required String name,
    required FlavorValues values,
    bool showBanner = true,
    int color = 0xFF00BFA5,
  }) {
    _instance = FlavorConfig._internal(
      flavor: flavor,
      name: name,
      values: values,
      showBanner: showBanner,
      color: color,
    );
  }
}
