
  /// Based from [Duration.toString()]
Duration parseDuration(String str) {
    try {
      final [hours, minutes, seconds, microseconds] = str
          .split(":")
          .map(int.parse)
          .toList();
      final actualDays = hours ~/ 24;
      final actualHours = hours % 24;
      final actualMinutes = minutes;
      final actualSeconds = seconds;
      final actualMillis = microseconds ~/ 1000;
      final actualMicros = microseconds % 1000;
      return Duration(
        days: actualDays,
        hours: actualHours,
        minutes: actualMinutes,
        seconds: actualSeconds,
        milliseconds: actualMillis,
        microseconds: actualMicros,
      );
    } on Exception {
      throw FormatException("Could not get a valid Duration from $str");
    }
  }

