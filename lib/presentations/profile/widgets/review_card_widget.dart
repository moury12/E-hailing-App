import 'package:e_hailing_app/core/api-client/api_service.dart';
import 'package:e_hailing_app/core/components/custom_network_image.dart';
import 'package:e_hailing_app/core/constants/color_constants.dart';
import 'package:e_hailing_app/core/constants/custom_space.dart';
import 'package:e_hailing_app/core/constants/custom_text.dart';
import 'package:e_hailing_app/core/constants/fontsize_constant.dart';
import 'package:e_hailing_app/core/constants/padding_constant.dart';
import 'package:e_hailing_app/core/constants/text_style_constant.dart';
import 'package:e_hailing_app/presentations/profile/model/review_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ReviewCardWidget extends StatelessWidget {
  final ReviewModel reviewModel;

  const ReviewCardWidget({super.key, required this.reviewModel});

  @override
  Widget build(BuildContext context) {
    return Container(

      padding: padding8,
      margin: padding8.copyWith(left: 0),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: AppColors.kPrimaryColor.withValues(alpha: .2),
            blurRadius: 8.r,
          ),
        ],
        color: AppColors.kWhiteColor,
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CustomNetworkImage(
                imageUrl:
                    "${ApiService().baseUrl}/${reviewModel.user!.profileImage}",
                height: 40.sp,
                width: 40.sp,
                boxShape: BoxShape.circle,
              ),
              space8W,
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                    text: reviewModel.user!.name.toString(),
                    style: poppinsSemiBold,
                  ),
                  Row(
                    children: [
                      Icon(Icons.star_rate_rounded, color: Colors.amber,size: 15.sp,),
                      CustomText(text: "(${reviewModel.rating.toString()})",fontSize: getFontSizeSmall(),)
                    ],
                  )
                ],
              ),
            ],
          ),
          space4H,
          CustomText(text: reviewModel.review.toString(),fontSize: getFontSizeSmall(),
          style: poppinsMedium,
           textAlign: TextAlign.left,)
        ],
      ),
    );
  }
}
