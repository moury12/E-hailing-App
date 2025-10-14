import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:e_hailing_app/core/api-client/api_service.dart';
import 'package:e_hailing_app/core/components/custom_button.dart';
import 'package:e_hailing_app/core/helper/helper_function.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../constants/color_constants.dart';
import '../constants/padding_constant.dart';

class CustomNetworkImage extends StatelessWidget {
  final String imageUrl;
  final double? height;
  final double? width;
  final Border? border;
  final BoxFit? fit;
  final double? radius;
  final BorderRadius? borderRadius;
  final BoxShape boxShape;
  final Color? backgroundColor;
  final Widget? child;
  final ColorFilter? colorFilter;
  final String? imageErrorUrl;
  final bool? isImagePreview;

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
    this.boxShape = BoxShape.rectangle,
    this.borderRadius,
    this.fit,
    this.isImagePreview = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap:
          isImagePreview == true
              ? () {
                Get.dialog(
                  Dialog(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Align(
                          alignment: Alignment.topRight,
                          child: IconButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            icon: Icon(
                              CupertinoIcons.multiply_circle_fill,
                              color: AppColors.kPrimaryColor,
                            ),
                          ),
                        ),
                        CachedNetworkImage(
                          imageUrl: imageUrl,
                          fit: BoxFit.fitWidth,
                        ),
                      ],
                    ),
                  ),
                );
              }
              : null,
      child: CachedNetworkImage(
        imageUrl: imageUrl,
        imageBuilder: (context, imageProvider) {
          return Container(
            height: height,
            width: width,
            decoration: BoxDecoration(
              border: border,
              borderRadius:
                  boxShape == BoxShape.circle
                      ? null
                      : borderRadius ?? BorderRadius.circular(radius ?? 8.r),
              shape: boxShape,
              color: backgroundColor,
              image: DecorationImage(
                image: imageProvider,
                fit: fit ?? BoxFit.cover,
                colorFilter: colorFilter,
              ),
            ),
            child: child,
          );
        },
        placeholder: (context, url) {
          return SizedBox(
            height: height,
            width: width,
            child: Center(
              child: Padding(
                padding: padding8,
                child: DefaultProgressIndicator(color: AppColors.kPrimaryColor),
              ),
            ),
          );
        },
        errorWidget: (context, url, error) {
          return Container(
            height: height,
            width: width,
            decoration: BoxDecoration(
              border: border,
              shape: boxShape,
              borderRadius:
                  boxShape == BoxShape.circle
                      ? null
                      : BorderRadius.circular(radius ?? 8.r),

              color: Colors.grey.withValues(alpha: 0.6),
              image: DecorationImage(
                image: AssetImage(
                  imageErrorUrl ?? 'assets/icons/placeholder.png',
                ),
                fit: BoxFit.cover,
              ),
            ),
          );
        },
      ),
    );
  }
}
class ListOfImages extends StatelessWidget {
  final RxList<String> images;
  final bool isNetworkImage ;
  final double? size;
  final bool? isShowCross;

  const ListOfImages({super.key, required this.images,  this.isNetworkImage =true, this.size, this.isShowCross =true});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.sp),
      child: Obx(() {
        return images.isEmpty
            ? SizedBox.shrink()
            : Wrap(
          spacing: 8.w,
          runSpacing: 8.w,
          children: List.generate(images.length, (index) {
            final img = images[index];
            return Stack(
              children: [
                isNetworkImage
                    ? CustomNetworkImage(
                  imageUrl: "${ApiService().baseUrl}/$img",
                  height:size?? 90.w,
                  width:size?? 90.w,
                )
                    : Image.file(
                  File(img),
                  height:size?? 90.w,
                  width:size?? 90.w,
                  fit: BoxFit.cover,
                ),
                isShowCross==true?     Positioned(
                  top: -10,
                  right: -10,

                  child: IconButton(
                    onPressed: () {
                      removeImage(uploadImages: images, imagePath: img);
                      // if (isNetworkImage) {
                      //   SellController.to.removeImgList.add(img);
                      //   logger.d( SellController.to.removeImgList.length);
                      // }
                    },
                    icon: Icon(
                      CupertinoIcons.multiply_circle_fill,
                      size: 20,
                      color: AppColors.kPrimaryColor,
                    ),
                  ),
                ):SizedBox.shrink(),
              ],
            );
          }),
        );
      }),
    );
  }
}
