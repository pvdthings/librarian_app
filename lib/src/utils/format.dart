import 'package:intl/intl.dart';

String? formatNumber(double? n) {
  return n == null ? null : NumberFormat.decimalPattern('en').format(n);
}
