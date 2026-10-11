import 'package:intl/intl.dart';

/// Formatting helpers shared by the whole UI.
class Fmt {
  Fmt._();

  static final NumberFormat _inr = NumberFormat.currency(locale: 'en_IN', symbol: '₹', decimalDigits: 0);
  static final NumberFormat _inrCompact = NumberFormat.compactCurrency(locale: 'en_IN', symbol: '₹', decimalDigits: 1);
  static final DateFormat _date = DateFormat('d MMM yyyy');
  static final DateFormat _dateShort = DateFormat('d MMM');
  static final DateFormat _dateTime = DateFormat('d MMM yyyy, h:mm a');
  static final DateFormat _time = DateFormat('h:mm a');
  static final DateFormat _weekday = DateFormat('EEE, d MMM');
  static final DateFormat _monthYear = DateFormat('MMMM yyyy');

  static String money(num? v) => v == null ? '—' : _inr.format(v);
  static String moneyCompact(num? v) => v == null ? '—' : (v.abs() < 1000 ? _inr.format(v) : _inrCompact.format(v));
  static String date(DateTime? d) => d == null ? '—' : _date.format(d);
  static String dateShort(DateTime? d) => d == null ? '—' : _dateShort.format(d);
  static String dateTime(DateTime? d) => d == null ? '—' : _dateTime.format(d);
  static String time(DateTime? d) => d == null ? '—' : _time.format(d);
  static String weekday(DateTime? d) => d == null ? '—' : _weekday.format(d);
  static String monthYear(DateTime d) => _monthYear.format(d);

  /// "Today", "Tomorrow", "Yesterday", "In 3 days", "2 days overdue".
  static String relativeDay(DateTime? d) {
    if (d == null) return '—';
    final today = DateUtilsX.startOfDay(DateTime.now());
    final target = DateUtilsX.startOfDay(d);
    final diff = target.difference(today).inDays;
    if (diff == 0) return 'Today';
    if (diff == 1) return 'Tomorrow';
    if (diff == -1) return 'Yesterday';
    if (diff > 1) return 'In $diff days';
    return '${-diff} days overdue';
  }

  static String timeAgo(DateTime d) {
    final diff = DateTime.now().difference(d);
    if (diff.inSeconds < 60) return 'just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    if (diff.inDays < 7) return '${diff.inDays}d ago';
    return date(d);
  }

  static String initials(String name) {
    final parts = name.trim().split(RegExp(r'\s+')).where((p) => p.isNotEmpty).toList();
    if (parts.isEmpty) return '?';
    if (parts.length == 1) return parts.first.substring(0, 1).toUpperCase();
    return (parts.first.substring(0, 1) + parts.last.substring(0, 1)).toUpperCase();
  }

  static String plural(int n, String one, [String? many]) {
    if (n == 1) return '$n $one';
    return '$n ${many ?? '${one}s'}';
  }
}

class DateUtilsX {
  DateUtilsX._();
  static DateTime startOfDay(DateTime d) => DateTime(d.year, d.month, d.day);
  static DateTime endOfDay(DateTime d) => DateTime(d.year, d.month, d.day, 23, 59, 59, 999);
  static DateTime addDays(DateTime d, int days) => DateTime(d.year, d.month, d.day + days, d.hour, d.minute);
  static bool isSameDay(DateTime a, DateTime b) => a.year == b.year && a.month == b.month && a.day == b.day;
  static bool isToday(DateTime d) => isSameDay(d, DateTime.now());
  static bool isPastDay(DateTime d) => startOfDay(d).isBefore(startOfDay(DateTime.now()));
  static DateTime startOfMonth(DateTime d) => DateTime(d.year, d.month, 1);
  static DateTime endOfMonth(DateTime d) => DateTime(d.year, d.month + 1, 0, 23, 59, 59);
}
