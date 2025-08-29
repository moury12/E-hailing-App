import 'package:e_hailing_app/core/api-client/api_service.dart';
import 'package:e_hailing_app/core/components/custom_button_tap.dart';
import 'package:e_hailing_app/core/components/custom_network_image.dart';
import 'package:e_hailing_app/core/constants/app_static_strings_constant.dart';
import 'package:e_hailing_app/core/constants/custom_text.dart';
import 'package:e_hailing_app/core/constants/fontsize_constant.dart';
import 'package:e_hailing_app/core/constants/text_style_constant.dart';
import 'package:e_hailing_app/core/helper/helper_function.dart';
import 'package:e_hailing_app/presentations/message/controllers/message_controller.dart';
import 'package:e_hailing_app/presentations/message/model/conversation_model.dart';
import 'package:e_hailing_app/presentations/message/views/chatting_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';

import '../../../core/constants/color_constants.dart';
import '../../../core/constants/padding_constant.dart';

class MessageCardItemWidget extends StatelessWidget {
  final ConversationModel chatModel;
  final bool? isRead;

  const MessageCardItemWidget({
    super.key,
    this.isRead = false,
    required this.chatModel,
  });

  @override
  Widget build(BuildContext context) {
    final otherUser = MessageController.to.getOtherUser(chatModel);
    bool isToday = isTodayFunction(chatModel.updatedAt.toString());
    String createdDate =
        isToday
            ? formatTime(chatModel.updatedAt.toString())
            : formatDate(chatModel.updatedAt.toString());
    return Container(
      decoration: BoxDecoration(
        color:
            isRead == false
                ? AppColors.kUnreadMessageColor
                : AppColors.kWhiteColor,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [BoxShadow(color: AppColors.kLightBlackColor)],
      ),
      child: ButtonTapWidget(
        radius: 16.r,
        onTap: () async {
          Get.toNamed(
            ChattingPage.routeName,
            arguments: chatModel.sId.toString(),
          );
        },
        child: Padding(
          padding: padding12,
          child: Row(
            spacing: 12.w,
            children: [
              CustomNetworkImage(
                imageUrl: "${ApiService().baseUrl}/${otherUser!.profileImage}",
                boxShape: BoxShape.circle,
                height: 50.w,
                width: 50.w,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ///=============================dynamic user name =============================///
                    CustomText(
                      text: otherUser.name ?? AppStaticStrings.noDataFound,
                      style: poppinsBold,
                    ),

                    ///=============================dynamic message count =============================///
                    CustomText(
                      text:
                          chatModel.unRead! > 0
                              ? "${chatModel.unRead} New Message"
                              : 'No New Message',
                      style: poppinsRegular,
                      fontSize: getFontSizeSmall(),
                      color: AppColors.kExtraLightBlackColor,
                    ),

                    // ///=============================dynamic message =============================///
                    // CustomText(
                    //   text: 'Hello! Im available to pick you up. Ill be th..',
                    //   style: poppinsRegular,
                    //   fontSize: getFontSizeSmall(),
                    // ),
                  ],
                ),
              ),
              CustomText(
                text: createdDate,
                style: poppinsBold,
                fontSize: getFontSizeSmall(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


class MessageCardShimmer extends StatelessWidget {
  const MessageCardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColors.kShimmerBaseColor,
      highlightColor: AppColors.kShimmerHighlightColor,
      child: Container(
        margin: paddingH12V6,
        decoration: BoxDecoration(
          color: AppColors.kWhiteColor,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
          ],
        ),
        padding: EdgeInsets.all(12),
        child: Row(
          children: [
            // Profile Image Placeholder
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: AppColors.kShimmerBaseColor,
                shape: BoxShape.circle,
              ),
            ),
            SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Name placeholder
                  Container(
                    width: double.infinity,
                    height: 14,
                    color: AppColors.kShimmerBaseColor,
                  ),
                  SizedBox(height: 8),
                  // Message count placeholder
                  Container(
                    width: 100,
                    height: 12,
                    color: AppColors.kShimmerBaseColor,
                  ),
                ],
              ),
            ),
            SizedBox(width: 12),
            // Date placeholder
            Container(
              width: 40,
              height: 12,
              color: AppColors.kShimmerBaseColor,
            ),
          ],
        ),
      ),
    );
  }
}
