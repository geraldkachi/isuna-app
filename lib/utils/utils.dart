import 'package:intl/intl.dart';

class Utils {
  static String formatNumber(String numberString) {
  if (numberString.isEmpty) {
    return '';
  }

  try {
    final number = double.parse(numberString);
    final formatter = NumberFormat('#,##0.##');
    return formatter.format(number);
  } catch (e) {
    return numberString; // Return the original string if parsing fails
  }
}
}