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
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class ChattingPage extends StatefulWidget {
  static const String routeName = '/chatting';

  const ChattingPage({super.key});

  @override
  State<ChattingPage> createState() => _ChattingPageState();
}

class _ChattingPageState extends State<ChattingPage> {
  final chatId = Get.arguments;

  Participants? getOtherUser(ChatModel? meta) {
    final myId = AccountInformationController.to.userModel.value.sId;

    if (meta == null || meta.participants == null) return null;

    return meta.participants!.firstWhere(
      (p) => p.sId != myId,
      orElse: () => Participants(name: 'Unknown', profileImage: null),
    );
  }

  @override
  void initState() {
    ChattingController.to.getMessages(chatId: chatId);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      ChattingController.to.updateMessageSeenRequest(chatId: chatId);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: Obx(() {
          final other =
              ChattingController.to.chatMetaModel.value != null
                  ? getOtherUser(ChattingController.to.chatMetaModel.value)
                  : Participants();
          return CustomAppBar(
            title: other?.name ?? "User Name Loading...",
            action: [
              /*ChattingController.to.isLoadingMessage.value
                  ? DefaultProgressIndicator()
                  : */
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
            child: PagedListView<int, Messages>(
              reverse: true,
              pagingController: ChattingController.to.messagePagingController,
              builderDelegate: PagedChildBuilderDelegate<Messages>(
                itemBuilder:
                    (context, item, index) => ChatMessageCardItemWidget(
                      sendByMe:
                          AccountInformationController.to.userModel.value.sId ==
                          item.sender,
                      message: item,
                      chatModel:
                          ChattingController.to.chatMetaModel.value ??
                          ChatModel(),
                    ),
                newPageProgressIndicatorBuilder:
                    (context) => DefaultProgressIndicator(),
                firstPageProgressIndicatorBuilder: (_) => ShimmerChatList(),
                noItemsFoundIndicatorBuilder:
                    (_) => EmptyWidget(text: "No messages."),
              ),
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
                    textEditingController:
                        ChattingController.to.messageTextController,
                  ),
                ),
                Obx(() {
                  final other = getOtherUser(
                    ChattingController.to.chatMetaModel.value,
                  );

                  return ChattingController.to.isLoadingMessage.value
                      ? DefaultProgressIndicator()
                      : IconButton(
                        onPressed: () {
                          if (ChattingController
                              .to
                              .messageTextController
                              .text
                              .isNotEmpty) {
                            ChattingController.to.sendMessageSocket(
                              body: {
                                "chatId": chatId,
                                "receiverId": other!.sId.toString(),
                                "message":
                                    ChattingController
                                        .to
                                        .messageTextController
                                        .text,
                              },
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
