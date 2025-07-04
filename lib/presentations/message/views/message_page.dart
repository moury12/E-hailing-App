import 'package:e_hailing_app/core/components/tab-bar/dynamic_tab_widget.dart';
import 'package:e_hailing_app/presentations/message/controllers/message_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/constants/padding_constant.dart';
import '../widgets/message_card_item_widget.dart';

class MessageListPage extends StatelessWidget {
  static const String routeName = '/message';

  const MessageListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: padding16H.copyWith(top: 0),
        child: Column(
          children: [
            DynamicTabWidget(
              tabs: MessageController.to.tabLabels,
              tabContent: [messageListItemWidget(), messageListItemWidget()],
            ),
          ],
        ),
      ),
    );
  }

  Padding messageListItemWidget() {
    return Padding(
      padding: padding12V.copyWith(top: 0),
      child: Column(
        spacing: 12.h,
        children: List.generate(
          4,
          (index) =>
              MessageCardItemWidget(isRead: index % 2 == 0 ? true : false),
        ),
      ),
    );
  }
}
