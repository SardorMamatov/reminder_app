import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'features/calendar/presentation/bloc/calendar_bloc.dart';
import 'features/calendar/presentation/pages/calendar_page.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.repo});
  final dynamic repo;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => EventBloc(repo: repo),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: const CalendarPage(),
      ),
    );
  }
}
