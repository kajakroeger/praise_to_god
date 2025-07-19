import 'package:logger/logger.dart';

final logger = Logger(
  level: Level.debug, // Immer debuggen (du kannst später "info" draus machen)
  printer: PrettyPrinter(
    methodCount: 2,
    errorMethodCount: 5,
    lineLength: 80,
    colors: true,
    printEmojis: true,
    printTime: true, // Setze auf true, um Zeitstempel zu sehen
  ),
);
