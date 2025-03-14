import 'package:e_hailing_app/core/components/custom_appbar.dart';
import 'package:e_hailing_app/core/components/custom_button.dart';
import 'package:e_hailing_app/core/components/custom_textfield.dart';
import 'package:e_hailing_app/core/constants/app_static_strings_constant.dart';
import 'package:e_hailing_app/core/constants/color_constants.dart';
import 'package:e_hailing_app/core/constants/custom_space.dart';
import 'package:e_hailing_app/core/constants/image_constant.dart';
import 'package:e_hailing_app/core/constants/padding_constant.dart';
import 'package:e_hailing_app/presentations/home/widgets/pickup_drop_location_widget.dart';
import 'package:e_hailing_app/presentations/home/widgets/select_car_item_widget.dart';
import 'package:e_hailing_app/presentations/trip/views/trip_details_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class RequestTripPage extends StatelessWidget {
  static const String routeName = '/request-trip';
  const RequestTripPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: AppStaticStrings.requestYourTrip),
      body: SingleChildScrollView(
        child: Padding(
          padding: padding16.copyWith(top: 0),
          child: Column(
            spacing: 6.h,
            children: [
              CarDetailsCardWidget(onTap: () {}),
              PickupDropLocationWidget(),
              CustomTextField(
                hintText: '12:35 PM',
                borderColor: AppColors.kGreyColor,
                fillColor: AppColors.kWhiteColor,
                borderRadius: 24.r,
                title: AppStaticStrings.pickTime,
                prefixIcon: Padding(
                  padding: padding14,
                  child: SvgPicture.asset(calenderIcon),
                ),
              ),
              CustomTextField(
                // hintText: '12:35 PM',
                maxLines: 3,
                borderColor: AppColors.kGreyColor,
                fillColor: AppColors.kWhiteColor,
                borderRadius: 24.r,
                title: AppStaticStrings.additionalNote,
              ),
              space6H,
              CustomButton(
                onTap: () {
                  Get.toNamed(TripDetailsPage.routeName);
                },
                title: AppStaticStrings.confirm,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
