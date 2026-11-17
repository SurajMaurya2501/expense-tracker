import 'package:intl/intl.dart';

class MonthKey {
  static final _key = DateFormat('MM-yyyy');
  static final _chip = DateFormat('MMM yyyy');
  static final _title = DateFormat('MMMM yyyy');
  static final _day = DateFormat('d MMM');
  static final _fullDay = DateFormat('d MMM yyyy');

  static String of(DateTime date) => _key.format(date);

  /// Parses a stored `MM-yyyy` key. Returns null when the value is not a month.
  static DateTime? tryParse(String value) {
    final parts = value.split('-');
    if (parts.length != 2) return null;
    final month = int.tryParse(parts[0]);
    final year = int.tryParse(parts[1]);
    if (month == null || year == null) return null;
    if (month < 1 || month > 12 || year < 1) return null;
    return DateTime(year, month);
  }

  static String chipLabel(DateTime date) => _chip.format(date);

  static String title(DateTime date) => _title.format(date);

  static String dayLabel(DateTime date) => _day.format(date);

  static String fullDay(DateTime date) => _fullDay.format(date);
}
