import 'package:equatable/equatable.dart';
import '../../domain/entities/event_entity.dart';

sealed class EventEvent extends Equatable {
  const EventEvent();
  @override
  List<Object?> get props => [];
}

class LoadForDay extends EventEvent {
  const LoadForDay(this.day);
  final DateTime day;

  @override
  List<Object?> get props => [day.year, day.month, day.day];
}

class CreateEventRequested extends EventEvent {
  const CreateEventRequested(this.event);
  final EventEntity event;

  @override
  List<Object?> get props => [event];
}

class UpdateEventRequested extends EventEvent {
  const UpdateEventRequested(this.event);
  final EventEntity event;

  @override
  List<Object?> get props => [event];
}

class DeleteEventRequested extends EventEvent {
  const DeleteEventRequested(this.id);
  final int id;

  @override
  List<Object?> get props => [id];
}
class LoadMonthDots extends EventEvent {
  const LoadMonthDots(this.monthFirstDay);
  final DateTime monthFirstDay;

  @override
  List<Object?> get props => [monthFirstDay.year, monthFirstDay.month];
}
