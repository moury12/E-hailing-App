import 'package:e_hailing_app/core/api-client/api_service.dart';
import 'package:e_hailing_app/core/components/custom_appbar.dart';
import 'package:e_hailing_app/core/components/custom_button.dart';
import 'package:e_hailing_app/core/components/custom_network_image.dart';
import 'package:e_hailing_app/core/components/custom_refresh_indicator.dart';
import 'package:e_hailing_app/core/components/tab-bar/dynamic_tab_widget.dart';
import 'package:e_hailing_app/core/constants/app_static_strings_constant.dart';
import 'package:e_hailing_app/core/constants/color_constants.dart';
import 'package:e_hailing_app/core/constants/custom_space.dart';
import 'package:e_hailing_app/core/constants/custom_text.dart';
import 'package:e_hailing_app/core/constants/fontsize_constant.dart';
import 'package:e_hailing_app/core/constants/padding_constant.dart';
import 'package:e_hailing_app/core/constants/text_style_constant.dart';
import 'package:e_hailing_app/core/helper/helper_function.dart';
import 'package:e_hailing_app/core/utils/enum.dart';
import 'package:e_hailing_app/core/utils/variables.dart';
import 'package:e_hailing_app/presentations/home/controllers/home_controller.dart';
import 'package:e_hailing_app/presentations/home/widgets/select_car_item_widget.dart';
import 'package:e_hailing_app/presentations/navigation/widgets/custom_container_with_border.dart';
import 'package:e_hailing_app/presentations/payment/views/payment_page.dart';
import 'package:e_hailing_app/presentations/profile/widgets/review_card_widget.dart';
import 'package:e_hailing_app/presentations/splash/controllers/common_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
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
      appBar: CustomAppBar(title: AppStaticStrings.yourTripDetail.tr),
      body: CustomRefreshIndicator(
        onRefresh: () async {
          HomeController.to.getUserCurrentTrip();
        },
        child: SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          child: Padding(
            padding: padding16.copyWith(top: 0),
            child: Obx(() {
              final trip = HomeController.to.tripAcceptedModel.value;
              return Column(
                spacing: 12.h,
                children: [
                  CarDetailsCardWidget(

                    fare: double
                        .parse((trip.estimatedFare ?? 0).toString())
                        .toInt(),
                  ),

                  Container(
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.kLightBlackColor.withValues(
                            alpha: .2,
                          ),
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
                                    "${ApiService().baseUrl}/${trip.driver
                                        ?.profileImage}",
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
                                        AppStaticStrings.noDataFound.tr,
                                    style: poppinsBold,
                                    fontSize: getFontSizeDefault(),
                                  ),
                                  CustomText(
                                    text:
                                    trip.driver?.email ??
                                        AppStaticStrings.noDataFound.tr,
                                    style: poppinsRegular,
                                    fontSize: getFontSizeSmall(),
                                  ),
                                  CustomText(
                                    text:
                                    'Phone : ${trip.driver?.phoneNumber ??
                                        AppStaticStrings.noDataFound.tr}',
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
                              DynamicTabWidget(
                                  tabs: HomeController.to.tripDetailsTabs,
                                  tabContent: [
                                    Column(
                                      children: [
                                        CarInformationWidget(
                                          title: AppStaticStrings.carType.tr,
                                          value:
                                          trip.driver?.assignedCar?.type ??
                                              AppStaticStrings.noDataFound.tr,
                                        ),
                                        CarInformationWidget(
                                          title: AppStaticStrings.carColor.tr,
                                          value:
                                          trip.driver?.assignedCar?.color ??
                                              AppStaticStrings.noDataFound.tr,
                                        ),
                                        CarInformationWidget(
                                          title: AppStaticStrings.carNumber.tr,
                                          value:
                                          trip.driver?.assignedCar?.carNumber ??
                                              AppStaticStrings.noDataFound.tr,
                                        ),
                                        CarInformationWidget(
                                          title: AppStaticStrings.carSeat.tr,
                                          value: '4 Seats',
                                        ),
                                        CarInformationWidget(
                                          title: AppStaticStrings.evpNumber.tr,
                                          value:
                                          trip.driver?.assignedCar?.evpNumber ??
                                              AppStaticStrings.noDataFound.tr,
                                        ),
                                        CarInformationWidget(
                                          title: AppStaticStrings.evpValidityPeriod.tr,
                                          value:
                                          trip.driver?.assignedCar?.evpExpiry ??
                                              AppStaticStrings.noDataFound.tr,
                                        ),
                                      ],
                                    ),
                                    Column(
                                      children: [
                                        Container(

                                          decoration: BoxDecoration(boxShadow: [
                                            BoxShadow(
                                              color: AppColors.kPrimaryColor
                                                  .withValues(
                                                alpha: .2,
                                              ),
                                              blurRadius: 8.r,
                                            ),
                                          ], color: AppColors.kWhiteColor,
                                            borderRadius: BorderRadius.circular(
                                                8.r),),
                                          width: double.infinity,
                                          padding: padding12,
                                          child:trip.driver!=null? Column(children: [

                                            CustomText(
                                              text: "${AppStaticStrings
                                                  .avgRating.tr} (${trip.driver!
                                                  .rating ?? 0})",
                                              style: poppinsBold,),
                                            RatingBarIndicator(
                                              rating: (trip.driver!.rating ?? 0)
                                                  .toDouble(),
                                              // pass your rating value here (e.g. 3.5)
                                              itemBuilder: (context, index) =>
                                              const Icon(
                                                Icons.star_rate_rounded,
                                                color: Colors.amber,
                                              ),
                                              itemCount: 5,
                                              // total stars
                                              itemSize: 30.0,
                                              // star size
                                              direction: Axis.horizontal,
                                            ),
                                            Obx(() {
                                              return SingleChildScrollView(
                                               scrollDirection: Axis.horizontal,
                                                child: Row(
                                                  children: List.generate(
                                                    CommonController.to.reviewList
                                                        .length, (index) =>
                                                      SizedBox( width: ScreenUtil().screenWidth / 1.5,
                                                        child: ReviewCardWidget(
                                                          reviewModel: CommonController
                                                              .to
                                                              .reviewList[index],),
                                                      ),),),
                                              );
                                            })
                                          ],):SizedBox.shrink(),
                                        )
                                      ],
                                    )
                                  ]),

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
                  trip.driver != null
                      ? RowCallChatDetailsButton(
                    phoneNumber: trip.driver?.phoneNumber,
                    userId: trip.driver!.sId.toString(),
                  )
                      : SizedBox.shrink(),
                  trip.status == DriverTripStatus.destination_reached.name
                      ? CustomButton(
                    onTap: () {
                      Get.toNamed(
                        PaymentPage.routeName,
                        arguments: {"user": trip, "role": user},
                      );
                    },
                    title: AppStaticStrings.payment.tr,
                  )
                      :
                  CancelTripButtonWidget(
                      isLoading: HomeController.to.isCancellingTrip,
                      onSubmit: () {
                        if (HomeController.to.cancelReason.isEmpty) {
                          showCustomSnackbar(
                            title: "Field Required",
                            message: "Need to select the reason",
                          );
                        } else {
                          HomeController.to.updateUserTrip(
                            tripId: trip.sId.toString(),
                            status:
                            DriverTripStatus.cancelled.name.toString(),
                            reason: HomeController.to.cancelReason,
                          );
                          Get.back();
                        }
                      },
                    )
                ],
              );
            }),
          ),
        ),
      ),
    );
  }
}

