import 'package:e_hailing_app/core/api-client/api_service.dart';
import 'package:e_hailing_app/core/components/custom_network_image.dart';
import 'package:e_hailing_app/core/constants/color_constants.dart';
import 'package:e_hailing_app/core/constants/padding_constant.dart';
import 'package:e_hailing_app/core/helper/helper_function.dart';
import 'package:e_hailing_app/presentations/splash/controllers/common_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../model/chat_message_model.dart';

class ChatMessageCardItemWidget extends StatelessWidget {
  const ChatMessageCardItemWidget({
    super.key,
    required this.sendByMe,
    required this.message,
    required this.chatModel,
  });

  final bool sendByMe;
  final Messages message;
  final ChatModel chatModel;

  Participants? getOtherUser() {
    final myId = CommonController.to.userModel.value.sId;

    if (chatModel.participants == null) return null;

    return chatModel.participants!.firstWhere(
      (p) => p.sId != myId,
      orElse: () => Participants(name: 'Unknown', profileImage: null),
    );
  }

  @override
  Widget build(BuildContext context) {
    bool isToday = isTodayFunction(message.createdAt.toString());
    String createdDate =
        isToday
            ? formatTime(message.createdAt.toString())
            : formatDate(message.createdAt.toString());
    return Padding(
      padding: EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment:
            sendByMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!sendByMe)
            Padding(
              padding: EdgeInsets.only(left: 12),
              child: CustomNetworkImage(
                imageUrl:
                    "${ApiService().baseUrl}/${getOtherUser()!.profileImage.toString()}",
                height: 50.w,
                boxShape: BoxShape.circle,
                width: 50.w,
              ),
            ),
          Expanded(
            child: Column(
              crossAxisAlignment:
                  sendByMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                // Message container
                Container(
                  margin: EdgeInsets.only(
                    left: sendByMe ? 0 : 8,
                    right: sendByMe ? 8 : 0,
                  ),
                  constraints: BoxConstraints(maxWidth: Get.width * 0.8),
                  padding: paddingH12V8,

                  decoration: BoxDecoration(
                    color:
                        sendByMe
                            ? AppColors.kLightGreyColor
                            : AppColors.kBrightBlueColor,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    message.message.toString(),
                    style: TextStyle(
                      color:
                          sendByMe
                              ? AppColors.kTextColor
                              : AppColors.kWhiteColor,
                      fontSize: 15,
                    ),
                  ),
                ),

                // Timestamp
                Padding(
                  padding: EdgeInsets.only(
                    top: 4,
                    left: sendByMe ? 0 : 8,
                    right: sendByMe ? 8 : 0,
                  ),
                  child: Text(
                    createdDate,
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  ),
                ),
              ],
            ),
          ),

          // User avatar (only for user messages)
        ],
      ),
    );
  }
}
