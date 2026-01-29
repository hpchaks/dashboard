import 'package:flutter/foundation.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:dashboard/utils/screen_utils/app_screen_utils.dart';

extension AppSizeExtension on num {
  double get screenHeight => AppScreenUtils.height * this;

  double get screenWidth => AppScreenUtils.width * this;

  double get appHeight {
    if (kIsWeb) {
      return toDouble();
    }
    return ScreenUtil().setHeight(this);
  }

  double get appWidth {
    if (kIsWeb) {
      return toDouble();
    }
    return ScreenUtil().setWidth(this);
  }

  double get appText {
    if (kIsWeb) {
      return toDouble();
    }
    return ScreenUtil().setSp(this);
  }
}
