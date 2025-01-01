import 'package:flutter/material.dart';
import 'package:flutter_persian_date_picker/date_picker.dart';
import 'package:shamsi_date/shamsi_date.dart';

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
      theme: ThemeData(
        fontFamily: 'Shabnam',
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF26A69A),
          primary: const Color(0xFF26A69A),
        ),
      ),
    );
  }
}

class DatePickerTest extends StatefulWidget {
  const DatePickerTest({super.key});

  @override
  State<DatePickerTest> createState() => _DatePickerTestState();
}

class _DatePickerTestState extends State<DatePickerTest> {
  Jalali? chosenDate;

  @override
  Widget build(BuildContext context) {
    final double datePickerWidthWithPadding = MediaQuery.of(context).size.width - 32;

    return Scaffold(
      appBar: AppBar(title: const Text('تست دیت پیکر'), centerTitle: true),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(16), topRight: Radius.circular(16)),
                  ),
                  builder: (context) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 26),
                      child: PersianDatePicker(
                        widthWithPadding: datePickerWidthWithPadding,
                        chosenDate: chosenDate,
                        onSubmitDate: (selectedDate) {
                          chosenDate = selectedDate;

                          Navigator.of(context).pop();
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
                    );
                  },
                );
              },
              child: const Text('نمایش در باتم شیت'),
            ),
            const SizedBox(height: 6),
            ElevatedButton(
              onPressed: () {
                showDialog(
                  context: context,
                  barrierDismissible: true,
                  builder: (context) {
                    return Center(
                      child: Container(
                        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 26),
                        margin: const EdgeInsets.all(20),
                        child: Material(
                          child: PersianDatePicker(
                            widthWithPadding: datePickerWidthWithPadding,
                            chosenDate: chosenDate,
                            onSubmitDate: (selectedDate) {
                              chosenDate = selectedDate;

                              Navigator.of(context).pop();
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
                      ),
                    );
                  },
                );
              },
              child: const Text('نمایش در دیالوگ'),
            ),
          ],
        ),
      ),
    );
  }
}
