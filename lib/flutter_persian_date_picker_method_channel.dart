import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'flutter_persian_date_picker_platform_interface.dart';

/// An implementation of [FlutterPersianDatePickerPlatform] that uses method channels.
class MethodChannelFlutterPersianDatePicker extends FlutterPersianDatePickerPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('flutter_persian_date_picker');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
