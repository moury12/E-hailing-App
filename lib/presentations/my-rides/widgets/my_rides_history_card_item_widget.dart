import 'package:e_hailing_app/core/components/custom_network_image.dart';
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
import 'package:e_hailing_app/presentations/driver-dashboard/controllers/dashboard_controller.dart';
import 'package:e_hailing_app/presentations/driver-dashboard/model/driver_current_trip_model.dart';
import 'package:e_hailing_app/presentations/home/widgets/trip_details_card_widget.dart';
import 'package:e_hailing_app/presentations/payment/views/payment_invoice_page.dart';
import 'package:e_hailing_app/presentations/trip/widgets/row_call_chat_details_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../core/api-client/api_service.dart';
import '../../trip/model/trip_response_model.dart';
import '../../trip/widgets/rating_info_widget.dart';

class MyRidesHistoryCardItemWidget extends StatelessWidget {
  final dynamic rideModel;
  final bool isDriver;
  final bool isOngoin;
  final bool showInvoice;

  const MyRidesHistoryCardItemWidget({
    super.key,
    required this.rideModel,
    required this.isDriver,
    this.isOngoin = false,this.showInvoice = false,
  });

  @override
  Widget build(BuildContext context) {
    // Fallback/default values
    String driverName = 'Unknown Driver';
    String driverImage = dummyProfileImage;
    String rating = '0.0';
    String cost = 'RM 0';
    String distance = '0 km';
    String dateTime = 'N/A';
    String? pickup;
    String? dropOff;

    if (rideModel is DriverCurrentTripModel) {
      final model = rideModel as DriverCurrentTripModel;
      // rating=isDriver?model.driver!.rating.toString():"0.0";
      driverName = model.user?.name ?? driverName;
      driverImage =
      model.user?.profileImage != null
          ? "${ApiService().baseUrl}/${model.user!.profileImage}"
          : driverImage;
      cost = 'RM ${model.estimatedFare?.toStringAsFixed(2) ?? "0"}';
      distance = '${((model.distance??0) /1000).toStringAsFixed(1)} km';
      dateTime = formatDateTime(model.pickUpDate!=null?model.pickUpDate.toString():model.createdAt.toString());
      pickup = model.pickUpAddress;
      dropOff = model.dropOffAddress; // define this method below
    }
    else if (rideModel is TripResponseModel) {
      final model = rideModel as TripResponseModel;

      driverName =
          (isDriver
              ? model.user?.name.toString()
              : model.driver?.name.toString()) ??
              AppStaticStrings.noDataFound;
      rating=!isDriver?model.driver!.rating.toString():"0.0";
      driverImage =
      model.driver?.profileImage != null
          ? "${ApiService().baseUrl}/${(isDriver ? model.user?.profileImage
          .toString() : model.driver?.profileImage.toString())}"
          : driverImage;
      cost = 'RM ${model.estimatedFare?.toStringAsFixed(2) ?? "0"}';
      distance = '${((model.distance??0) /1000).toStringAsFixed(1)} km';
      dateTime = formatDateTime(model.pickUpDate!=null?model.pickUpDate.toString():model.createdAt.toString());
      pickup = model.pickUpAddress;
      dropOff = model.dropOffAddress;
    }

    return Container(
      margin: EdgeInsets.symmetric(vertical: 6.h),
      decoration: BoxDecoration(
        color: AppColors.kWhiteColor,
        borderRadius: BorderRadius.circular(8.r),
      ),
      padding: padding12,
      child: Column(
        spacing: 6.h,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          ///============================dynamic date==============================///
          Row(
            children: [
              Expanded(
                child: CustomText(
                  text: dateTime,
                  style: poppinsSemiBold,
                  fontSize: getFontSizeExtraLarge(),
                ),
              ),
              if(showInvoice)
                IconButton(onPressed: () {
                  Get.to(PaymentInvoicePage(rideModel: rideModel,isDriver: isDriver));
                }, icon: Icon(Icons.receipt_long,color: AppColors.kPrimaryColor,))
            ],
          ),
          Row(
            spacing: 6.w,
            children: [

              ///============================dynamic driver image==============================///
              CustomNetworkImage(
                imageUrl: driverImage,
                boxShape: BoxShape.circle,
                height: 42.w,
                width: 42.w,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    ///============================dynamic driver name rating ==============================///
                    CustomText(
                      text: driverName,
                      maxLines: 1,
                      fontSize: getFontSizeDefault(),
                    ),
                    RatingInfoWidget(rating: rating),
                    // !isDriver?RatingInfoWidget(rating: rating):SizedBox.shrink(),
                  ],
                ),
              ),
              Expanded(
                child: MyRidesHistoryTripInfoWidget(
                  title: AppStaticStrings.finalCost,
                  text: cost,
                ),
              ),
              Expanded(
                child: MyRidesHistoryTripInfoWidget(
                  title: AppStaticStrings.tripDistance,
                  text: distance, 
                ),
              ),
            ],
          ),
          space4H,

          ///============================Timeline==============================///
          FromToTimeLine(pickUpAddress: pickup, dropOffAddress: dropOff),
          if (isDriver && isOngoin)
            CancelTripButtonWidget(
                // isLoading: DashBoardController.to.isCancellingTrip.value,
                onSubmit: () {
                  if (DashBoardController.to.cancelReason.isEmpty) {
                    showCustomSnackbar(
                      title: "Field Required",
                      message: "Need to select the reason",
                    );
                  } else {
                    DashBoardController.to.driverTripUpdateStatus(
                      tripId: rideModel.sId.toString(),

                      reason: DashBoardController.to.cancelReason,
                      newStatus: DriverTripStatus.cancelled.name.toString(),
                    );
                    Get.back();
                  }
                },
              )
        ],
      ),
    );
  }
}

class MyRidesHistoryTripInfoWidget extends StatelessWidget {
  final String title;
  final String text;

  const MyRidesHistoryTripInfoWidget({
    super.key,
    required this.title,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(
          text: title,
          color: AppColors.kExtraLightTextColor,
          fontSize: getFontSizeSmall(),
        ),

        ///============================dynamic trip cost ==============================///
        CustomText(text: text, style: poppinsSemiBold),
      ],
    );
  }
}
