import 'package:flutter/material.dart';

import 'app.dart';
import 'core/db/app_database.dart';
import 'features/calendar/data/datasources/event_local_datasource.dart';
import 'features/calendar/data/repositories/event_repository_impl.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
   final db = AppDatabase.instance;
  final local = EventLocalDataSourceImpl(db: db);
  final repo = EventRepositoryImpl(local: local);
  
  runApp( MyApp(repo: repo));
}
