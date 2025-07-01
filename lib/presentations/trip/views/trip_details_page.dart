import 'package:e_hailing_app/core/api-client/api_service.dart';
import 'package:e_hailing_app/core/components/custom_appbar.dart';
import 'package:e_hailing_app/core/components/custom_network_image.dart';
import 'package:e_hailing_app/core/constants/app_static_strings_constant.dart';
import 'package:e_hailing_app/core/constants/color_constants.dart';
import 'package:e_hailing_app/core/constants/custom_space.dart';
import 'package:e_hailing_app/core/constants/custom_text.dart';
import 'package:e_hailing_app/core/constants/fontsize_constant.dart';
import 'package:e_hailing_app/core/constants/padding_constant.dart';
import 'package:e_hailing_app/core/constants/text_style_constant.dart';
import 'package:e_hailing_app/presentations/home/controllers/home_controller.dart';
import 'package:e_hailing_app/presentations/home/widgets/select_car_item_widget.dart';
import 'package:e_hailing_app/presentations/navigation/widgets/custom_container_with_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../../core/components/custom_timeline.dart';
import '../../../core/constants/image_constant.dart';
import '../widgets/car_information_widget.dart';
import '../widgets/row_call_chat_details_button.dart';

class TripDetailsPage extends StatelessWidget {
  static const String routeName = '/trip-details';

  const TripDetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: AppStaticStrings.yourTripDetail),
      body: SingleChildScrollView(
        child: Padding(
          padding: padding16.copyWith(top: 0),
          child: Obx(() {
            final trip = HomeController.to.tripAcceptedModel.value;
            return Column(
              spacing: 12.h,
              children: [
                CarDetailsCardWidget(fare: trip.estimatedFare),

                Container(
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.kLightBlackColor.withValues(alpha: .2),
                        blurRadius: 8.r,
                      ),
                    ],
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: AppColors.kPrimaryExtraLightColor,
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(8.r),
                          ),
                        ),
                        padding: padding12,
                        child: Row(
                          spacing: 12.w,
                          children: [
                            Column(
                              children: [
                                CustomNetworkImage(
                                  imageUrl:
                                      "${ApiService().baseUrl}/${trip.driver?.profileImage}",
                                  height: 42,
                                  width: 42,
                                  boxShape: BoxShape.circle,
                                ),
                                // space4H,
                                // RatingInfoWidget(rating: '5.0'),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CustomText(
                                  text:
                                      trip.driver?.name ??
                                      AppStaticStrings.noDataFound,
                                  style: poppinsBold,
                                  fontSize: getFontSizeDefault(),
                                ),
                                CustomText(
                                  text:
                                      trip.driver?.email ??
                                      AppStaticStrings.noDataFound,
                                  style: poppinsRegular,
                                  fontSize: getFontSizeSmall(),
                                ),
                                CustomText(
                                  text:
                                      'Phone : ${trip.driver?.phoneNumber ?? AppStaticStrings.noDataFound}',
                                  style: poppinsRegular,
                                  fontSize: getFontSizeSmall(),
                                  color: AppColors.kLightBlackColor,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: padding12,
                        decoration: BoxDecoration(
                          color: AppColors.kWhiteColor,
                          borderRadius: BorderRadius.vertical(
                            bottom: Radius.circular(8.r),
                          ),
                        ),
                        child: Column(
                          spacing: 6.h,
                          children: [
                            CarInformationWidget(
                              title: AppStaticStrings.carType,
                              value: 'Honda HRV',
                            ),
                            CarInformationWidget(
                              title: AppStaticStrings.carColor,
                              value: 'Red',
                            ),
                            CarInformationWidget(
                              title: AppStaticStrings.carNumber,
                              value: 'A89BT',
                            ),
                            CarInformationWidget(
                              title: AppStaticStrings.carSeat,
                              value: '4 Seats',
                            ),
                            CarInformationWidget(
                              title: AppStaticStrings.evpNumber,
                              value: 'EV -A89BT',
                            ),
                            CarInformationWidget(
                              title: AppStaticStrings.evpValidityPeriod,
                              value: 'June 2025',
                            ),
                            space6H,
                            CustomTimeline(
                              padding: EdgeInsets.zero,

                              indicators: <Widget>[
                                SvgPicture.asset(pickLocationIcon),
                                SvgPicture.asset(dropLocationIcon),
                              ],
                              children: <Widget>[
                                CustomWhiteContainerWithBorder(
                                  textAlign: TextAlign.start,
                                  text: trip.pickUpAddress,
                                ),

                                CustomWhiteContainerWithBorder(
                                  textAlign: TextAlign.start,

                                  text: trip.dropOffAddress,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                RowCallChatDetailsButton(phoneNumber: trip.driver?.phoneNumber),
                CancelTripButtonWidget(),
              ],
            );
          }),
        ),
      ),
    );
  }
}
