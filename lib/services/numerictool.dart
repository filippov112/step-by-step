import 'package:intl/intl.dart';

class NumericTool {
  static String toThousandString(int value) {
    return NumberFormat('#,##0', 'en_US').format(value);
  }
}