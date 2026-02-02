import 'package:equatable/equatable.dart';
import '../../domain/entities/event_entity.dart';

class EventState extends Equatable {
  const EventState({
    required this.selectedDay,
    required this.isLoading,
    required this.events,
    this.error,
    required this.dotsByDayKey
  });
  final Map<int, int> dotsByDayKey; 

  final DateTime selectedDay; 
  final bool isLoading;
  final List<EventEntity> events;
  final String? error;

  factory EventState.initial() {
    final now = DateTime.now();
    return EventState(
      dotsByDayKey: const {},
      selectedDay: DateTime(now.year, now.month, now.day),
      isLoading: false,
      events: const [],
    );
  }

  EventState copyWith({
    Map<int, int>? dotsByDayKey,
    DateTime? selectedDay,
    bool? isLoading,
    List<EventEntity>? events,
    String? error,
  }) {
    return EventState(
      dotsByDayKey: dotsByDayKey ?? this.dotsByDayKey,
      selectedDay: selectedDay ?? this.selectedDay,
      isLoading: isLoading ?? this.isLoading,
      events: events ?? this.events,
      error: error,
    );
  }

  @override
  List<Object?> get props => [
        selectedDay.year,
        selectedDay.month,
        selectedDay.day,
        isLoading,
        events,
        error,
        dotsByDayKey,
      ];
}
