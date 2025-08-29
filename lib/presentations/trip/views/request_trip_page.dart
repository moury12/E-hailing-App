import 'package:e_hailing_app/core/components/custom_appbar.dart';
import 'package:e_hailing_app/core/components/custom_button.dart';
import 'package:e_hailing_app/core/components/custom_button_tap.dart';
import 'package:e_hailing_app/core/components/custom_textfield.dart';
import 'package:e_hailing_app/core/constants/app_static_strings_constant.dart';
import 'package:e_hailing_app/core/constants/color_constants.dart';
import 'package:e_hailing_app/core/constants/custom_space.dart';
import 'package:e_hailing_app/core/constants/custom_text.dart';
import 'package:e_hailing_app/core/constants/image_constant.dart';
import 'package:e_hailing_app/core/constants/padding_constant.dart';
import 'package:e_hailing_app/core/helper/helper_function.dart';
import 'package:e_hailing_app/core/utils/variables.dart';
import 'package:e_hailing_app/presentations/home/controllers/home_controller.dart';
import 'package:e_hailing_app/presentations/home/widgets/pickup_drop_location_widget.dart';
import 'package:e_hailing_app/presentations/home/widgets/select_car_item_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../../core/constants/fontsize_constant.dart';
import '../../../core/constants/text_style_constant.dart';

class RequestTripPage extends StatefulWidget {
  static const String routeName = '/request-trip';

  const RequestTripPage({super.key});

  @override
  State<RequestTripPage> createState() => _RequestTripPageState();
}

class _RequestTripPageState extends State<RequestTripPage> {
  TextEditingController dateTimeController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> args =
    (Get.arguments ?? {}) as Map<String, dynamic>;

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
              PickupDropLocationWidget(isDisable: true),
              Row(
                children: [
                  Text(
                    "Payment Method",
                    style: poppinsMedium.copyWith(
                      color: AppColors.kTextDarkBlueColor,
                      fontSize: getFontSizeSemiSmall(),
                    ),
                  ),
                  CustomText(text: " *", color: Colors.red,)
                ],
              ),
              Container(
                height: 30,
                padding: EdgeInsets.symmetric(horizontal: 12.w),
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.kGreyColor, width: 1.sp),
                  borderRadius: BorderRadius.circular(12.r),
                ),

                child: Obx(() {
                  return DropdownButton<String>(
                    value: HomeController.to.selectedPaymentMethod.value,
                    icon: Icon(
                      Icons.arrow_drop_down,
                      color: AppColors.kPrimaryColor,
                    ),
                    borderRadius: BorderRadius.circular(10),
                    underline: SizedBox(),
                    hint: CustomText(text: "Select payment system"),
                    dropdownColor: Colors.white,
                    style: poppinsMedium.copyWith(
                      color: AppColors.kTextColor,
                      fontSize: 11.sp,
                    ),
                    onChanged: (String? newValue) {
                      HomeController.to.selectedPaymentMethod.value = newValue!;
                    },
                    items:
                    paymentMethodList.map<DropdownMenuItem<String>>((method) {
                      return DropdownMenuItem<String>(
                        value: method["value"], // 👈 internal value
                        child: Text(method["label"]!), // 👈 visible label
                      );
                    }).toList(),
                  );
                }),
              ),
              CustomTextField(
                isRequired: true,
                textEditingController: TextEditingController(
                  text:
                  args.isNotEmpty
                      ? (args["distance"] / 1000).toString()
                      : "",
                ),
                isEnable: false,
                borderColor: AppColors.kGreyColor,
                fillColor: AppColors.kWhiteColor,
                borderRadius: 24.r,
                title: AppStaticStrings.tripDistance,
                // prefixIcon: Padding(
                //   padding: padding14,
                //   child: SvgPicture.asset(calenderIcon),
                // ),
              ),
             Obx(() {
               return    HomeController.to.tripType.value == "pre_book"?  ButtonTapWidget(
                 onTap: () async{
              String? time= await pickDateTime(context);
              dateTimeController.text=time??"";
                 },
                 child: CustomTextField(borderColor: AppColors.kGreyColor,isRequired: true,
                   textEditingController: dateTimeController,
                   fillColor: AppColors.kWhiteColor,
                   borderRadius: 24.r,
                   isEnable: false,
                   hintText: "Select Date Time",
                   title: AppStaticStrings.pickTime,
                    prefixIcon: Padding(
                      padding: padding14,
                      child: SvgPicture.asset(calenderIcon),
                    ),
                  ),
               ):SizedBox.shrink();
              }),
              CustomTextField(
                isEnable: false,
                isRequired: true,
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
                textEditingController: HomeController.to.promoCode,
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
                  HomeController.to.tripArgs.addAll({
                    "paymentType": HomeController.to.selectedPaymentMethod
                        .value,
                    "coupon": HomeController.to.promoCode.text,
                    if( HomeController.to.tripType.value == "pre_book")
                      "pickUpDate":dateTimeController.text
                  });

                  // logger.d(args);
                  if (args.isNotEmpty &&
                      HomeController.to.selectedPaymentMethod.value != null &&(HomeController.to.tripType.value != "pre_book" ||
                      dateTimeController.text.isNotEmpty)) {
                    HomeController.to.requestTrip(body: args);
                  } else {
                    showCustomSnackbar(title: "Alert",
                        message: "This field are required",
                        type: SnackBarType.alert);
                  }
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
