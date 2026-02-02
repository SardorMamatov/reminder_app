import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/event_entity.dart';
import '../bloc/calendar_bloc.dart';
import '../bloc/calendar_event.dart';
import 'event_form_page.dart';

class EventDetailsPage extends StatelessWidget {
  const EventDetailsPage({super.key, required this.event});

  final EventEntity event;

  @override
  Widget build(BuildContext context) {
    String hhmm(DateTime d) => '${d.hour.toString().padLeft(2, '0')}:${d.minute.toString().padLeft(2, '0')}';
    final timeText = '${hhmm(event.startAt)} - ${hhmm(event.endAt)}';

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(12, 12, 12, 18),
              decoration: BoxDecoration(
                color: Color(event.colorHex),
                borderRadius: const BorderRadius.vertical(bottom: Radius.circular(26)),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      IconButton(
                        onPressed: () => Navigator.of(context).pop(),
                        icon: const Icon(Icons.arrow_back, color: Colors.white),
                      ),
                      const Spacer(),
                      TextButton.icon(
                        onPressed: () async {
                          await Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => EventFormPage(
                                initialDay: DateTime(event.startAt.year, event.startAt.month, event.startAt.day),
                                existing: event,
                              ),
                            ),
                          );
                          Navigator.of(context).pop();
                        },
                        icon: const Icon(Icons.edit, color: Colors.white),
                        label: const Text('Edit', style: TextStyle(color: Colors.white)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      event.title,
                      style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: Colors.white),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      const Icon(Icons.access_time, color: Colors.white, size: 18),
                      const SizedBox(width: 8),
                      Text(timeText, style: const TextStyle(color: Colors.white)),
                    ],
                  ),
                  if ((event.location ?? '').trim().isNotEmpty) ...[
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        const Icon(Icons.place, color: Colors.white, size: 18),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            event.location!,
                            style: const TextStyle(color: Colors.white),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),

            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: ListView(
                  children: [
                    const Text('Reminder', style: TextStyle(fontWeight: FontWeight.w700)),
                    const SizedBox(height: 6),
                    Text('${event.remindMinutesBefore} minutes before', style: const TextStyle(color: Colors.black54)),
                    const SizedBox(height: 18),

                    const Text('Description', style: TextStyle(fontWeight: FontWeight.w700)),
                    const SizedBox(height: 6),
                    Text(
                      (event.description ?? '').trim().isEmpty ? '-' : event.description!,
                      style: const TextStyle(color: Colors.black54),
                    ),

                    const SizedBox(height: 30),

                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFFEBEE),
                        foregroundColor: Colors.red,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      ),
                      onPressed: () {
                        final id = event.id;
                        if (id != null) {
                          context.read<EventBloc>().add(DeleteEventRequested(id));
                        }
                        Navigator.of(context).pop();
                      },
                      icon: const Icon(Icons.delete_outline),
                      label: const Text('Delete Event'),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
