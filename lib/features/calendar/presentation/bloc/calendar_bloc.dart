import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reminder_app/features/calendar/presentation/bloc/calendar_event.dart';
import '../../domain/repositories/event_repository.dart';
import 'calendar_state.dart';

class EventBloc extends Bloc<EventEvent, EventState> {
  EventBloc({required EventRepository repo})
      : _repo = repo,
        super(EventState.initial()) {
    on<LoadForDay>(_onLoadForDay);
    on<CreateEventRequested>(_onCreate);
    on<UpdateEventRequested>(_onUpdate);
    on<DeleteEventRequested>(_onDelete);
    on<LoadMonthDots>(_onLoadMonthDots);

  }

  final EventRepository _repo;
int _dayKey(DateTime d) => d.year * 10000 + d.month * 100 + d.day;

  DateTime _onlyDate(DateTime d) => DateTime(d.year, d.month, d.day);
Future<void> _onLoadMonthDots(LoadMonthDots e, Emitter<EventState> emit) async {
  final start = DateTime(e.monthFirstDay.year, e.monthFirstDay.month, 1);
  final end = DateTime(start.year, start.month + 1, 1);

  try {
    final list = await _repo.getByRange(start, end);

    final map = <int, int>{};
    for (final ev in list) {
      final k = _dayKey(DateTime(ev.startAt.year, ev.startAt.month, ev.startAt.day));
      map.putIfAbsent(k, () => ev.colorHex);
    }

    emit(state.copyWith(dotsByDayKey: map));
  } catch (_) {
  }
}

  Future<void> _onLoadForDay(LoadForDay e, Emitter<EventState> emit) async {
    final day = _onlyDate(e.day);
    emit(state.copyWith(selectedDay: day, isLoading: true, error: null));
    try {
      final list = await _repo.getByDay(day);
      emit(state.copyWith(isLoading: false, events: list));
    } catch (err) {
      emit(state.copyWith(isLoading: false, error: err.toString()));
    }
  }

  Future<void> _onCreate(CreateEventRequested e, Emitter<EventState> emit) async {
    try {
      await _repo.create(e.event);
    } catch (_) {}
    add(LoadForDay(state.selectedDay));
    add(LoadMonthDots(DateTime(state.selectedDay.year, state.selectedDay.month, 1)));
  }

  Future<void> _onUpdate(UpdateEventRequested e, Emitter<EventState> emit) async {
    try {
      await _repo.update(e.event);
    } catch (_) {}
    add(LoadForDay(state.selectedDay));
    add(LoadMonthDots(DateTime(state.selectedDay.year, state.selectedDay.month, 1)));
  }

  Future<void> _onDelete(DeleteEventRequested e, Emitter<EventState> emit) async {
    try {
      await _repo.delete(e.id);
    } catch (_) {}
    add(LoadForDay(state.selectedDay));
    add(LoadMonthDots(DateTime(state.selectedDay.year, state.selectedDay.month, 1)));
  }
}
