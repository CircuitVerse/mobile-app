import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

// Shared central logger: debug level in debug builds, warning and above in release builds.
final Logger appLogger = Logger(
    filter: kReleaseMode ? ProductionFilter() : DevelopmentFilter(),
    level: kReleaseMode ? Level.warning : Level.debug,
    printer: PrettyPrinter(),
  );
