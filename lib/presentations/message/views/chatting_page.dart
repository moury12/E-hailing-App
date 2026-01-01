import 'package:e_hailing_app/core/components/custom_appbar.dart';
import 'package:e_hailing_app/core/components/custom_button.dart';
import 'package:e_hailing_app/core/components/custom_textfield.dart';
import 'package:e_hailing_app/core/constants/color_constants.dart';
import 'package:e_hailing_app/core/constants/image_constant.dart';
import 'package:e_hailing_app/core/constants/padding_constant.dart';
import 'package:e_hailing_app/core/helper/helper_function.dart';

import 'package:e_hailing_app/presentations/message/controllers/chatting_controller.dart';
import 'package:e_hailing_app/presentations/message/model/chat_message_model.dart';
import 'package:e_hailing_app/presentations/message/widgets/chat_loading.dart';
import 'package:e_hailing_app/presentations/message/widgets/chat_message_card_item_widget.dart';
import 'package:e_hailing_app/presentations/profile/controllers/account_information_controller.dart';
import 'package:e_hailing_app/presentations/save-location/widgets/empty_widget.dart';
import 'package:e_hailing_app/core/utils/variables.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class ChattingPage extends GetView<ChattingController> {
  static const String routeName = '/chatting';

  const ChattingPage({super.key});

  Participants? getOtherUser(ChatModel? meta) {
    final myId = AccountInformationController.to.userModel.value.sId;

    if (meta == null || meta.participants == null) return null;

    return meta.participants!.firstWhere(
      (p) => p.sId != myId,
      orElse: () => Participants(name: 'Unknown', profileImage: null),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: Obx(() {
          final meta = controller.chatMetaModel.value;
          final other = meta != null ? getOtherUser(meta) : Participants();

          return CustomAppBar(
            title: other?.name ?? "User Name Loading...",
            action: [
              Padding(
                padding: EdgeInsets.only(right: 12.w),
                child: PrimaryCircleButtonWidget(
                  actionIcon: callIcon,
                  onTap: () {
                    if (other != null) {
                      callOnPhone(
                        phoneNumber: other.phoneNumber ?? '00000000000',
                      );
                    }
                  },
                ),
              ),
            ],
          );
        }),
      ),
      body: Column(
        children: [
          Expanded(
            child: GetBuilder<ChattingController>(
              id: 'chat_list',
              builder: (controller) {
                final messages = controller.messagesList;
                final isLoading = controller.isLoadingMessage.value;
                final isLoadingMore = controller.isLoadingMore.value;
                final meta = controller.chatMetaModel.value;

                logger.d(
                  "[Chat] GetBuilder Rebuild - Count: ${messages.length}, Hash: ${controller.hashCode}",
                );

                // Show loading indicator for first page
                if (isLoading && messages.isEmpty) {
                  return ShimmerChatList();
                }

                // Show empty state
                if (messages.isEmpty && !isLoading) {
                  return EmptyWidget(text: "No messages.");
                }

                // Show messages list
                return ListView.builder(
                  reverse: true,
                  controller: controller.scrollController,
                  itemCount: messages.length + (isLoadingMore ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (index == messages.length) {
                      return Padding(
                        padding: EdgeInsets.all(16.w),
                        child: Center(child: DefaultProgressIndicator()),
                      );
                    }

                    final item = messages[index];
                    return ChatMessageCardItemWidget(
                      sendByMe:
                          AccountInformationController.to.userModel.value.sId ==
                          item.sender,
                      message: item,
                      chatModel: meta ?? ChatModel(),
                    );
                  },
                );
              },
            ),
          ),
          Padding(
            padding: padding8.copyWith(bottom: 12.w),
            child: Row(
              children: [
                Expanded(
                  child: CustomTextField(
                    hintText: 'Type message...',
                    borderColor: Colors.transparent,
                    fillColor: AppColors.kWhiteColor,
                    borderRadius: 16.r,
                    keyboardType: TextInputType.multiline,
                    textInputAction: TextInputAction.newline,
                    maxLines: 4,
                    minLines: 1,
                    textEditingController: controller.messageTextController,
                  ),
                ),
                Obx(() {
                  final meta = controller.chatMetaModel.value;
                  final other = getOtherUser(meta);
                  final isSending = controller.isLoadingSent.value;

                  return isSending
                      ? DefaultProgressIndicator()
                      : IconButton(
                        onPressed: () {
                          if (controller
                              .messageTextController
                              .text
                              .isNotEmpty) {
                            controller.sendMessage(
                              chatId: controller.activeChatId ?? '',
                              receiverId: other!.sId.toString(),
                            );
                          }
                        },
                        icon: Icon(
                          Icons.send,
                          color: AppColors.kBrightBlueColor,
                        ),
                      );
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
