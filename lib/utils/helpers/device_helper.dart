import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:dashboard/utils/helpers/platform_mobile.dart';

class DeviceHelper {
  static const platform = MethodChannel('samples.flutter.dev/device');

  Future<String?> getDeviceId() async {
    var deviceInfo = DeviceInfoPlugin();

    if (isAndroid && !kIsWeb) {
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      return androidInfo.id;
    } else if (isIOS) {
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      return iosInfo.identifierForVendor;
    }
    return null;
  }
}
