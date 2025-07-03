import 'package:e_hailing_app/core/components/custom_network_image.dart';
import 'package:e_hailing_app/core/constants/app_static_strings_constant.dart';
import 'package:e_hailing_app/core/constants/color_constants.dart';
import 'package:e_hailing_app/core/constants/custom_space.dart';
import 'package:e_hailing_app/core/constants/custom_text.dart';
import 'package:e_hailing_app/core/constants/fontsize_constant.dart';
import 'package:e_hailing_app/core/constants/padding_constant.dart';
import 'package:e_hailing_app/core/constants/text_style_constant.dart';
import 'package:e_hailing_app/core/utils/variables.dart';
import 'package:e_hailing_app/presentations/home/widgets/trip_details_card_widget.dart';
import 'package:e_hailing_app/presentations/trip/model/trip_response_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../trip/widgets/rating_info_widget.dart';

class MyRidesHistoryCardItemWidget extends StatelessWidget {
  final TripResponseModel rideModel;

  const MyRidesHistoryCardItemWidget({super.key, required this.rideModel});

  @override
  Widget build(BuildContext context) {
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
          CustomText(
            text: '27-3-2025, 07:00 am',
            style: poppinsSemiBold,
            fontSize: getFontSizeExtraLarge(),
          ),
          space6H,
          Row(
            spacing: 6.w,
            children: [
              ///============================dynamic driver image==============================///
              CustomNetworkImage(
                imageUrl: dummyProfileImage,
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
                      text: 'Fig Nelson',
                      maxLines: 1,
                      fontSize: getFontSizeDefault(),
                    ),
                    RatingInfoWidget(rating: '5.0'),
                  ],
                ),
              ),
              Expanded(
                child: MyRidesHistoryTripInfoWidget(
                  title: AppStaticStrings.finalCost,
                  text: 'RM 250',
                ),
              ),
              Expanded(
                child: MyRidesHistoryTripInfoWidget(
                  title: AppStaticStrings.tripDuration,
                  text: '1.07 km',
                ),
              ),
            ],
          ),
          space4H,

          FromToTimeLine(),
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
