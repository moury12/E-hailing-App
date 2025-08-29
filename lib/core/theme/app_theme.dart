import 'package:e_hailing_app/core/constants/fontsize_constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../constants/color_constants.dart';
import '../constants/text_style_constant.dart';


class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      dividerTheme: DividerThemeData(color: Color(0xffEEEEEE)),
      dialogTheme: DialogThemeData(backgroundColor: AppColors.kWhiteColor),
      drawerTheme: DrawerThemeData(
        backgroundColor: AppColors.kWhiteColor,
      ),
      timePickerTheme: TimePickerThemeData(backgroundColor:AppColors.kWhiteColor,
        dialBackgroundColor: Colors.deepPurple.shade50,
        dialHandColor: AppColors.kPrimaryColor,
        dialTextColor: Colors.black,
        hourMinuteTextColor: AppColors.kPrimaryColor,
        entryModeIconColor: AppColors.kPrimaryColor,
      ),
      colorScheme: ColorScheme.light(
        primary: AppColors.kPrimaryColor,
        onPrimary: AppColors.kWhiteColor,
        onSurface: Colors.black,
      ),
      datePickerTheme: DatePickerThemeData(

        backgroundColor: AppColors.kWhiteColor,      // Dialog background
        headerBackgroundColor: AppColors.kPrimaryColor, // ✅ Header color
        headerForegroundColor: AppColors.kWhiteColor,            // ✅ Header text
        weekdayStyle: TextStyle(color: AppColors.kPrimaryColor), // Weekday labels
        dayForegroundColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.kWhiteColor; // Selected day text color
          }
          return Colors.black;
        }),
        dayBackgroundColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.kPrimaryColor; // ✅ Selected day background
          }
          return Colors.transparent;
        }),

        ),

      popupMenuTheme: PopupMenuThemeData(
          surfaceTintColor: AppColors.kWhiteColor,
          color: AppColors.kWhiteColor),
      // switchTheme: SwitchThemeData(
      //
      //   trackOutlineColor: WidgetStateProperty.all(AppColors.kButtonBackgroundColor), // Outline color for track
      //   overlayColor: WidgetStateProperty.all(AppColors.kSubTextColor), // Overlay color when pressed
      //
      // ),
      splashColor: AppColors.kPrimaryLightColor,
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: AppColors.kWhiteColor,
        showUnselectedLabels: true,

        type: BottomNavigationBarType.fixed,
        selectedItemColor: AppColors.kPrimaryColor,
        unselectedItemColor: AppColors.kLightTextColor,
        unselectedLabelStyle: poppinsRegular.copyWith(
            color: AppColors.kTextColor, fontSize: getFontSizeSmall()),
        selectedLabelStyle: poppinsRegular.copyWith(
            color: AppColors.kPrimaryColor, fontSize: getFontSizeSmall()),
      ),

      checkboxTheme: CheckboxThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4), // Rounded corners
        ),
        side: BorderSide(
          color: Colors.black, // Border color
          width: 2, // Border width
        ),
        checkColor: WidgetStateProperty.resolveWith(
          (states) => AppColors.kWhiteColor, // Checkmark color
        ),
        fillColor: WidgetStateProperty.resolveWith(
          (states) {
            if (states.contains(WidgetState.selected)) {
              return AppColors.kPrimaryColor; // Background color when selected
            }
            return AppColors.kWhiteColor; // Background color when not selected
          },
        ),
        overlayColor: WidgetStateProperty.resolveWith(
          (states) {
            if (states.contains(WidgetState.hovered)) {
              return AppColors.kPrimaryColor
                  .withValues(alpha: 0.1); // Hover effect color
            }
            if (states.contains(WidgetState.pressed)) {
              return AppColors.kPrimaryColor
                  .withValues(alpha:0.2); // Pressed effect color
            }
            return null;
          },
        ),
        splashRadius: 20.0, // Radius of the splash when tapped
      ),

      inputDecorationTheme: inputDecorationTheme,
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: AppColors.kWhiteColor,
      ),
      appBarTheme: AppBarTheme(
        surfaceTintColor: AppColors.kScaffoldBackgroundColor,
        backgroundColor: AppColors.kScaffoldBackgroundColor,
        foregroundColor: AppColors.kTextColor,
      ),
      scaffoldBackgroundColor: AppColors.kScaffoldBackgroundColor,
      textTheme: const TextTheme(
          /* bodyText1: TextStyle(fontSize: 16, color: Colors.black),
        bodyText2: TextStyle(fontSize: 14, color: Colors.black54),
     */
          ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      primarySwatch: Colors.blueGrey,
      textTheme: const TextTheme(
          /*bodyText1: TextStyle(fontSize: 16, color: Colors.white),
        bodyText2: TextStyle(fontSize: 14, color: Colors.white70),
      */
          ),
    );
  }

}

final InputDecorationTheme inputDecorationTheme = InputDecorationTheme(
  disabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(50.r),
      borderSide: const BorderSide(color: AppColors.kLightTextColor, width: 1),
      gapPadding: 0),
  border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(50.r),
      borderSide: const BorderSide(color: AppColors.kLightTextColor, width: 1),
      gapPadding: 0),
  focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(50.r),
      borderSide: const BorderSide(color: AppColors.kLightTextColor, width: 1),
      gapPadding: 0),
  enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(50.r),
      borderSide: const BorderSide(color: AppColors.kLightTextColor, width: 1),
      gapPadding: 0),
  fillColor: AppColors.kLightTextColor,
);
