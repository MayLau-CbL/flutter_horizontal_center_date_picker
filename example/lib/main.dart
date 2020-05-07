import 'package:flutter/material.dart';
import 'package:horizontal_date_picker/datepicker_controller.dart';
import 'package:horizontal_date_picker/horizontal_date_picker.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: TestPage(),
    );
  }
}

class TestPage extends StatefulWidget {
  @override
  _TestPageState createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
  @override
  Widget build(BuildContext context) {
    var now = DateTime.now();
    return Material(
      child: Center(
        child: HorizontalDatePickerWidget(
          startDate: now.subtract(Duration(days: 14)),
          endDate: now,
          selectedDate: now,
          widgetWidth: MediaQuery.of(context).size.width,
          datePickerController: DatePickerController(),
          onValueSelected: (date) {
            print('selected = ${date.toIso8601String()}');
          },
        ),
      ),
    );
  }
}
