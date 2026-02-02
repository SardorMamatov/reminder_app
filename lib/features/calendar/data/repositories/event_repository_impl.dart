import '../../domain/entities/event_entity.dart';
import '../../domain/repositories/event_repository.dart';
import '../datasources/event_local_datasource.dart';
import '../models/event_model.dart';

class EventRepositoryImpl implements EventRepository {
  EventRepositoryImpl({required EventLocalDataSource local}) : _local = local;
  final EventLocalDataSource _local;

  @override
  Future<int> create(EventEntity e) {
    final now = DateTime.now();
    final model = EventModel(
      id: null,
      title: e.title,
      description: e.description,
      location: e.location,
      startAt: e.startAt,
      endAt: e.endAt,
      colorHex: e.colorHex,
      remindMinutesBefore: e.remindMinutesBefore,
      createdAt: now,
      updatedAt: now,
    );
    return _local.insert(model);
  }

  @override
  Future<int> update(EventEntity e) {
    final model = EventModel(
      id: e.id,
      title: e.title,
      description: e.description,
      location: e.location,
      startAt: e.startAt,
      endAt: e.endAt,
      colorHex: e.colorHex,
      remindMinutesBefore: e.remindMinutesBefore,
      createdAt: e.createdAt,
      updatedAt: DateTime.now(),
    );
    return _local.update(model);
  }

  @override
  Future<int> delete(int id) => _local.delete(id);

  @override
  Future<List<EventEntity>> getByDay(DateTime day) => _local.getByDay(day);
  @override
  Future<List<EventEntity>> getByRange(DateTime start, DateTime end) {
    return _local.getByRange(start, end);
  }

}
