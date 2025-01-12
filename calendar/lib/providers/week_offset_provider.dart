import 'package:flutter/material.dart';

class WeekOffsetProvider extends ChangeNotifier {
  int _weekOffset = 0;
  final DateTime _firstDate = DateTime.now().add(const Duration(days: -365));
  final DateTime _lastDate = DateTime.now().add(const Duration(days: 366));

  int get weekOffset => _weekOffset;
  DateTime get firstDate => _firstDate;
  DateTime get lastDate => _lastDate;

  void setWeekOffset(int offset) {
    _weekOffset = offset;
    notifyListeners();
  }

  void incrementWeekOffset() {
    DateTime today = DateTime.now();
    DateTime offsetWeekFirstDate =
        today.add(Duration(days: 7 * (weekOffset + 1) + (1 - today.weekday)));
    if (offsetWeekFirstDate.isBefore(lastDate)) {
      _weekOffset++;
      notifyListeners();
    }
  }

  void decrementWeekOffset() {
    DateTime today = DateTime.now();
    DateTime offsetWeekLastDate =
        today.add(Duration(days: 7 * (weekOffset - 1) + (7 - today.weekday)));
    if (offsetWeekLastDate.isAfter(firstDate)) {
      _weekOffset--;
      notifyListeners();
    }
  }
}
