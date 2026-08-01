import 'package:result/result.dart';
import 'package:tasker/utils/duration_parse.dart';

extension StringToDuration on String {
  Result<Duration, FormatException> parseAsDuration() => parseDuration(this);
}
