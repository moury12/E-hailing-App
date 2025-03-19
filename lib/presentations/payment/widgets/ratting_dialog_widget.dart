import 'package:e_hailing_app/core/components/custom_button.dart';
import 'package:e_hailing_app/core/components/custom_textfield.dart';
import 'package:e_hailing_app/core/constants/app_static_strings_constant.dart';
import 'package:e_hailing_app/core/constants/color_constants.dart';
import 'package:e_hailing_app/core/constants/custom_space.dart';
import 'package:e_hailing_app/core/constants/custom_text.dart';
import 'package:e_hailing_app/core/constants/fontsize_constant.dart';
import 'package:e_hailing_app/core/constants/image_constant.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
class RattingDialogWidget extends StatelessWidget {
  const RattingDialogWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Stack(
        children: [
          Column(
            spacing: 6.h,
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomText(
                textAlign: TextAlign.center,
                text: AppStaticStrings.writeAReview,
                fontSize: getFontSizeDefault(),
              ),
              Divider(),
              CustomText(
                text: AppStaticStrings.howWouldYouRate,
                fontSize: getFontSizeDefault(),
              ),
              RatingBar(
                initialRating: .5,
                direction: Axis.horizontal,
                allowHalfRating: true,
                itemCount: 5,
                ratingWidget: RatingWidget(
                  full: Icon(CupertinoIcons.star_fill),
                  half:Icon(CupertinoIcons.star_lefthalf_fill),
                  empty: Icon(CupertinoIcons.star),
                ),
                itemPadding: EdgeInsets.symmetric(horizontal: 4.sp),
                onRatingUpdate: (rating) {
                  // BookingManagementController.to.ratingValue.value=rating;
                },
              ),

              CustomTextField(
                title: AppStaticStrings.review,
                hintText:
                AppStaticStrings.enterYourReview,
                borderColor:
                AppColors.kExtraLightTextColor,
                maxLines: 4,
              ),
              space12H,
              CustomButton(
                onTap: () {},
                title: AppStaticStrings.submit,
              ),
            ],
          ),
          GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: SvgPicture.asset(crossIcon),
          ),
        ],
      ),
    );
  }
}
