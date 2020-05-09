library horizontal_center_date_picker;

import 'package:flutter/material.dart';
import 'date_item_state.dart';
import 'date_item_widget.dart';
import 'datepicker_controller.dart';

import 'date_item.dart';

class HorizontalDatePickerWidget extends StatefulWidget {
  ///picker start date
  final DateTime startDate;

  ///picker end date
  final DateTime endDate;

  ///default selected date
  final DateTime selectedDate;

  ///each date item width
  ///if the width is not able to fill the widget's width,
  ///padding will auto append to each item evenly
  final double width;

  ///whole widget's width
  final double widgetWidth;

  ///whole widget's height
  final double height;

  ///callback when a new date selected
  final void Function(DateTime value) onValueSelected;

  ///controller controls the visible position of the picker
  ///this controller will share both internal and external use
  ///this is required
  final DatePickerController datePickerController;

  ///Date item color and fontsize
  ///fontsize of the month label
  final double monthFontSize;

  ///fontsize of the day label
  final double dayFontSize;

  ///fontsize of the day of week label
  final double weekDayFontSize;

  ///background color of a date item
  final Color normalColor;

  ///background color of a selected date item
  final Color selectedColor;

  ///background color of a disabled date(date that out of the range) item
  final Color disabledColor;

  ///text color of a date item
  final Color normalTextColor;

  ///text color of a selected date item
  final Color selectedTextColor;

  ///text color of a disabled date(date that out of the range) item
  final Color disabledTextColor;

  ///Date item display setting
  ///default set as month, day, day of week, from top to bottom
  ///at least one info must be in the list
  final List<DateItem> dateItemComponentList;

  /// Main widget part of this library.
  /// It is a horizontal date picker that always make the selected option to center.
  HorizontalDatePickerWidget({
    @required this.startDate,
    @required this.endDate,
    @required this.selectedDate,
    @required this.widgetWidth,
    @required this.datePickerController,
    this.dateItemComponentList = const <DateItem>[
      DateItem.Month,
      DateItem.Day,
      DateItem.WeekDay
    ],
    this.width = 60,
    this.height = 80,
    this.onValueSelected,
    this.normalColor = Colors.white,
    this.selectedColor = Colors.black,
    this.disabledColor = Colors.white,
    this.normalTextColor = Colors.black,
    this.selectedTextColor = Colors.white,
    this.disabledTextColor = const Color(0xFFBDBDBD),
    this.monthFontSize = 12,
    this.dayFontSize = 18,
    this.weekDayFontSize = 12,
  })  : assert(startDate != null, 'startDate cannot be null'),
        assert(endDate != null, 'endDate cannot be null'),
        assert(selectedDate != null, 'selectedDate cannot be null'),
        assert(widgetWidth != null, 'widgetWidth  cannot be null'),
        assert(datePickerController != null,
            'datePickerController  cannot be null'),
        assert(
            dateItemComponentList != null && dateItemComponentList.isNotEmpty,
            'dateItemComponentList  cannot be null or empty');

  @override
  _HorizontalDatePickerWidgetState createState() =>
      _HorizontalDatePickerWidgetState(
          this.datePickerController,
          this.widgetWidth,
          this.width,
          this.startDate,
          this.endDate,
          this.selectedDate);
}

class _HorizontalDatePickerWidgetState
    extends State<HorizontalDatePickerWidget> {
  int _itemCount = 0;
  double _padding = 0.0;
  ScrollController _scrollController = ScrollController();

  _HorizontalDatePickerWidgetState(
      DatePickerController controller,
      double ttlWidth,
      double width,
      DateTime startDate,
      DateTime endDate,
      DateTime selectedDate) {
    _init(controller, ttlWidth, width, startDate, endDate, selectedDate);
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.datePickerController.scrollToSelectedItem();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.height,
      width: widget.widgetWidth,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _itemCount,
        controller: _scrollController,
        itemBuilder: (context, index) {
          var dateTime = widget.datePickerController?.realStartDate
              ?.add(Duration(days: index));
          DateItemState dateItemState = _getDateTimeState(dateTime);
          return GestureDetector(
            onTap: () {
              if (dateItemState != DateItemState.DISABLED) {
                widget.datePickerController.selectedDate = dateTime;
                widget.onValueSelected(dateTime);
                setState(() {
                  widget.datePickerController?.scrollToSelectedItem();
                });
              }
            },
            child: DateItemWidget(
              dateTime: dateTime,
              padding: _padding,
              width: widget.width,
              height: widget.height,
              dateItemState: dateItemState,
              dayFontSize: widget.dayFontSize,
              monthFontSize: widget.monthFontSize,
              weekDayFontSize: widget.weekDayFontSize,
              normalColor: widget.normalColor,
              selectedColor: widget.selectedColor,
              disabledColor: widget.disabledColor,
              normalTextColor: widget.normalTextColor,
              selectedTextColor: widget.selectedTextColor,
              disabledTextColor: widget.disabledTextColor,
              dateItemComponentList: widget.dateItemComponentList,
            ),
          );
        },
      ),
    );
  }

  DateItemState _getDateTimeState(DateTime dateTime) {
    if (dateTime != null) {
      if (_isSelectedDate(dateTime)) {
        return DateItemState.SELECTED;
      } else {
        if (_isWithinRange(dateTime)) {
          return DateItemState.ACTIVE;
        } else {
          return DateItemState.DISABLED;
        }
      }
    }
    return DateItemState.DISABLED;
  }

  bool _isSelectedDate(DateTime dateTime) {
    if (widget.datePickerController.selectedDate != null) {
      return dateTime.year == widget.datePickerController.selectedDate.year &&
          dateTime.month == widget.datePickerController.selectedDate.month &&
          dateTime.day == widget.datePickerController.selectedDate.day;
    } else {
      return false;
    }
  }

  void _init(DatePickerController controller, double ttlWidth, double width,
      DateTime startDate, DateTime endDate, DateTime selectedDate) {
    int maxRowChild = 0;
    int shift = 0;
    double shiftPos;
    double widgetWidth = ttlWidth;

    maxRowChild = (widgetWidth / width).floor();

    if (maxRowChild.isOdd) {
      shift = ((maxRowChild - 1) / 2).floor();
      shiftPos = shift.toDouble();
    } else {
      shift = (maxRowChild / 2).floor();
      shiftPos = shift - 0.5;
    }

    //calc padding(L+R)
    _padding = (widgetWidth - (maxRowChild * width)) / maxRowChild;

    _itemCount = shift * 2 + endDate.difference(startDate).inDays + 1;

    controller.scrollController = _scrollController;
    controller.shift = shiftPos;
    controller.itemWidth = _padding + width;

    controller.realStartDate = startDate.subtract(Duration(days: shift));
    controller.selectedDate = selectedDate;
    controller.endDate = endDate;
    controller.startDate = startDate;
  }

  bool _isWithinRange(DateTime dateTime) {
    return widget.datePickerController.isWithinRange(dateTime);
  }
}
