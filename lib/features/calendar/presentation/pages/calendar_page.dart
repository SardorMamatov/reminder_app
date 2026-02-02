import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reminder_app/features/calendar/presentation/bloc/calendar_bloc.dart';

import '../../../../core/utils/date_utils.dart';
import '../../domain/entities/event_entity.dart';
import '../bloc/calendar_event.dart';
import '../bloc/calendar_state.dart';
import '../widgets/calendar_panel.dart';
import 'event_details_page.dart';
import 'event_form_page.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  late final PageController _pageCtrl;
  DateTime _visibleMonth = DateTime(
    DateTime.now().year,
    DateTime.now().month,
    1,
  );

  @override
  void initState() {
    super.initState();

    final bloc = context.read<EventBloc>();
    final day = bloc.state.selectedDay;

    final initialIndex = indexForMonth(day.year, day.month);
    _pageCtrl = PageController(initialPage: initialIndex);
    _visibleMonth = DateTime(day.year, day.month, 1);

    bloc.add(LoadForDay(day));
    bloc.add(LoadMonthDots(_visibleMonth));
  }

  @override
  void dispose() {
    _pageCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: BlocBuilder<EventBloc, EventState>(
          builder: (context, state) {
            return Column(
              children: [
                LayoutBuilder(
                  builder: (context, constraints) {
                    final maxCalendarHeight =
                        constraints.maxHeight * 0.52; // 52% dan oshmasin
                    return ConstrainedBox(
                      constraints: BoxConstraints(maxHeight: maxCalendarHeight),
                      child: SingleChildScrollView(
                        physics: NeverScrollableScrollPhysics(),
                        child: CalendarPanel(
                          onHeaderDateTap: _jumpToToday,
                          pageCtrl: _pageCtrl,
                          visibleMonth: _visibleMonth,
                          selectedDate: state.selectedDay,
                          dotsByDayKey: state.dotsByDayKey,
                          onPrev: () => _pageCtrl.previousPage(
                            duration: const Duration(milliseconds: 220),
                            curve: Curves.easeOut,
                          ),
                          onNext: () => _pageCtrl.nextPage(
                            duration: const Duration(milliseconds: 220),
                            curve: Curves.easeOut,
                          ),
                          onMonthChanged: (m) {
                            setState(() => _visibleMonth = m);
                            context.read<EventBloc>().add(LoadMonthDots(m));
                          },
                          onDayTap: (d) =>
                              context.read<EventBloc>().add(LoadForDay(d)),
                          onBellTap: () {},
                        ),
                      ),
                    );
                  },
                ),

                Padding(
                  padding: const EdgeInsets.fromLTRB(12, 6, 12, 0),
                  child: Row(
                    children: [
                      const Text(
                        'Schedule',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const Spacer(),
                      ElevatedButton(
                        onPressed: () async {
                          await Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) =>
                                  EventFormPage(initialDay: state.selectedDay),
                            ),
                          );
                          context.read<EventBloc>().add(
                            LoadForDay(state.selectedDay),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF1E88E5),
                          foregroundColor: Colors.white,
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 10,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text('+ Add Event'),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 10),

                Expanded(
                  child: state.isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : state.events.isEmpty
                      ? const Center(child: Text('No events for this day'))
                      : ListView.separated(
                          padding: const EdgeInsets.all(12),
                          itemCount: state.events.length,
                          separatorBuilder: (_, __) =>
                              const SizedBox(height: 12),
                          itemBuilder: (context, i) {
                            final e = state.events[i];
                            return EventCard(
                              event: e,
                              onTap: () async {
                                await Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (_) => EventDetailsPage(event: e),
                                  ),
                                );
                                context.read<EventBloc>().add(
                                  LoadForDay(state.selectedDay),
                                );
                              },
                            );
                          },
                        ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Future<void> _jumpToToday() async {
    final today = DateTime.now();
    final day = DateTime(today.year, today.month, today.day);

    final targetIndex = indexForMonth(day.year, day.month);

    await _pageCtrl.animateToPage(
      targetIndex,
      duration: const Duration(milliseconds: 260),
      curve: Curves.easeOut,
    );

    setState(() {
      _visibleMonth = DateTime(day.year, day.month, 1);
    });

    context.read<EventBloc>().add(LoadForDay(day));

    context.read<EventBloc>().add(LoadMonthDots(_visibleMonth));
  }
}

class EventCard extends StatelessWidget {
  const EventCard({super.key, required this.event, required this.onTap});

  final EventEntity event;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final topColor = Color(event.colorHex);
    final bg = topColor.withOpacity(0.18);

    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Column(
          children: [
            Container(
              height: 8,
              decoration: BoxDecoration(
                color: topColor,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(18),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 12, 14, 14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    event.title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: topColor.withOpacity(0.9),
                    ),
                  ),
                  if ((event.description ?? '').trim().isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(
                      event.description!,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      const Icon(
                        Icons.access_time,
                        size: 16,
                        color: Colors.black54,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        '${event.startAt.hour.toString().padLeft(2, '0')}:${event.startAt.minute.toString().padLeft(2, '0')}'
                        ' - '
                        '${event.endAt.hour.toString().padLeft(2, '0')}:${event.endAt.minute.toString().padLeft(2, '0')}',
                        style: const TextStyle(color: Colors.black87),
                      ),
                      const SizedBox(width: 12),
                      if ((event.location ?? '').trim().isNotEmpty) ...[
                        const Icon(
                          Icons.place,
                          size: 16,
                          color: Colors.black54,
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            event.location!,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(color: Colors.black87),
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
