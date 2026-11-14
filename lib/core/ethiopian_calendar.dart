class EthiopianDate {
  const EthiopianDate({
    required this.year,
    required this.month,
    required this.day,
  });

  final int year;
  final int month;
  final int day;

  String get monthNameAm => EthiopianCalendar.monthNamesAm[month - 1];

  @override
  String toString() => '$day $monthNameAm $year';

  @override
  bool operator ==(Object other) =>
      other is EthiopianDate &&
      year == other.year &&
      month == other.month &&
      day == other.day;

  @override
  int get hashCode => Object.hash(year, month, day);
}

class EthiopianCalendar {
  EthiopianCalendar._();

  static const int _epochJdn = 1723856;
  static const List<String> monthNamesAm = [
    'መስከረም',
    'ጥቅምት',
    'ኅዳር',
    'ታኅሣሥ',
    'ጥር',
    'የካቲት',
    'መጋቢት',
    'ሚያዝያ',
    'ግንቦት',
    'ሰኔ',
    'ሐምሌ',
    'ነሐሴ',
    'ጳጉሜን',
  ];

  static bool isLeapYear(int year) => year % 4 == 3;

  static EthiopianDate fromGregorian(DateTime date) {
    final jdn = _gregorianToJdn(date.year, date.month, date.day);
    final elapsed = jdn - _epochJdn;
    final remainder = elapsed % 1461;
    final dayOfYear = remainder % 365 + 365 * (remainder ~/ 1460);
    final year = 4 * (elapsed ~/ 1461) + remainder ~/ 365 - remainder ~/ 1460;
    return EthiopianDate(
      year: year,
      month: dayOfYear ~/ 30 + 1,
      day: dayOfYear % 30 + 1,
    );
  }

  static DateTime toGregorian(EthiopianDate date) {
    if (date.year < 1 || date.month < 1 || date.month > 13 || date.day < 1) {
      throw ArgumentError.value(date, 'date', 'Invalid Ethiopian date.');
    }
    final maxDay = date.month == 13 ? (isLeapYear(date.year) ? 6 : 5) : 30;
    if (date.day > maxDay) {
      throw ArgumentError.value(date, 'date', 'Invalid Ethiopian date.');
    }
    final jdn = _epochJdn +
        365 * date.year +
        date.year ~/ 4 +
        30 * (date.month - 1) +
        date.day -
        1;
    return _jdnToGregorian(jdn);
  }

  static int _gregorianToJdn(int year, int month, int day) {
    final a = (14 - month) ~/ 12;
    final y = year + 4800 - a;
    final m = month + 12 * a - 3;
    return day +
        (153 * m + 2) ~/ 5 +
        365 * y +
        y ~/ 4 -
        y ~/ 100 +
        y ~/ 400 -
        32045;
  }

  static DateTime _jdnToGregorian(int jdn) {
    var r = jdn + 68569;
    final n = 4 * r ~/ 146097;
    r -= (146097 * n + 3) ~/ 4;
    var year = 4000 * (r + 1) ~/ 1461001;
    r -= 1461 * year ~/ 4 - 31;
    final month = 80 * r ~/ 2447;
    final day = r - 2447 * month ~/ 80;
    r = month ~/ 11;
    final gregorianMonth = month + 2 - 12 * r;
    year = 100 * (n - 49) + year + r;
    return DateTime(year, gregorianMonth, day);
  }
}
