# Flutter Persian Date Picker

[![Pub](https://img.shields.io/pub/v/flutter_persian_date_picker?labelColor=%23BBE8E4&color=%2326A69A)](https://pub.dev/packages/flutter_persian_date_picker)

Provides full support of the Persian calendar with highly customizable and responsive UI. The
performance is quick enough to run smoothly on variety of devices including low-end phones.

<p align="center">
 <img src="https://raw.githubusercontent.com/arminyazdian/flutter-persian-date-picker/refs/heads/develop/screenshots/bottomsheet_screenshot.png" width="300" title="Bottom Sheet Screenshot"> <img src="https://raw.githubusercontent.com/arminyazdian/flutter-persian-date-picker/refs/heads/develop/screenshots/dialog_screenshot.png" width="300" title="Dialog Screenshot"></p><br>

## 📗 Step by step guide:

#### 1- Install with one of these ways:

```
dependencies:
  flutter_persian_date_picker: ^0.1.0
```

or

```
$ flutter pub add flutter_persian_date_picker
```

#### 2- Import to your Dart code:

```
import 'package:flutter_persian_date_picker/date_picker.dart';
import 'package:shamsi_date/shamsi_date.dart';
```

#### 3- Simply use PersianDatePicker as any widget child:

```
PersianDatePicker(
  onSubmitDate: (selectedDate) {
    
  },
  onEmptyDateSubmit: () {
    
  },
),
```

#### 4- Assign 2 required variables by following the document bellow.

## ✏️ Quick Document:

```
/// This gets called when user selects a date and taps the Submit button.
/// use selectedDate.formatter to access all details of the user's selected date
///
/// It is recommended to call [pop] if you are using [PersianDatePicker] inside a BottomSheet / Dialog
final void Function(Jalali selectedDate) onSubmitDate;

/// This gets called when user has no selected date and taps the Submit button.
///
/// It is recommended to show a toast as a hint for the user
final void Function() onEmptyDateSubmit;

/// Simply pass a date if you wish to have a date to be selected initially. This is pretty useful
/// for situations where user has saved a date in your state management
final Jalali? chosenDate;

/// Leave this empty if you want your [PersianDatePicker] to contain the whole width of the screen
///
/// If there is a [Padding] widget as parent of this widget and you want it to have a desired width too,
/// simply make a sum of width and the padding. For example:
/// int desiredWidth = 400;
/// int horizontalPadding = 10;
/// widthWithPadding = desiredWidth + (horizontalPadding * 2)
///
/// If you only want a desired width and there are no [Padding] as it's parent, just pass the width
///
/// If there is [Padding] as it's parent and you want it to take the whole width,
/// make a sum of your padding and MediaQuery.of(context).size.width
final double? widthWithPadding;

/// TextStyle for week titles.
final TextStyle weekTitlesTextStyle;

/// ButtonStyle for header navigator buttons
final ButtonStyle headerButtonsStyle;

/// Child widget of header right button
final Widget headerPreviousButtonChild;

/// Child widget of header left button
final Widget headerNextButtonChild;

/// TextStyle for month display text on top (bold text is recommended)
final TextStyle headerMonthDisplayTextStyle;

/// The Color for days background
final Color dateBackgroundColor;

/// TextStyle for day numbers
final TextStyle dateTextStyle;

/// The visibility type and color for selected date
final SelectedDateStyle? selectedDateStyle;

/// ButtonStyle for the button in the bottom
final ButtonStyle submitButtonStyle;

/// Child widget of submit button
final Widget submitButtonChild;
```

#### 📦 Used Packages:

[FatulM/shamsi_date](https://github.com/FatulM/shamsi_date)