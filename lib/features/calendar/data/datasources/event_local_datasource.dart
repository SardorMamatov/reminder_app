import 'package:sqflite/sqflite.dart';
import '../../../../core/db/app_database.dart';
import '../models/event_model.dart';

abstract class EventLocalDataSource {
  Future<int> insert(EventModel event);
  Future<int> update(EventModel event);
  Future<int> delete(int id);

  Future<List<EventModel>> getByDay(DateTime day);
  Future<List<EventModel>> getByRange(DateTime start, DateTime end);
}

class EventLocalDataSourceImpl implements EventLocalDataSource {
  EventLocalDataSourceImpl({required AppDatabase db}) : _db = db;
  final AppDatabase _db;

  @override
  Future<int> insert(EventModel event) async {
    final Database database = await _db.database;
    return database.insert('events', event.toMap());
  }

  @override
  Future<int> update(EventModel event) async {
    final Database database = await _db.database;
    return database.update(
      'events',
      event.toMap(),
      where: 'id = ?',
      whereArgs: [event.id],
    );
  }

  @override
  Future<int> delete(int id) async {
    final Database database = await _db.database;
    return database.delete('events', where: 'id = ?', whereArgs: [id]);
  }

  @override
  Future<List<EventModel>> getByDay(DateTime day) async {
    final Database database = await _db.database;

    final start = DateTime(day.year, day.month, day.day);
    final end = start.add(const Duration(days: 1));

    final rows = await database.query(
      'events',
      where: 'start_at >= ? AND start_at < ?',
      whereArgs: [start.millisecondsSinceEpoch, end.millisecondsSinceEpoch],
      orderBy: 'start_at ASC',
    );

    return rows.map(EventModel.fromMap).toList();
  }

  @override
  Future<List<EventModel>> getByRange(DateTime start, DateTime end) async {
  final database = await _db.database;

  final rows = await database.query(
    'events',
    where: 'start_at >= ? AND start_at < ?',
    whereArgs: [start.millisecondsSinceEpoch, end.millisecondsSinceEpoch],
    orderBy: 'start_at ASC',
  );

  return rows.map(EventModel.fromMap).toList();
}

}
