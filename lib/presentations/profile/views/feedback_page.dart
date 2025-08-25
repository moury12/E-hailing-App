import 'package:e_hailing_app/core/components/custom_appbar.dart';
import 'package:e_hailing_app/core/components/custom_refresh_indicator.dart';
import 'package:e_hailing_app/core/constants/app_static_strings_constant.dart';
import 'package:e_hailing_app/core/constants/color_constants.dart';
import 'package:e_hailing_app/core/constants/custom_space.dart';
import 'package:e_hailing_app/core/constants/custom_text.dart';
import 'package:e_hailing_app/core/constants/fontsize_constant.dart';
import 'package:e_hailing_app/core/constants/image_constant.dart';
import 'package:e_hailing_app/core/constants/padding_constant.dart';
import 'package:e_hailing_app/core/constants/text_style_constant.dart';
import 'package:e_hailing_app/core/helper/helper_function.dart';
import 'package:e_hailing_app/presentations/profile/controllers/account_information_controller.dart';
import 'package:e_hailing_app/presentations/profile/widgets/feedback_content_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class FeedbackPage extends StatelessWidget {
  static const String routeName = '/feedback';

  const FeedbackPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: AppStaticStrings.feedback),
      body: CustomRefreshIndicator(
        onRefresh: () async{
          AccountInformationController.to.getContactSupportRequest();
        },
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Obx(() {
                return FeedbackContentWidget(
                  title:
                  "${AppStaticStrings.mailUs} (${AccountInformationController.to
                      .isLoadingHelpSupport.value
                      ? " email loading..."
                      : AccountInformationController.to.contactEmail.value
                      .isNotEmpty
                      ? AccountInformationController.to.contactEmail.value
                      : "Email is Missing"})",
                  img: mailUsIcon,
                  onTap: () {
                    if (AccountInformationController.to.contactEmail.value
                        .isNotEmpty) {
                      launchEmail(
                        AccountInformationController.to.contactEmail.value,
                        subject: "Help/Support Need For DUDU Car APP",
                      );
                    }
                  },
                );
              }),
            ),
            SliverToBoxAdapter(
              child: Obx(() {
                return FeedbackContentWidget(
                  title: "${AppStaticStrings
                      .contactUs} (${AccountInformationController.to
                      .isLoadingHelpSupport.value
                      ? "phone number loading..."
                      : AccountInformationController.to.contactNumber.value
                      .isNotEmpty
                      ? AccountInformationController.to.contactNumber.value
                      : "phone number is Missing"})",
                  img: whatsappIcon,
                  onTap: () {
                    if (AccountInformationController.to.contactNumber.value
                        .isNotEmpty) {
                      launchWhatsApp(
                        AccountInformationController.to.contactNumber.value,
                        message: "Hello, I need support.",
                      );
                    }
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
