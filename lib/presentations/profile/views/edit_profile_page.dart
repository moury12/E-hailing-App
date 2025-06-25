import 'dart:io';

import 'package:e_hailing_app/core/api-client/api_service.dart';
import 'package:e_hailing_app/core/components/custom_appbar.dart';
import 'package:e_hailing_app/core/components/custom_button.dart';
import 'package:e_hailing_app/core/components/custom_network_image.dart';
import 'package:e_hailing_app/core/components/custom_textfield.dart';
import 'package:e_hailing_app/core/constants/app_static_strings_constant.dart';
import 'package:e_hailing_app/core/constants/color_constants.dart';
import 'package:e_hailing_app/core/constants/padding_constant.dart';
import 'package:e_hailing_app/core/helper/helper_function.dart';
import 'package:e_hailing_app/presentations/profile/controllers/account_information_controller.dart';
import 'package:e_hailing_app/presentations/splash/controllers/common_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class EditProfilePage extends StatelessWidget {
  static const String routeName = "/edit";

  const EditProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: AppStaticStrings.profile),
      body: SingleChildScrollView(
        child: Padding(
          padding: padding12,
          child: Obx(() {
            return Column(
              spacing: 12.h,
              children: [
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    AccountInformationController.to.profileImgPath.value.isEmpty
                        ? CustomNetworkImage(
                          imageUrl:
                              "${ApiService().baseUrl}/${CommonController.to.userModel.value.img}",
                          height: 150.w,
                          width: 150.w,
                          boxShape: BoxShape.circle,
                        )
                        : ClipOval(
                          child: Image.file(
                            File(
                              AccountInformationController
                                  .to
                                  .profileImgPath
                                  .value,
                            ),
                            fit: BoxFit.cover,
                            height: 150.w,
                            width: 150.w,
                          ),
                        ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        decoration: BoxDecoration(
                          color: AppColors.kPrimaryLightColor,
                          shape: BoxShape.circle,
                        ),

                        child: GestureDetector(
                          onTap: () {
                            pickImages(
                              singleImagePath:
                                  AccountInformationController
                                      .to
                                      .profileImgPath,
                            );
                          },
                          child: Padding(
                            padding: padding8,
                            child: Icon(
                              Icons.add_a_photo_outlined,
                              size: 25.sp,
                              color: AppColors.kTextColor,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                CustomTextField(
                  title: AppStaticStrings.fullName,
                  textEditingController:
                      AccountInformationController.to.nameController.value,
                ),
                CustomTextField(
                  title: AppStaticStrings.phoneNumber,
                  textEditingController:
                      AccountInformationController
                          .to
                          .contactNumberController
                          .value,
                ),
                CustomTextField(
                  title: AppStaticStrings.placeAddress,
                  textEditingController:
                      AccountInformationController.to.placeController.value,
                ),
                CustomButton(
                  onTap: () {
                    AccountInformationController.to.updateProfileRequest();
                  },
                  title: AppStaticStrings.save,
                  isLoading:
                      AccountInformationController
                          .to
                          .isLoadingUpdateProfile
                          .value,
                ),
              ],
            );
          }),
        ),
      ),
    );
  }
}
