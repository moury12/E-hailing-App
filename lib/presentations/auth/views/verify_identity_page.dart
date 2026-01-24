import 'package:e_hailing_app/core/components/custom_button.dart';
import 'package:e_hailing_app/core/components/custom_network_image.dart';
import 'package:e_hailing_app/core/components/custom_textfield.dart';
import 'package:e_hailing_app/core/constants/app_static_strings_constant.dart';
import 'package:e_hailing_app/core/constants/color_constants.dart';
import 'package:e_hailing_app/core/constants/custom_space.dart';
import 'package:e_hailing_app/core/constants/custom_text.dart';
import 'package:e_hailing_app/core/constants/fontsize_constant.dart';
import 'package:e_hailing_app/core/constants/hive_boxes.dart';
import 'package:e_hailing_app/core/constants/image_constant.dart';
import 'package:e_hailing_app/core/constants/text_style_constant.dart';
import 'package:e_hailing_app/core/helper/helper_function.dart';
import 'package:e_hailing_app/core/utils/enum.dart';
import 'package:e_hailing_app/core/utils/variables.dart';
import 'package:e_hailing_app/presentations/auth/views/login_page.dart';
import 'package:e_hailing_app/presentations/auth/widgets/auth_scaffold_structure_widget.dart';
import 'package:e_hailing_app/presentations/auth/widgets/auth_text_widgets.dart';
import 'package:e_hailing_app/presentations/navigation/views/navigation_page.dart';
import 'package:e_hailing_app/presentations/splash/controllers/common_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class VerifyIdentityPage extends StatefulWidget {
  static const String routeName = '/verify_identity';

  const VerifyIdentityPage({super.key});

  @override
  State<VerifyIdentityPage> createState() => _VerifyIdentityPageState();
}

class _VerifyIdentityPageState extends State<VerifyIdentityPage> {
  String? token = Get.arguments;
  TextEditingController passportController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AuthScaffoldStructureWidget(
      space: 6.h,
      children: [
        AuthTitleTextWidget(title: AppStaticStrings.verifyYourIdentity.tr),
        CustomTextField(
          title: AppStaticStrings.nricPassport.tr,
          keyboardType: TextInputType.number,
          textEditingController: passportController,
        ),
        space4H,
        CustomText(
          text: AppStaticStrings.uploadNricPassport.tr,
          style: poppinsMedium,
          fontSize: getFontSizeSemiSmall(),
        ),
        ListOfImages(images: CommonController.to.images, isNetworkImage: false),
        CustomButton(
          onTap: () {
            pickImages(
              allowMultiple: true,
              uploadImages: CommonController.to.images,
              imageQuality: 23,
            );
          },
          radius: 4.r,
          fillColor: AppColors.kLightBlueColor,
          child: Row(
            spacing: 8.w,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(uploadIcon),
              CustomText(text: AppStaticStrings.uploadImage.tr),
            ],
          ),
        ),
        space4H,
        Obx(() {
          return CustomButton(
            isLoading: CommonController.to.isVerifingIdentity.value,
            onTap: () async {
              NrcVerificationStatus status = await CommonController.to
                  .verifyUserIdentity(
                    id: passportController.text,
                    images: CommonController.to.images,
                    token:
                        token != null
                            ? token
                            : Boxes.getUserData().get(tokenKey),
                  );
              if (status == NrcVerificationStatus.submitted ||
                  status == NrcVerificationStatus.accepted) {
                CommonController.to.images.clear();
                if (token == null) {
                  Get.offAndToNamed(NavigationPage.routeName);
                } else {
                  Get.offAllNamed(LoginPage.routeName);
                }
              }
            },
            title: AppStaticStrings.confirm.tr,
          );
        }),
      ],
    );
  }
}
