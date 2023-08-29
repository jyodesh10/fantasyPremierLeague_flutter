

import 'package:timezone/timezone.dart' as tz;

timeConvert(DateTime date) {
  final utcTime = date.millisecondsSinceEpoch;
  var loc = tz.getLocation('Asia/Kathmandu');
  return loc.translateToUtc(utcTime);
}