import 'package:flutter/material.dart';
import 'package:shamsi_date/shamsi_date.dart';
import 'config/strings.dart';
import 'config/colours.dart';
import 'config/text_sizes.dart';
import 'data/model/date_picker_month_info.dart';
import 'utils/pdate_utils.dart' as util;

/// [stroke] puts a line over the selected date
/// while [fill] changes its background color
enum SelectedDateVisibility {
  stroke,
  fill;

  bool get isStroke => this == SelectedDateVisibility.stroke;

  bool get isFill => this == SelectedDateVisibility.fill;
}

/// the visibility type and color for selected date
class SelectedDateStyle {
  final SelectedDateVisibility visibility;
  final Color color;

  const SelectedDateStyle({required this.visibility, required this.color});
}

class PersianDatePicker extends StatefulWidget {
  /// Leave this empty if you want your [PersianDatePicker] to contain the whole width of the screen
  ///
  /// If there is a [Padding] widget as parent of this widget and you want it to have a desired width too,
  /// simply make a sum of width and the padding. For example:
  ///
  /// ```dart
  /// int desiredWidth = 400;
  /// int horizontalPadding = 10;
  /// widthWithPadding = desiredWidth + (horizontalPadding * 2)
  /// ```
  ///
  /// If you only want a desired width and there are no [Padding] as it's parent, just pass the width
  ///
  /// If there is [Padding] as it's parent and you want it to take the whole width, make a sum of your padding and
  /// ```dart
  /// MediaQuery.of(context).size.width
  /// ```
  final double? widthWithPadding;

  /// TextStyle for week titles.
  final TextStyle weekTitlesTextStyle;

  /// TextStyle for header navigator buttons
  final TextStyle headerButtonsTextStyle;

  /// The Color for header navigator buttons background (primary color is recommended)
  final Color headerButtonsBackgroundColor;

  /// The Color for header navigator buttons text and icon
  final Color headerButtonsForegroundColor;

  /// TextStyle for month display text on top (bold text is recommended)
  final TextStyle headerMonthDisplayTextStyle;

  /// The Color for days background
  final Color dateBackgroundColor;

  /// TextStyle for day numbers
  final TextStyle dateTextStyle;

  /// The visibility type and color for selected date
  final SelectedDateStyle selectedDateStyle;

  /// ButtonStyle for the button in the bottom
  final ButtonStyle submitButtonStyle;

  /// This gets called when user selects a date and taps the Submit button. use selectedDate.formatter to access all
  /// details of the user's selected date
  ///
  /// It is recommended to call [pop] if you are using [PersianDatePicker] inside a BottomSheet / Dialog
  final Function(Jalali selectedDate) onSubmitDate;

  /// This gets called when user has no selected date and taps the Submit button.
  ///
  /// It is recommended to show a toast as a hint for the user
  final Function() onEmptyDateSubmit;

  /// Simply pass a date if you wish to have a date to be selected initially. This is pretty useful
  /// for situations where user has saved a date in your state management
  final Jalali? chosenDate;

  const PersianDatePicker({
    super.key,
    this.widthWithPadding,
    required this.onSubmitDate,
    this.chosenDate,
    this.weekTitlesTextStyle = const TextStyle(fontSize: TextSizes.bodyLarge, color: Colours.hint),
    this.headerButtonsTextStyle = const TextStyle(fontSize: TextSizes.bodyMedium, color: Colours.main),
    this.headerButtonsBackgroundColor = Colours.primary,
    this.headerButtonsForegroundColor = Colours.main,
    this.headerMonthDisplayTextStyle = const TextStyle(fontSize: TextSizes.titleSmall, color: Colours.title),
    this.dateBackgroundColor = Colours.primary,
    this.dateTextStyle = const TextStyle(fontSize: TextSizes.bodyMedium, color: Colours.main),
    this.selectedDateStyle = const SelectedDateStyle(
      visibility: SelectedDateVisibility.stroke,
      color: Colours.secondary,
    ),
    required this.onEmptyDateSubmit,
    this.submitButtonStyle = const ButtonStyle(
      backgroundColor: MaterialStatePropertyAll(Colours.primary),
      foregroundColor: MaterialStatePropertyAll(Colours.main),
      shape: MaterialStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10)))),
    ),
  });

  @override
  State<PersianDatePicker> createState() => _PersianDatePickerState();
}

class _PersianDatePickerState extends State<PersianDatePicker> {
  final PageController dateController = PageController(initialPage: 1);

  bool isInitialized = false;
  Jalali? selectedDate;
  Jalali? currentVisibleDate;
  List<DatePickerMonthInfo>? months;

  final int datePickerColumnCount = Strings.weekTitles.length;
  final int datePickerRowCount = 6;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    dateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidthWithPadding = widget.widthWithPadding ?? MediaQuery.of(context).size.width;
    final double datesHeight = screenWidthWithPadding / datePickerColumnCount * datePickerRowCount;

    if (!isInitialized) {
      initDatePicker(selectedDate: widget.chosenDate);
      initControllerListener(context);
    } else {
      if (dateController.page != 1) {
        dateController.jumpToPage(1);
      }
    }

    return Directionality(
      textDirection: TextDirection.rtl,
      child: SizedBox(
        width: screenWidthWithPadding,
        child: Column(
          children: [
            _Header(
              currentDate: currentVisibleDate ?? Jalali.now(),
              onPreviousMonthTap: () => changeDatePage(page: (dateController.page?.round() ?? 0) - 1),
              onNextMonthTap: () => changeDatePage(page: (dateController.page?.round() ?? 0) + 1),
              buttonsBackgroundColor: widget.headerButtonsBackgroundColor,
              buttonsForegroundColor: widget.headerButtonsForegroundColor,
              buttonsTextStyle: widget.headerButtonsTextStyle,
              monthDisplayerTextStyle: widget.headerMonthDisplayTextStyle,
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(screenWidthWithPadding * 0.04, 12, screenWidthWithPadding * 0.04, 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(
                  Strings.weekTitles.length,
                  (index) {
                    return Text(
                      Strings.weekTitles[index],
                      style: widget.weekTitlesTextStyle,
                      textAlign: TextAlign.center,
                    );
                  },
                ),
              ),
            ),
            SizedBox(
              height: datesHeight,
              child: GestureDetector(
                onPanDown: (details) {
                  if (dateController.page is double && (dateController.page ?? 0) < 0.5) {
                    gotoPreviousMonth();
                  } else if (dateController.page is double && (dateController.page ?? 0) > 1.5) {
                    goToNextMonth();
                  }
                },
                child: PageView.builder(
                  scrollDirection: Axis.horizontal,
                  scrollBehavior: const ScrollBehavior().copyWith(overscroll: false),
                  controller: dateController,
                  itemCount: months?.length ?? 0,
                  itemBuilder: (context, index) {
                    return _Dates(
                      info: months?[index] ?? DatePickerMonthInfo(offset: 0, daysWithOffset: 0, selectedDay: 0),
                      dateBackgroundColor: widget.dateBackgroundColor,
                      dateTextStyle: widget.dateTextStyle,
                      selectedDateStyle: widget.selectedDateStyle,
                      width: screenWidthWithPadding,
                      onSelectDate: (dateDay) {
                        setState(() {
                          List<DatePickerMonthInfo> _months = List.from(months ?? []);
                          _months[1] = DatePickerMonthInfo(
                            offset: months?[1].offset ?? 0,
                            daysWithOffset: months?[1].daysWithOffset ?? 0,
                            selectedDay: dateDay,
                          );

                          Jalali _selectedDate = currentVisibleDate?.copy(day: dateDay) ??
                              Jalali(Jalali.now().year, Jalali.now().month, Jalali.now().day);

                          months = _months;
                          selectedDate = _selectedDate;
                        });
                      },
                    );
                  },
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 16),
              child: SizedBox(
                width: double.infinity,
                height: 45,
                child: FilledButton(
                  style: widget.submitButtonStyle,
                  onPressed: () {
                    if (selectedDate == null) {
                      widget.onEmptyDateSubmit();
                    } else {
                      widget.onSubmitDate(
                          selectedDate ?? Jalali(Jalali.now().year, Jalali.now().monthLength, Jalali.now().day));
                    }
                  },
                  child: const Text(Strings.confirm),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void initControllerListener(BuildContext context) {
    dateController.addListener(
      () {
        if (dateController.page is double && dateController.page == 0) {
          setState(() {
            gotoPreviousMonth();
          });
        } else if (dateController.page is double && dateController.page == 2) {
          setState(() {
            goToNextMonth();
          });
        }
      },
    );
  }

  void changeDatePage({required int page}) {
    dateController.animateToPage(page, duration: const Duration(milliseconds: 400), curve: Curves.easeOut);
  }

  void initDatePicker({Jalali? selectedDate}) {
    Jalali initDate = selectedDate ?? Jalali(Jalali.now().year, Jalali.now().month, Jalali.now().day);
    List<Jalali> targetDates = [initDate.addMonths(-1), initDate, initDate.addMonths(1)];
    List<DatePickerMonthInfo> monthsInfo = _getMonthsInfo(targetDates: targetDates, initSelectedDate: selectedDate);

    isInitialized = true;
    currentVisibleDate = targetDates[1];
    months = monthsInfo;
    selectedDate = selectedDate;
  }

  void goToNextMonth() {
    setState(() {
      Jalali currentDate = currentVisibleDate ?? Jalali(Jalali.now().year, Jalali.now().month, Jalali.now().day);
      List<Jalali> targetDates = [currentDate, currentDate.addMonths(1), currentDate.addMonths(2)];
      List<DatePickerMonthInfo> _months = _getMonthsInfo(targetDates: targetDates);

      currentVisibleDate = targetDates[1];
      months = _months;
    });
  }

  void gotoPreviousMonth() {
    setState(() {
      Jalali currentDate = currentVisibleDate ?? Jalali(Jalali.now().year, Jalali.now().month, Jalali.now().day);
      List<Jalali> targetDates = [currentDate.addMonths(-2), currentDate.addMonths(-1), currentDate];
      List<DatePickerMonthInfo> _months = _getMonthsInfo(targetDates: targetDates);

      currentVisibleDate = targetDates[1];
      months = _months;
    });
  }

  List<DatePickerMonthInfo> _getMonthsInfo({required List<Jalali> targetDates, Jalali? initSelectedDate}) {
    List<int> offset = List.generate(
      targetDates.length,
      (index) => util.firstDayOffset(targetDates[index].year, targetDates[index].month),
    );
    List<int> daysWithOffset = List.generate(
      targetDates.length,
      (index) => targetDates[index].monthLength + offset[index],
    );

    Jalali? _selectedDate = initSelectedDate ?? selectedDate;

    List<DatePickerMonthInfo> months = List.generate(
      targetDates.length,
      (index) => DatePickerMonthInfo(
        offset: offset[index],
        daysWithOffset: daysWithOffset[index],
        selectedDay: _selectedDate == targetDates[index].copy(day: _selectedDate?.day ?? 1) ? _selectedDate?.day : null,
      ),
    );

    return months;
  }
}

class _Header extends StatefulWidget {
  final void Function() onPreviousMonthTap;
  final void Function() onNextMonthTap;
  final Jalali currentDate;
  final Color buttonsBackgroundColor;
  final Color buttonsForegroundColor;
  final TextStyle buttonsTextStyle;
  final TextStyle monthDisplayerTextStyle;

  const _Header({
    required this.onPreviousMonthTap,
    required this.onNextMonthTap,
    required this.currentDate,
    required this.buttonsBackgroundColor,
    required this.buttonsForegroundColor,
    required this.buttonsTextStyle,
    required this.monthDisplayerTextStyle,
  });

  @override
  State<_Header> createState() => _HeaderState();
}

class _HeaderState extends State<_Header> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: widget.onPreviousMonthTap,
            borderRadius: BorderRadius.circular(9),
            child: Ink(
              decoration: BoxDecoration(
                color: widget.buttonsBackgroundColor,
                borderRadius: BorderRadius.circular(9),
              ),
              padding: const EdgeInsets.fromLTRB(10, 6, 5, 6),
              child: Row(
                children: [
                  Icon(
                    Icons.chevron_left,
                    color: widget.buttonsForegroundColor,
                    size: 22,
                  ),
                  Text(
                    Strings.previousMonth,
                    style: widget.buttonsTextStyle,
                  ),
                ],
              ),
            ),
          ),
        ),
        Expanded(
          child: Text(
            '${widget.currentDate.formatter.mN} ${widget.currentDate.year}',
            style: widget.monthDisplayerTextStyle,
            textAlign: TextAlign.center,
          ),
        ),
        Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: widget.onNextMonthTap,
            borderRadius: BorderRadius.circular(9),
            child: Ink(
              decoration: BoxDecoration(
                color: widget.buttonsBackgroundColor,
                borderRadius: BorderRadius.circular(9),
              ),
              padding: const EdgeInsets.fromLTRB(5, 6, 10, 6),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    Strings.nextMonth,
                    style: widget.buttonsTextStyle,
                  ),
                  Icon(
                    Icons.chevron_right,
                    color: widget.buttonsForegroundColor,
                    size: 22,
                  ),
                ],
              ),
            ),
          ),
        )
      ],
    );
  }
}

class _Dates extends StatefulWidget {
  final DatePickerMonthInfo info;
  final Color dateBackgroundColor;
  final TextStyle dateTextStyle;
  final SelectedDateStyle selectedDateStyle;
  final double width;
  final Function(int dateDay) onSelectDate;

  const _Dates({
    required this.info,
    required this.dateBackgroundColor,
    required this.dateTextStyle,
    required this.selectedDateStyle,
    required this.width,
    required this.onSelectDate,
  });

  @override
  State<_Dates> createState() => _DatesState();
}

class _DatesState extends State<_Dates> {
  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: EdgeInsets.zero,
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: false,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: Strings.weekTitles.length,
        crossAxisSpacing: widget.width * 0.03,
        mainAxisSpacing: widget.width * 0.03,
      ),
      itemCount: widget.info.daysWithOffset,
      itemBuilder: (context, index) {
        int dateIndex = index + 1 - widget.info.offset;

        if (index < widget.info.offset) {
          return const SizedBox();
        } else {
          return Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(10),
              onTap: () {
                widget.onSelectDate(dateIndex);
              },
              child: Stack(
                children: [
                  Ink(
                    decoration: BoxDecoration(
                      color: dateIndex == widget.info.selectedDay && widget.selectedDateStyle.visibility.isFill
                          ? widget.selectedDateStyle.color
                          : widget.dateBackgroundColor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: Text(
                        dateIndex.toString(),
                        style: widget.dateTextStyle,
                      ),
                    ),
                  ),
                  Visibility(
                    visible: dateIndex == widget.info.selectedDay && widget.selectedDateStyle.visibility.isStroke,
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(width: 3, color: widget.selectedDateStyle.color),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }
      },
    );
  }
}
