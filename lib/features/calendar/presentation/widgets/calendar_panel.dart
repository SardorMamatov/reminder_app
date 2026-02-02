import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:reminder_app/core/utils/date_utils.dart';

import 'month_grid.dart';

class CalendarPanel extends StatelessWidget {
  const CalendarPanel({
    super.key,
    required this.pageCtrl,
    required this.visibleMonth,
    required this.selectedDate,
    required this.onPrev,
    required this.onNext,
    required this.onMonthChanged,
    required this.onDayTap,
    this.onBellTap,
    required this.onHeaderDateTap,
    required this.dotsByDayKey,
  });
  final VoidCallback onHeaderDateTap;

  final PageController pageCtrl;
  final DateTime visibleMonth;
  final DateTime selectedDate;

  final VoidCallback onPrev;
  final VoidCallback onNext;
  final ValueChanged<DateTime> onMonthChanged;
  final ValueChanged<DateTime> onDayTap;

  final VoidCallback? onBellTap;
  final Map<int, int> dotsByDayKey;

  @override
  Widget build(BuildContext context) {
    final bg = const Color(0xFFF6F7F9);
    final border = const Color(0xFFE3E7EE);

    return Container(
      margin: const EdgeInsets.all(12),
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 16),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: border, width: 1),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          InkWell(onTap: onHeaderDateTap,
            child: _TopDayHeader(selectedDate: selectedDate, onBellTap: onBellTap)),
          const SizedBox(height: 16),

          _MonthHeader(
            title: DateFormat('MMMM').format(visibleMonth),
            onPrev: onPrev,
            onNext: onNext,
          ),
          const SizedBox(height: 10),

          const _WeekdayRowSundayStart(),
          const SizedBox(height: 10),

          SizedBox(
            height: 320,
            child: PageView.builder(
              physics: BouncingScrollPhysics(),
              controller: pageCtrl,
              itemCount: totalMonthsInRange(),
              onPageChanged: (index) => onMonthChanged(monthFromIndex(index)),
              itemBuilder: (context, index) {
                final monthDate = monthFromIndex(index);
                final grid = buildMonthGrid(monthDate.year, monthDate.month);

                return MonthGrid(
                  days: grid,
                  selectedDate: selectedDate,
                  onDayTap: onDayTap,
                  dotsByDayKey: dotsByDayKey,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _TopDayHeader extends StatelessWidget {
  const _TopDayHeader({required this.selectedDate, this.onBellTap});

  final DateTime selectedDate;
  final VoidCallback? onBellTap;

  @override
  Widget build(BuildContext context) {
    final weekday = DateFormat('EEEE').format(selectedDate);
    final dateText = DateFormat('d MMMM yyyy').format(selectedDate);

    return Row(
      children: [
        Expanded(
          child: Column(
            children: [
              Text(
                weekday,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 4),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    dateText,
                    style: const TextStyle(fontSize: 12, color: Colors.black54),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _MonthHeader extends StatelessWidget {
  const _MonthHeader({
    required this.title,
    required this.onPrev,
    required this.onNext,
  });

  final String title;
  final VoidCallback onPrev;
  final VoidCallback onNext;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
          ),
        ),
        _CircleIconButton(icon: Icons.chevron_left, onTap: onPrev),
        const SizedBox(width: 8),
        _CircleIconButton(icon: Icons.chevron_right, onTap: onNext),
      ],
    );
  }
}

class _CircleIconButton extends StatelessWidget {
  const _CircleIconButton({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          border: Border.all(color: const Color(0xFFE3E7EE)),
        ),
        child: Icon(icon, size: 20),
      ),
    );
  }
}

class _WeekdayRowSundayStart extends StatelessWidget {
  const _WeekdayRowSundayStart();

  @override
  Widget build(BuildContext context) {
    const labels = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];

    return Row(
      children: List.generate(7, (i) {
        return Expanded(
          child: Center(
            child: Text(
              labels[i],
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
          ),
        );
      }),
    );
  }
}
