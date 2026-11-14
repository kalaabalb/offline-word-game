import 'package:flutter_test/flutter_test.dart';
import 'package:jebena/core/ethiopian_calendar.dart';

void main() {
  test('converts the Ethiopian new year date', () {
    expect(
      EthiopianCalendar.fromGregorian(DateTime(2026, 9, 11)),
      const EthiopianDate(year: 2019, month: 1, day: 1),
    );
  });

  test('converts a Gregorian date through Pagume in a leap year', () {
    const pagumeSix = EthiopianDate(year: 2015, month: 13, day: 6);
    expect(EthiopianCalendar.isLeapYear(2015), isTrue);
    expect(
        EthiopianCalendar.toGregorian(pagumeSix).add(const Duration(days: 1)),
        EthiopianCalendar.toGregorian(
            const EthiopianDate(year: 2016, month: 1, day: 1)));
    expect(
      EthiopianCalendar.fromGregorian(EthiopianCalendar.toGregorian(pagumeSix)),
      pagumeSix,
    );
  });

  test('rejects Pagume 6 in a non-leap year', () {
    expect(
      () => EthiopianCalendar.toGregorian(
        const EthiopianDate(year: 2016, month: 13, day: 6),
      ),
      throwsArgumentError,
    );
  });
}
