 import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

double getFontSizeSmall() =>
ScreenUtil().screenWidth>= 1300 ? 15.sp : 12.sp;
 double getFontSizeSemiSmall() =>
ScreenUtil().screenWidth>= 1300 ? 16.sp : 14.sp;
 double getFontSizeDefault() =>
ScreenUtil().screenWidth>= 1300 ? 18.sp : 16.sp;
 double getFontSizeLarge() =>
ScreenUtil().screenWidth>= 1300 ? 20.sp : 16.sp;
 double getFontSizeExtraLarge() =>
ScreenUtil().screenWidth>= 1300 ? 20.sp : 18.sp;
 double getButtonFontSize() =>
ScreenUtil().screenWidth>= 1300 ? 26.sp : 20.sp;
 double getLargeFontSize() =>
ScreenUtil().screenWidth>= 1300 ? 26.sp : 24.sp;
 double getButtonFontSizeLarge() =>
ScreenUtil().screenWidth>= 1300 ? 30.sp : 24.sp;

 double getFontSizeOverLarge() =>
ScreenUtil().screenWidth>= 1300 ? 56.sp : 46.sp;
 double getFontSizeForReview() => 36.sp;