bool isLeapYear(int year) {
  if (year % 400 == 0) return true;
  if (year % 100 == 0) return false;
  return year % 4 == 0;
}

int daysInMonth(int year, int month) {
  switch (month) {
    case 1:
    case 3:
    case 5:
    case 7:
    case 8:
    case 10:
    case 12:
      return 31;
    case 4:
    case 6:
    case 9:
    case 11:
      return 30;
    case 2:
      return isLeapYear(year) ? 29 : 28;
    default:
      throw Exception('Invalid month');
  }
}

int firstWeekdayofMonth(int year, int month) {
  return DateTime(year, month, 1).weekday;
}

class CalendarDay {
  final DateTime date;
  final bool isCurrentMonth;

  const CalendarDay({required this.date, required this.isCurrentMonth});
}

List<CalendarDay> buildMonthGrid(int year, int month) {
  final List<CalendarDay> days = [];

  final firstDay = DateTime(year, month, 1);

  final firstWeekday = firstDay.weekday;

  final leadingDays = firstWeekday - 1;

  final prevMonth = month == 1 ? 12 : month - 1;
  final prevYear = month == 1 ? year - 1 : year;

  final prevMonthDays = daysInMonth(prevYear, prevMonth);

  for (int i = leadingDays - 1; i >= 0; i--) {
    days.add(
      CalendarDay(
        date: DateTime(prevYear, prevMonth, prevMonthDays - i),
        isCurrentMonth: false,
      ),
    );
  }

  final currentMonthDays = daysInMonth(year, month);
  for (int d = 1; d <= currentMonthDays; d++) {
    days.add(CalendarDay(date: DateTime(year, month, d), isCurrentMonth: true));
  }

  int nextDay = 1;
  while (days.length < 42) {
    final nextMonth = month == 12 ? 1 : month + 1;
    final nextYear = month == 12 ? year + 1 : year;

    days.add(
      CalendarDay(
        date: DateTime(nextYear, nextMonth, nextDay++),
        isCurrentMonth: false,
      ),
    );
  }

  return days;
}

const int kMinYear = 1950;
const int kMaxYear = 2950;

int totalMonthsInRange() {
  return (kMaxYear - kMinYear + 1) * 12;
}

int monthIndex(int year, int month) {
  if (year < kMinYear || year > kMaxYear) {
    throw Exception('yilni range hato $year');
  }
  if (month < 1 || month > 12) {
    throw Exception('hato oy :$month');
  }

  final yearOffset = year - kMinYear;
  final monthOffset = month - 1;
  return yearOffset * 12 + monthOffset;
}

DateTime monthFromIndex(int index) {
  final total = totalMonthsInRange();
  if (index < 0 || index >= total) {
    throw Exception('index out of range: $index');
  }

  final year = kMinYear + (index ~/ 12);
  final month = (index % 12) + 1;
  return DateTime(year, month, 1);
}

int indexForToday() {
  final now = DateTime.now();
  final clampedYear = now.year.clamp(kMinYear, kMaxYear);
  final clampedMonth = now.month;
  return monthIndex(clampedYear, clampedMonth);
}

DateTime startOfWeekMonday(DateTime date) {
  final diff = date.weekday - DateTime.monday; 
  final d = DateTime(date.year, date.month, date.day);
  return d.subtract(Duration(days: diff));
}

List<DateTime> weekDays(DateTime anyDayInWeek) {
  final start = startOfWeekMonday(anyDayInWeek);
  return List.generate(7, (i) => start.add(Duration(days: i)));
}
int indexForMonth(int year, int month) {
  const startYear = 1950;
  return (year - startYear) * 12 + (month - 1);
}