import 'package:calendar/providers/selected_date_provider.dart';
import 'package:calendar/providers/week_offset_provider.dart';
import 'package:calendar/ui/calendar_component.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => SelectedDateProvider()),
          ChangeNotifierProvider(create: (context) => WeekOffsetProvider()),
        ],
        child: Scaffold(
          body: CalendarComponent(),
        ),
      ),
    );
  }
}
