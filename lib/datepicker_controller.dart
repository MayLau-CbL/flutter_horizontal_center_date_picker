import 'package:flutter/material.dart';

///controller for scrolling the [HorizontalDatePickerWidget]
class DatePickerController {
  ///scroll to current selected date's position
  ///[isEnableAnimation] default set as true, jump with animation
  void scrollToSelectedItem([bool isEnableAnimation = true]) {
    if (realStartDate != null && selectedDate != null) {
      int index = selectedDate!.difference(realStartDate!).inDays;
      _scrollToSpecificDateByIndex(index);
    }
  }

  ///scroll to specific date's position
  ///[isEnableAnimation] default set as true, jump with animation
  void scrollTo(DateTime dateTime, [bool isEnableAnimation = true]) {
    if (isWithinRange(dateTime) && realStartDate != null) {
      int index = dateTime.difference(realStartDate!).inDays;
      _scrollToSpecificDateByIndex(index);
    } else {
      //out of range do nothing
    }
  }

  ///check date within the start and end date range
  bool isWithinRange(DateTime dateTime) {
    if (startDate != null && endDate != null) {
      return dateTime.compareTo(startDate!) >= 0 &&
          dateTime.compareTo(endDate!) <= 0;
    } else {
      return false;
    }
  }

  ///FIELD: basically for internal use,
  ///if no need to customize as own picker, the following should have no need to modify
  ScrollController? scrollController;
  double shift = 0;

  ///padding + width of Item
  double itemWidth = 0;

  ///the real starting date = the appended header disabled date (index=0)
  DateTime? realStartDate;
  DateTime? selectedDate;
  DateTime? endDate;
  DateTime? startDate;

  ///[index]  listview index
  ///[isEnableAnimation] default set as true, jump with animation
  void _scrollToSpecificDateByIndex(int index,
      [bool isEnableAnimation = true]) {
    var diff = index - shift;
    if (isEnableAnimation) {
      scrollController?.animateTo(diff * itemWidth,
          duration: const Duration(milliseconds: 300), curve: Curves.linear);
    } else {
      scrollController?.jumpTo(diff * itemWidth);
    }
  }
}
