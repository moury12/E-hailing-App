import 'package:e_hailing_app/core/api-client/api_service.dart';
import 'package:e_hailing_app/core/constants/app_static_strings_constant.dart';
import 'package:e_hailing_app/core/components/custom_network_image.dart';
import 'package:e_hailing_app/core/components/expandable_text_widget.dart';
import 'package:e_hailing_app/core/constants/color_constants.dart';
import 'package:e_hailing_app/core/constants/custom_space.dart';
import 'package:e_hailing_app/core/constants/custom_text.dart';
import 'package:e_hailing_app/core/constants/fontsize_constant.dart';
import 'package:e_hailing_app/core/constants/padding_constant.dart';
import 'package:e_hailing_app/core/constants/text_style_constant.dart';
import 'package:e_hailing_app/presentations/profile/model/review_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:shimmer/shimmer.dart';

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
                    reviewModel.user != null
                        ? "${ApiService().baseUrl}/${reviewModel.user?.profileImage}"
                        : "",
                height: 40.sp,
                width: 40.sp,
                boxShape: BoxShape.circle,
              ),
              space8W,
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                    text:
                        reviewModel.user?.name ??
                        AppStaticStrings.noDataFound.tr,
                    style: poppinsSemiBold,
                  ),
                  Row(
                    children: [
                      Icon(
                        Icons.star_rate_rounded,
                        color: Colors.amber,
                        size: 15.sp,
                      ),
                      CustomText(
                        text: "(${reviewModel.rating ?? 0})",
                        fontSize: getFontSizeSmall(),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          space4H,
          ExpandableText(text: reviewModel.review ?? ""),
        ],
      ),
    );
  }
}

class ReviewCardShimmer extends StatelessWidget {
  const ReviewCardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColors.kShimmerBaseColor,
      highlightColor: AppColors.kShimmerHighlightColor,
      child: Container(
        padding: padding8,
        margin: padding8.copyWith(left: 0),
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: AppColors.kPrimaryColor.withValues(alpha: .1),
              blurRadius: 8.r,
            ),
          ],
          color: AppColors.kWhiteColor,
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile + name + rating row
            Row(
              children: [
                Container(
                  height: 40.sp,
                  width: 40.sp,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                ),
                space8W,
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(height: 12.sp, width: 80.sp, color: Colors.white),
                    space4H,
                    Container(height: 10.sp, width: 50.sp, color: Colors.white),
                  ],
                ),
              ],
            ),
            space8H,
            // Review text placeholder
            Container(
              height: 12.sp,
              width: double.infinity,
              color: Colors.white,
            ),
            space4H,
            Container(
              height: 12.sp,
              width: MediaQuery.of(context).size.width * 0.7,
              color: Colors.white,
            ),
          ],
        ),
      ),
    );
  }
}
