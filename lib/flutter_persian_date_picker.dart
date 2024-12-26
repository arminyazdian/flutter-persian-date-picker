
import 'flutter_persian_date_picker_platform_interface.dart';

class FlutterPersianDatePicker {
  Future<String?> getPlatformVersion() {
    return FlutterPersianDatePickerPlatform.instance.getPlatformVersion();
  }
}
