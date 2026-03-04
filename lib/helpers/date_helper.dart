import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

class DateHelper {
  static bool _initialized = false;

  static Future<void> init() async {
    if (!_initialized) {
      await initializeDateFormatting('id_ID', null);
      _initialized = true;
    }
  }

  /// Formats a date string (e.g. '2026-03-04') to Indonesian format
  /// e.g. 'Rabu, 4 Maret 2026'
  static String formatTanggal(String? dateStr) {
    if (dateStr == null || dateStr.isEmpty) return '-';
    try {
      final date = DateTime.parse(dateStr);
      return DateFormat('EEEE, d MMMM yyyy', 'id_ID').format(date);
    } catch (_) {
      return dateStr;
    }
  }

  /// Formats a DateTime object to Indonesian format
  static String formatDate(DateTime date) {
    return DateFormat('EEEE, d MMMM yyyy', 'id_ID').format(date);
  }

  /// Short Indonesian date format, e.g. '4 Mar 2026'
  static String formatShort(String? dateStr) {
    if (dateStr == null || dateStr.isEmpty) return '-';
    try {
      final date = DateTime.parse(dateStr);
      return DateFormat('d MMM yyyy', 'id_ID').format(date);
    } catch (_) {
      return dateStr;
    }
  }
}
