import 'package:intl/intl.dart';

class NumericTool {
  static String toThousandString(int value) {
    return NumberFormat('#,##0', 'en_US').format(value);
  }
  static String toZeroFormat(int value, int zeroCount) {
    return NumberFormat('0' * zeroCount, 'en_US').format(value);
  }
}