// Stellt eine zentrale Logger-Instanz bereit, die für Debug-Ausgaben im Terminal genutzt werden kann.
// Der Logger verwendet Farben, Emojis und Zeitstempeln

import 'package:logger/logger.dart';

final logger = Logger(
  level: Level.debug,
  printer: PrettyPrinter(
    methodCount: 2,
    errorMethodCount: 5,
    lineLength: 80,
    colors: true,
    printEmojis: true,
    dateTimeFormat: DateTimeFormat.onlyTimeAndSinceStart,
  ),
);
