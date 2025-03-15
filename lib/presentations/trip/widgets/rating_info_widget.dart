
import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/constants/color_constants.dart';
import '../../../core/constants/custom_text.dart';
import '../../../core/constants/text_style_constant.dart';

class RatingInfoWidget extends StatelessWidget {
  final String rating;
  const RatingInfoWidget({
    super.key, required this.rating,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 4.w,
      children: [
        Icon(
          CupertinoIcons.star_fill,
          color: AppColors.kYellowColor,
          size: 15.sp,
        ),
        CustomText(text: rating, style: poppinsBold),
      ],
    );
  }
}