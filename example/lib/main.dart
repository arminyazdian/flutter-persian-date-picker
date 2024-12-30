import 'package:flutter/material.dart';
import 'package:flutter_persian_date_picker/date_picker.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const DatePickerTest(),
      theme: ThemeData(fontFamily: 'Shabnam'),
    );
  }
}

class DatePickerTest extends StatefulWidget {
  const DatePickerTest({super.key});

  @override
  State<DatePickerTest> createState() => _DatePickerTestState();
}

class _DatePickerTestState extends State<DatePickerTest> {
  @override
  Widget build(BuildContext context) {
    final double datePickerWidthWithPadding = MediaQuery.of(context).size.width - 32;

    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: PersianDatePicker(
              widthWithPadding: datePickerWidthWithPadding,
              onSubmitDate: (selectedDate) {
                String formattedSelectedDate =
                    'تاریخ انتخاب شده ${selectedDate.formatter.yyyy}/${selectedDate.formatter.mm}/${selectedDate.formatter.dd} میباشد';
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    behavior: SnackBarBehavior.floating,
                    content: Directionality(
                      textDirection: TextDirection.rtl,
                      child: Text(formattedSelectedDate),
                    ),
                  ),
                );
              },
              onEmptyDateSubmit: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    behavior: SnackBarBehavior.floating,
                    content: Directionality(
                      textDirection: TextDirection.rtl,
                      child: Text(
                        'تاریخ انتخاب نشده است',
                        textAlign: TextAlign.right,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
