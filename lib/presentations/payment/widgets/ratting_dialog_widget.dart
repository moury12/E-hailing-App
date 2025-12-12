import 'package:e_hailing_app/core/components/custom_button.dart';
import 'package:e_hailing_app/core/components/custom_textfield.dart';
import 'package:e_hailing_app/core/constants/app_static_strings_constant.dart';
import 'package:e_hailing_app/core/constants/color_constants.dart';
import 'package:e_hailing_app/core/constants/custom_space.dart';
import 'package:e_hailing_app/core/constants/custom_text.dart';
import 'package:e_hailing_app/core/constants/fontsize_constant.dart';
import 'package:e_hailing_app/core/constants/image_constant.dart';
import 'package:e_hailing_app/core/helper/helper_function.dart';
import 'package:e_hailing_app/presentations/home/controllers/home_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class RattingDialogWidget extends StatefulWidget {
  final String carID;
  const RattingDialogWidget({super.key, required this.carID});

  @override
  State<RattingDialogWidget> createState() => _RattingDialogWidgetState();
}

class _RattingDialogWidgetState extends State<RattingDialogWidget> {
  double? _rating;

  final TextEditingController _reviewController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: AlertDialog(
        content: Stack(
          children: [
            Column(
              spacing: 6.h,
              mainAxisSize: MainAxisSize.min,
              children: [
                CustomText(
                  textAlign: TextAlign.center,
                  text: AppStaticStrings.writeAReview.tr,
                  fontSize: getFontSizeDefault(),
                ),
                const Divider(),
                CustomText(
                  text: AppStaticStrings.howWouldYouRate.tr,
                  fontSize: getFontSizeDefault(),
                ),

                // ⭐ Rating bar
                RatingBar(
                  initialRating: 0,
                  direction: Axis.horizontal,
                  allowHalfRating: true,
                  itemCount: 5,
                  ratingWidget: RatingWidget(
                    full: const Icon(CupertinoIcons.star_fill),
                    half: const Icon(CupertinoIcons.star_lefthalf_fill),
                    empty: const Icon(CupertinoIcons.star),
                  ),
                  itemSize: 30.sp,
                  itemPadding: EdgeInsets.symmetric(horizontal: 4.sp),
                  onRatingUpdate: (rating) {
                    setState(() => _rating = rating);
                  },
                ),

                // 📝 Review field
                CustomTextField(
                  textEditingController: _reviewController,
                  title: AppStaticStrings.review.tr,
                  hintText: AppStaticStrings.enterYourReview.tr,
                  borderColor: AppColors.kExtraLightTextColor,
                  maxLines: 4,
                ),
                space12H,

                // ✅ Submit button
                Obx(() {
                  return CustomButton(
                    isLoading: HomeController.to.isLoadingPostReview.value,
                    onTap: () {
                      final review = _reviewController.text.trim();
                      if (_rating != null ) {
                        HomeController.to.postReviewRatingRequest(
                          rating: _rating.toString(),
                          review: review,
                          carId: widget.carID
                        );
                      }else{
                        showCustomSnackbar(title: "Failed", message: "Rating Review Field is required");
                      }
                    },
                    title: AppStaticStrings.submit.tr,
                  );
                }),
              ],
            ),

            // ❌ Close button
            Positioned(
              top: 0,
              right: 0,
              child: GestureDetector(
                onTap: () => Get.back(),
                child: SvgPicture.asset(crossIcon),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
