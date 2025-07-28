enum Flavor { dev, prod }

class FlavorValues {
  final String baseUrl;

  const FlavorValues({required this.baseUrl});
}

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
