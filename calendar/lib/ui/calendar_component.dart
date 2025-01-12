import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:calendar/providers/selected_date_provider.dart';
import 'package:calendar/providers/week_offset_provider.dart';
import 'package:calendar/ui/calendar_tile.dart';
import 'package:provider/provider.dart';

class CalendarComponent extends StatelessWidget {
  const CalendarComponent({super.key});

  @override
  Widget build(BuildContext context) {
    final weekOffsetProvider = Provider.of<WeekOffsetProvider>(context);
    final dateProvider = Provider.of<SelectedDateProvider>(context);
    DateTime today = DateTime.now();
    DateTime currentFirstDay = today.add(Duration(days: 1 - today.weekday));
    DateTime newFirstDay =
        currentFirstDay.add(Duration(days: weekOffsetProvider.weekOffset * 7));
    return Center(
      child: Container(
        padding: const EdgeInsets.all(5),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 500),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            spacing: 15,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: () async {
                      await showDatePicker(
                        context: context,
                        initialDate: dateProvider.selectedDate,
                        firstDate: today.subtract(const Duration(days: 365)),
                        lastDate: today.add(const Duration(days: 365)),
                      ).then((selectedDate) {
                        if (selectedDate != null) {
                          DateTime selectedDateFirstWeekDay = selectedDate
                              .add(Duration(days: 1 - selectedDate.weekday));
                          weekOffsetProvider.setWeekOffset((currentFirstDay
                                      .difference(selectedDateFirstWeekDay)
                                      .inDays /
                                  -7)
                              .round());
                          dateProvider.setSelectedDate(selectedDate);
                        }
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Text(
                        DateFormat.yMMM().format(newFirstDay),
                        style: Theme.of(context)
                            .textTheme
                            .headlineMedium
                            ?.copyWith(fontWeight: FontWeight.w700),
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      IconButton(
                        onPressed: () =>
                            weekOffsetProvider.decrementWeekOffset(),
                        icon: const Icon(Icons.arrow_back_ios_rounded),
                      ),
                      IconButton(
                        onPressed: () =>
                            weekOffsetProvider.incrementWeekOffset(),
                        icon: const Icon(Icons.arrow_forward_ios_rounded),
                      )
                    ],
                  ),
                ],
              ),
              GestureDetector(
                onHorizontalDragEnd: (details) {
                  if (details.velocity.pixelsPerSecond.dx < 0) {
                    weekOffsetProvider.incrementWeekOffset();
                  }
                  if (details.velocity.pixelsPerSecond.dx > 0) {
                    weekOffsetProvider.decrementWeekOffset();
                  }
                },
                child: Row(
                  spacing: 5,
                  mainAxisSize: MainAxisSize.min,
                  children: getAllWeekDates(
                    currentFirstDay,
                    weekOffsetProvider.weekOffset,
                    weekOffsetProvider.firstDate,
                    weekOffsetProvider.lastDate,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> getAllWeekDates(DateTime firstDay, int weekOffset,
      DateTime firstDate, DateTime lastDate) {
    DateTime newFirstDay = firstDay.add(Duration(days: weekOffset * 7));
    return List.generate(7, (index) {
      DateTime date = newFirstDay.add(Duration(days: index));
      return CalendarTile(
        date: date,
        isInRange: date.isBefore(lastDate) && date.isAfter(firstDate),
      );
    });
  }
}
