import 'package:flutter/material.dart';
import 'package:reminder_app/core/utils/date_utils.dart';

class MonthGrid extends StatelessWidget {
  const MonthGrid({
    super.key,
    required this.days,
    required this.selectedDate,
    required this.onDayTap,
    required this.dotsByDayKey,
  });

  final List<CalendarDay> days;
  final DateTime selectedDate;
  final ValueChanged<DateTime> onDayTap;
  final Map<int, int> dotsByDayKey;

  bool _isSameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  int _dayKey(DateTime d) => d.year * 10000 + d.month * 100 + d.day;

  @override
  Widget build(BuildContext context) {
    final today = DateTime.now();

    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 7,
        mainAxisSpacing: 6,
        crossAxisSpacing: 6,
      ),
      itemCount: 42,
      itemBuilder: (context, index) {
        final day = days[index];

        final isSelected = _isSameDay(day.date, selectedDate);
        final isToday = _isSameDay(day.date, today);

        final bg = isSelected
            ? Colors.blue
            : isToday
                ? Colors.blue.withOpacity(0.15)
                : Colors.transparent;

        final border = isToday && !isSelected
            ? Border.all(color: Colors.blue, width: 1)
            : null;

        final dotColor = dotsByDayKey[_dayKey(day.date)];

        return InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: () => onDayTap(day.date),
          child: Container(
            decoration: BoxDecoration(
              color: bg,
              border: border,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '${day.date.day}',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: isSelected
                        ? Colors.white
                        : (day.isCurrentMonth ? Colors.black : Colors.black45),
                  ),
                ),
                const SizedBox(height: 2),
                if (dotColor != null)
                  Container(
                    width: 6,
                    height: 6,
                    decoration: BoxDecoration(
                      color: isSelected ? Colors.white : Color(dotColor),
                      shape: BoxShape.circle,
                    ),
                  )
                else
                  const SizedBox(height: 6),
              ],
            ),
          ),
        );
      },
    );
  }
}
