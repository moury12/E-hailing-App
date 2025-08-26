import 'package:e_hailing_app/core/api-client/api_service.dart';
import 'package:e_hailing_app/core/components/custom_network_image.dart';
import 'package:e_hailing_app/core/components/custom_timeline.dart';
import 'package:e_hailing_app/core/constants/app_static_strings_constant.dart';
import 'package:e_hailing_app/core/constants/color_constants.dart';
import 'package:e_hailing_app/core/constants/custom_text.dart';
import 'package:e_hailing_app/core/constants/fontsize_constant.dart';
import 'package:e_hailing_app/core/constants/padding_constant.dart';
import 'package:e_hailing_app/core/constants/text_style_constant.dart';
import 'package:e_hailing_app/core/helper/helper_function.dart';
import 'package:e_hailing_app/core/utils/enum.dart';
import 'package:e_hailing_app/core/utils/variables.dart';
import 'package:e_hailing_app/presentations/home/controllers/home_controller.dart';
import 'package:e_hailing_app/presentations/message/controllers/message_controller.dart';
import 'package:e_hailing_app/presentations/trip/model/trip_response_model.dart';
import 'package:e_hailing_app/presentations/trip/views/trip_details_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../../core/constants/image_constant.dart';
import '../../trip/widgets/row_call_chat_details_button.dart';
import 'gradient_progress_indicator.dart';

class DriverDetails extends StatelessWidget {
  final String? title;
  final String? value;
  final String? userImg;
  final String? userName;
  final String? fare;
  final String? rating;

  const DriverDetails({
    super.key,
    this.title,
    this.value,
    this.userImg,
    this.userName,
    this.fare, this.rating,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 6.w,
      children: [
        CustomNetworkImage(
          imageUrl: userImg ?? dummyProfileImage,
          boxShape: BoxShape.circle,
          height: 42.w,
          width: 42.w,
        ),
        Expanded(
          flex: 2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomText(
                text: userName ?? AppStaticStrings.noDataFound,
                style: poppinsSemiBold,
                fontSize: getFontSizeSemiSmall(),
              ),
              Row(
                children: [
                 if(rating!=null) Row(
                    children: [
                      Icon(CupertinoIcons.star_fill, color: Colors.amber,size: 10.sp,),
                      CustomText(text: " (${rating??"0"}) | ",  fontSize: 9.sp,

                        color: AppColors.kLightBlackColor,)
                    ],
                  ),
                  CustomText(
                    text: 'RM ${fare ?? 00.00}',
                    fontSize: getFontSizeSmall(),

                    color: AppColors.kLightBlackColor,
                  ),
                ],
              ),
            ],
          ),
        ),

        Expanded(
          flex: 2,

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              CustomText(
                textAlign: TextAlign.right,
                text: title ?? 'Estimated Time',
                color: AppColors.kLightBlackColor,
                fontSize: getFontSizeSmall(),
              ),
              CustomText(
                textAlign: TextAlign.right,
                fontSize: getFontSizeSmall(),

                text: value ?? '4.00 Min',
                style: poppinsSemiBold,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class TripDetailsDestinationCard extends StatelessWidget {
  final TripResponseModel? tripModel;

  const TripDetailsDestinationCard({super.key, this.tripModel});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: padding12,
      decoration: BoxDecoration(
        color: AppColors.kWhiteColor,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: AppColors.kPrimaryColor, width: 1.w),
      ),
      padding: padding12,
      child: Column(
        spacing: 8.h,
        children: [
          Obx(() {
            return CustomText(
              text:
                  HomeController.to.driverStatus.value.isEmpty
                      ? "Driver Status"
                      : HomeController.to.driverStatus.value,
              fontSize: getFontSizeSemiSmall(),
            );
          }),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
                    CustomText(
                      text:tripModel?.driver?.assignedCar!=null?
                          "${tripModel?.driver?.assignedCar?.brand ?? AppStaticStrings.noDataFound} "
                          "${tripModel?.driver?.assignedCar?.model} ":AppStaticStrings.noDataFound,
                      fontSize: getFontSizeSmall(),
                    ),
                    Container(
                      padding: EdgeInsets.all(4.r),
                      decoration: BoxDecoration(
                        color: AppColors.kPrimaryColor,
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: CustomText(
                        fontSize: getFontSizeSmall(),

                        text:tripModel?.driver?.assignedCar!=null?
                            "${tripModel?.driver?.assignedCar?.carNumber}(${tripModel?.driver?.assignedCar?.color})":AppStaticStrings.noDataFound,
                        color: AppColors.kWhiteColor,
                      ),
                    ),
                  ],
                ),
              ),
            CustomText(text: '${int.parse(tripModel?.distance.toString() ?? "0") / 1000} km',fontSize: getFontSizeSmall(),)
            ],
          ),
          DriverDetails(
            userName: tripModel?.driver?.name,
            fare: tripModel?.estimatedFare.toString(),
            userImg:
                "${ApiService().baseUrl}/${tripModel?.driver?.profileImage}",
            title: AppStaticStrings.tripDuration,
            value:
            '${int.parse(tripModel?.duration.toString() ?? "0")} min',
            rating: tripModel?.driver?.rating.toString(),
          ),
          FromToTimeLine(
            showTo: true,
            pickUpAddress: tripModel?.pickUpAddress,
            dropOffAddress: tripModel?.dropOffAddress,
          ),

          Obx(() {
            return RowCallChatDetailsButton(
              userId: tripModel!.driver!.sId.toString(),
              lastItemName: AppStaticStrings.details,
              phoneNumber: tripModel?.driver?.phoneNumber,
              isChatLoading: MessageController.to.isLoadingCreateMessage.value,

              onTap: () {
                Get.toNamed(TripDetailsPage.routeName);
              },
            );
          }),
        ],
      ),
    );
  }
}

class TripRequestLoadingWidget extends StatelessWidget {
  const TripRequestLoadingWidget({
    super.key,
    required this.pickUpAddress,
    required this.dropOffAddress,
  });

  final String pickUpAddress;
  final String dropOffAddress;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: padding12,
      padding: padding12,
      decoration: BoxDecoration(
        color: AppColors.kWhiteColor,
        borderRadius: BorderRadius.circular(8.r),
        gradient: LinearGradient(
          colors: [AppColors.kWhiteColor, AppColors.kPrimaryLightColor],
        ),

        // border: Border.all(color: AppColors.kPrimaryColor, width: 1.w),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        spacing: 12.h,
        children: [
          CustomText(
            text: AppStaticStrings.newTripRequest,
            fontSize: getFontSizeDefault(),
          ),
          FromToTimeLine(
            dropOffAddress: dropOffAddress,
            pickUpAddress: pickUpAddress,
          ),
          GradientProgressIndicator(),
          CustomText(
            text: AppStaticStrings.waitingForDriverConformation,
            color: AppColors.kExtraLightBlackColor,
            fontSize: getFontSizeSmall(),
            style: poppinsRegular,
          ),
          CancelTripButtonWidget(onSubmit: () {
            if (HomeController.to.cancelReason.isEmpty) {
              showCustomSnackbar(
                title: "Field Required",
                message: "Need to select the reason",
              );
            } else {
              HomeController.to.updateUserTrip(
                tripId: HomeController.to.currentTrip.value?["data"]['_id'],
                status:
                DriverTripStatus.cancelled.name.toString(),
                reason: HomeController.to.cancelReason,
              );
              Get.back();
            }
          },
isLoading: HomeController.to.isCancellingTrip.value,
          )
        ],
      ),
    );
  }
}

class FromToTimeLine extends StatelessWidget {
  final bool? showTo;
  final String? pickUpAddress;
  final String? dropOffAddress;

  const FromToTimeLine({
    super.key,
    this.showTo = true,
    this.pickUpAddress,
    this.dropOffAddress,
  });

  @override
  Widget build(BuildContext context) {
    return CustomTimeline(
      padding: EdgeInsets.zero,

      indicators: <Widget>[
        SvgPicture.asset(pickLocationIcon),
        if (showTo == true) SvgPicture.asset(dropLocationIcon),
      ],
      children: <Widget>[
        FromToWidget(
          details: pickUpAddress ?? "No pick up address provided",
          headline: AppStaticStrings.from,
        ),
        if (showTo == true)
          FromToWidget(
            details: dropOffAddress ?? "No drop off address provided",
            headline: AppStaticStrings.to,
          ),
      ],
    );
  }
}

class FromToWidget extends StatelessWidget {
  final String headline;
  final String details;

  const FromToWidget({
    super.key,
    required this.headline,
    required this.details,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(
          text: headline,
          style: poppinsSemiBold,
          fontSize: getFontSizeSemiSmall(),
        ),
        CustomText(
          text: details,
          color: AppColors.kLightBlackColor,
          fontSize: getFontSizeSmall(),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}
