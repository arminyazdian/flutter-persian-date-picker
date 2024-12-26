import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_persian_date_picker/flutter_persian_date_picker.dart';
import 'package:flutter_persian_date_picker/flutter_persian_date_picker_platform_interface.dart';
import 'package:flutter_persian_date_picker/flutter_persian_date_picker_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockFlutterPersianDatePickerPlatform
    with MockPlatformInterfaceMixin
    implements FlutterPersianDatePickerPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final FlutterPersianDatePickerPlatform initialPlatform = FlutterPersianDatePickerPlatform.instance;

  test('$MethodChannelFlutterPersianDatePicker is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelFlutterPersianDatePicker>());
  });

  test('getPlatformVersion', () async {
    FlutterPersianDatePicker flutterPersianDatePickerPlugin = FlutterPersianDatePicker();
    MockFlutterPersianDatePickerPlatform fakePlatform = MockFlutterPersianDatePickerPlatform();
    FlutterPersianDatePickerPlatform.instance = fakePlatform;

    expect(await flutterPersianDatePickerPlugin.getPlatformVersion(), '42');
  });
}
