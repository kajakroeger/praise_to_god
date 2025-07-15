import 'package:logger/logger.dart';
import '../flavor_config.dart';

final logger = Logger(
  level: _getLogLevel(),
  printer: PrettyPrinter(
    methodCount: 2,
    errorMethodCount: 5,
    lineLength: 80,
    colors: true,
    printEmojis: true,
    printTime: false,
  ),
);

Level _getLogLevel() {
  switch (FlavorConfig.instance.flavor) {
    case Flavor.dev:
      return Level.debug;
    case Flavor.prod:
      return Level.nothing; // Keine Logs in Produktion
    default:
      return Level.debug;
  }
}
