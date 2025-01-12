import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:calendar/providers/selected_date_provider.dart';
import 'package:provider/provider.dart';

class CalendarTile extends StatelessWidget {
  const CalendarTile({
    super.key,
    required this.date,
    required this.isInRange,
  });

  final DateTime date;
  final bool isInRange;

  @override
  Widget build(BuildContext context) {
    final dateProvider =
        Provider.of<SelectedDateProvider>(context, listen: true);
    final isSelectedDate = _isDateSame(date, dateProvider.selectedDate);
    final isToday = _isDateSame(date, DateTime.now());
    return isInRange
        ? ValidCalendarTile(
            dateProvider: dateProvider,
            date: date,
            isSelectedDate: isSelectedDate,
            isToday: isToday,
          )
        : InvalidCalendarTile(
            dateProvider: dateProvider,
            date: date,
          );
  }

  bool _isDateSame(DateTime date1, DateTime date2) {
    return (date1.year == date2.year) &&
        (date1.month == date2.month) &&
        (date1.day == date2.day);
  }
}

class ValidCalendarTile extends StatelessWidget {
  const ValidCalendarTile({
    super.key,
    required this.dateProvider,
    required this.date,
    required this.isSelectedDate,
    required this.isToday,
  });

  final SelectedDateProvider dateProvider;
  final DateTime date;
  final bool isSelectedDate;
  final bool isToday;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: () => dateProvider.setSelectedDate(date),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          decoration: BoxDecoration(
            color: isSelectedDate
                ? Theme.of(context).colorScheme.onPrimaryContainer
                : null,
            border: isSelectedDate
                ? Border.all(
                    width: 2,
                    color: Theme.of(context).colorScheme.onPrimaryContainer)
                : isToday
                    ? Border.all(
                        width: 2,
                        color: Theme.of(context).colorScheme.onPrimaryContainer)
                    : Border.all(
                        width: 2, color: Theme.of(context).highlightColor),
            borderRadius: BorderRadius.circular(7),
          ),
          padding: const EdgeInsets.symmetric(vertical: 5),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                DateFormat.E().format(date),
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: isSelectedDate
                          ? Theme.of(context).colorScheme.surface
                          : null,
                    ),
              ),
              Text(
                '${date.day}',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: isSelectedDate
                          ? Theme.of(context).colorScheme.surface
                          : null,
                      fontWeight: FontWeight.w700,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class InvalidCalendarTile extends StatelessWidget {
  const InvalidCalendarTile({
    super.key,
    required this.dateProvider,
    required this.date,
  });

  final SelectedDateProvider dateProvider;
  final DateTime date;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        decoration: BoxDecoration(
          border: Border.all(width: 2, color: Theme.of(context).highlightColor),
          borderRadius: BorderRadius.circular(7),
        ),
        padding: const EdgeInsets.symmetric(vertical: 5),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              DateFormat.E().format(date),
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).highlightColor,
                  ),
            ),
            Text(
              '${date.day}',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: Theme.of(context).highlightColor,
                    fontWeight: FontWeight.w700,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
