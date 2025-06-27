import 'package:e_hailing_app/core/components/custom_appbar.dart';
import 'package:e_hailing_app/core/components/custom_button.dart';
import 'package:e_hailing_app/core/components/custom_textfield.dart';
import 'package:e_hailing_app/core/constants/app_static_strings_constant.dart';
import 'package:e_hailing_app/core/constants/color_constants.dart';
import 'package:e_hailing_app/core/constants/custom_space.dart';
import 'package:e_hailing_app/core/constants/padding_constant.dart';
import 'package:e_hailing_app/core/utils/variables.dart';
import 'package:e_hailing_app/presentations/home/controllers/home_controller.dart';
import 'package:e_hailing_app/presentations/home/widgets/pickup_drop_location_widget.dart';
import 'package:e_hailing_app/presentations/home/widgets/select_car_item_widget.dart';
import 'package:e_hailing_app/presentations/trip/controller/trip_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../core/constants/fontsize_constant.dart';
import '../../../core/constants/text_style_constant.dart';

class RequestTripPage extends StatelessWidget {
  static const String routeName = '/request-trip';

  const RequestTripPage({super.key});

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> args =
        (Get.arguments ?? {}) as Map<String, dynamic>;
    logger.d(args);
    return Scaffold(
      appBar: CustomAppBar(title: AppStaticStrings.requestYourTrip),
      body: SingleChildScrollView(
        child: Padding(
          padding: padding16.copyWith(top: 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 6.h,
            children: [
              Obx(() {
                return CarDetailsCardWidget(
                  onTap: () {},
                  fare: HomeController.to.estimatedFare.value,
                );
              }),
              PickupDropLocationWidget(),
              Text(
                "Payment Method",
                style: poppinsMedium.copyWith(
                  color: AppColors.kTextDarkBlueColor,
                  fontSize: getFontSizeSemiSmall(),
                ),
              ),
              Container(
                height: 30,
                padding: EdgeInsets.symmetric(horizontal: 12.w),
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.kGreyColor, width: 1.sp),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: DropdownButton<String>(
                  padding: EdgeInsets.zero,

                  value: TripController.to.selectedPaymentMethod.value,
                  icon: Icon(
                    Icons.arrow_drop_down,
                    color: AppColors.kPrimaryColor,
                  ),
                  borderRadius: BorderRadius.circular(10),
                  underline: SizedBox(),
                  // remove underline if needed
                  dropdownColor: Colors.white,
                  style: poppinsMedium.copyWith(
                    color: AppColors.kTextColor,
                    fontSize: 11.sp,
                  ),
                  onChanged: (String? newValue) {
                    TripController.to.selectedPaymentMethod.value = newValue!;
                  },
                  items:
                      paymentMethodList.map<DropdownMenuItem<String>>((
                        String value,
                      ) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                ),
              ),
              CustomTextField(
                textEditingController: TextEditingController(
                  text: args.isNotEmpty ? args["distance"].toString() : "",
                ),
                borderColor: AppColors.kGreyColor,
                fillColor: AppColors.kWhiteColor,
                borderRadius: 24.r,
                title: AppStaticStrings.tripDistance,
                // prefixIcon: Padding(
                //   padding: padding14,
                //   child: SvgPicture.asset(calenderIcon),
                // ),
              ),
              CustomTextField(
                textEditingController: TextEditingController(
                  text:
                      args.isNotEmpty
                          ? "${args["duration"].toString()} min"
                          : "",
                ),
                borderColor: AppColors.kGreyColor,
                fillColor: AppColors.kWhiteColor,
                borderRadius: 24.r,
                title: AppStaticStrings.tripDuration,
                // prefixIcon: Padding(
                //   padding: padding14,
                //   child: SvgPicture.asset(calenderIcon),
                // ),
              ),
              // CustomTextField(
              //   hintText: '01/03/2025',
              //   borderColor: AppColors.kGreyColor,
              //   fillColor: AppColors.kWhiteColor,
              //   borderRadius: 24.r,
              //   title: AppStaticStrings.tripDate,
              //   prefixIcon: Padding(
              //     padding: padding14,
              //     child: SvgPicture.asset(calenderIcon),
              //   ),
              // ),
              // CustomTextField(
              //   hintText: '12:35 PM',
              //   borderColor: AppColors.kGreyColor,
              //   fillColor: AppColors.kWhiteColor,
              //   borderRadius: 24.r,
              //   title: AppStaticStrings.pickTime,
              //   prefixIcon: Padding(
              //     padding: padding14,
              //     child: SvgPicture.asset(calenderIcon),
              //   ),
              // ),
              CustomTextField(
                // hintText: '12:35 PM',
                textEditingController: TripController.to.promoCodeController,
                borderColor: AppColors.kGreyColor,
                fillColor: AppColors.kWhiteColor,
                borderRadius: 24.r,
                title: AppStaticStrings.promoCode,
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
                  if (args.isNotEmpty) {
                    TripController.to.requestTrip(body: args);
                  }
                  // TripController.to.r
                  // showDialog(
                  //   context: context,
                  //   builder:
                  //       (context) => AlertDialog(
                  //         backgroundColor: Colors.transparent,
                  //         contentPadding: EdgeInsets.zero,
                  //         content: TripRequestLoadingWidget(),
                  //       ),
                  // );
                  // Future.delayed(Duration(seconds: 2), () {
                  //   Get.toNamed(TripDetailsPage.routeName);
                  // });
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
