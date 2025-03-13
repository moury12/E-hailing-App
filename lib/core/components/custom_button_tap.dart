import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../constants/color_constants.dart';

class ButtonTapWidget extends StatelessWidget {
  const ButtonTapWidget({
    super.key,
    required this.child,
    this.onTap,
    this.radius,
    this.shape,
  });

  final Widget child;
  final Function()? onTap;
  final double? radius;
  final ShapeBorder? shape;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(

        customBorder: shape,
        splashColor: AppColors.kPrimaryColor.withValues(alpha: .2),
        onTap: onTap,
        borderRadius: BorderRadius.circular(radius ?? 12.r),
        child: child,
      ),
    );
  }
}
