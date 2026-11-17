import 'package:intl/intl.dart';

class MonthKey {
  static final _key = DateFormat('MM-yyyy');
  static final _chip = DateFormat('MMM yyyy');
  static final _title = DateFormat('MMMM yyyy');
  static final _day = DateFormat('d MMM');
  static final _fullDay = DateFormat('d MMM yyyy');

  static String of(DateTime date) => _key.format(date);

  static String chipLabel(DateTime date) => _chip.format(date);

  static String title(DateTime date) => _title.format(date);

  static String dayLabel(DateTime date) => _day.format(date);

  static String fullDay(DateTime date) => _fullDay.format(date);

  static List<DateTime> recent({int count = 12, DateTime? from}) {
    final anchor = from ?? DateTime.now();
    final start = DateTime(anchor.year, anchor.month);
    return [
      for (var i = 0; i < count; i++) DateTime(start.year, start.month - i),
    ];
  }
}
