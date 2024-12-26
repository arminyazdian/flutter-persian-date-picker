import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'flutter_persian_date_picker_method_channel.dart';

abstract class FlutterPersianDatePickerPlatform extends PlatformInterface {
  /// Constructs a FlutterPersianDatePickerPlatform.
  FlutterPersianDatePickerPlatform() : super(token: _token);

  static final Object _token = Object();

  static FlutterPersianDatePickerPlatform _instance = MethodChannelFlutterPersianDatePicker();

  /// The default instance of [FlutterPersianDatePickerPlatform] to use.
  ///
  /// Defaults to [MethodChannelFlutterPersianDatePicker].
  static FlutterPersianDatePickerPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [FlutterPersianDatePickerPlatform] when
  /// they register themselves.
  static set instance(FlutterPersianDatePickerPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
