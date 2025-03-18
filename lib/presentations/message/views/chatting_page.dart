import 'package:e_hailing_app/core/components/custom_appbar.dart';
import 'package:e_hailing_app/core/components/custom_textfield.dart';
import 'package:e_hailing_app/core/constants/color_constants.dart';
import 'package:e_hailing_app/core/constants/image_constant.dart';
import 'package:e_hailing_app/core/constants/padding_constant.dart';
import 'package:e_hailing_app/presentations/message/controllers/message_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../widgets/chat_message_card_item_widget.dart';

class ChattingPage extends StatelessWidget {
  static const String routeName = '/chatting';
  const ChattingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Alex Wheeler',
        action: [
          Padding(
            padding: EdgeInsets.only(right: 12.w),
            child: PrimaryCircleButtonWidget(actionIcon: callIcon),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              itemCount: MessageController.to.messages.length,
              itemBuilder: (context, index) {
                final message = MessageController.to.messages[index];
                final isDriverMessage = message.isFromDriver;
                return ChatMessageCardItemWidget(
                  isDriverMessage: isDriverMessage,
                  message: message,
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
                  ),
                ),
                IconButton(
                  onPressed: () {},
                  icon: Icon(Icons.send, color: AppColors.kBrightBlueColor),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
