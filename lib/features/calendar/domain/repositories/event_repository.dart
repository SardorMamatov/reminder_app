import '../entities/event_entity.dart';

abstract class EventRepository {
  Future<int> create(EventEntity e);
  Future<int> update(EventEntity e);
  Future<int> delete(int id);
  Future<List<EventEntity>> getByDay(DateTime day);
  Future<List<EventEntity>> getByRange(DateTime start, DateTime end);

}
