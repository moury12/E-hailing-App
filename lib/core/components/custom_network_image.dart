import 'package:cached_network_image/cached_network_image.dart';
import 'package:e_hailing_app/core/components/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../constants/color_constants.dart';
import '../constants/padding_constant.dart';

class CustomNetworkImage extends StatelessWidget {
  final String imageUrl;
  final double? height;
  final double? width;
  final Border? border;
  final double? radius;
  final BorderRadius? borderRadius;
  final BoxShape boxShape;
  final Color? backgroundColor;
  final Widget? child;
  final ColorFilter? colorFilter;
  final String? imageErrorUrl;

  const CustomNetworkImage({
    super.key,
    this.child,
    this.colorFilter,
    required this.imageUrl,
    this.imageErrorUrl,
    this.backgroundColor,
    this.height,
    this.width,
    this.border,
    this.radius,
    this.boxShape = BoxShape.rectangle, this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: imageUrl,
      imageBuilder: (context, imageProvider) {
        return Container(
          height: height,
          width: width,
          decoration: BoxDecoration(
            border: border,
            borderRadius:boxShape==BoxShape.circle? null:borderRadius??BorderRadius.circular(radius??8.r),
            shape: boxShape,
            color: backgroundColor,
            image: DecorationImage(
              image: imageProvider,
              fit: BoxFit.cover,
              colorFilter: colorFilter,
            ),
          ),
          child: child,
        );
      },
      placeholder: (context, url) {
        return Center(
            child: Padding(
              padding: padding8,
              child: DefaultProgressIndicator(
                        color: AppColors.kPrimaryColor,
                      ),
            ));
      },
      errorWidget: (context, url, error) {
        return Container(
          height: height,
          width: width,
          decoration: BoxDecoration(
            border: border,
            borderRadius: BorderRadius.circular(radius??8.r),
            shape: boxShape,
            color: Colors.grey.withOpacity(0.6),
            image: DecorationImage(
              image: AssetImage(imageErrorUrl ?? ''),
              fit: BoxFit.cover,
            ),
          ),
        );
      },
    );
  }
}
