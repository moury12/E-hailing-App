import 'package:e_hailing_app/core/components/custom_button.dart';
import 'package:e_hailing_app/core/components/custom_refresh_indicator.dart';
import 'package:e_hailing_app/presentations/message/controllers/message_controller.dart';
import 'package:e_hailing_app/presentations/message/model/conversation_model.dart';
import 'package:e_hailing_app/presentations/save-location/widgets/empty_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../../../core/constants/padding_constant.dart';
import '../widgets/message_card_item_widget.dart';

class MessageListPage extends StatelessWidget {
  static const String routeName = '/message';

  const MessageListPage({super.key});

  @override
  Widget build(BuildContext context) {
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   if (Get.isRegistered<MessageController>()) {
    //     MessageController.to.conversationPagingController.refresh();
    //   }
    // });
    return CustomRefreshIndicator(
      onRefresh: () async {
        MessageController.to.conversationPagingController.refresh();
      },
      child: Padding(
        padding: padding12.copyWith(top: 0),
        child: PagedListView<int, ConversationModel>(
          pagingController: MessageController.to.conversationPagingController,
          builderDelegate: PagedChildBuilderDelegate<ConversationModel>(
            itemBuilder: (context, item, index) {
              return Padding(
                padding: EdgeInsets.only(bottom: 8),
                child: MessageCardItemWidget(
                  chatModel: item,
                  isRead: item.unRead!.toInt() <= 0,
                ),
              ); // your item widget
            },

            // Show when initially loading the first page
            firstPageProgressIndicatorBuilder:
                (_) => Column(
                  children: List.generate(5, (index) => MessageCardShimmer(),),
                ),

            // Show when loading next page
            newPageProgressIndicatorBuilder: (_) => DefaultProgressIndicator(),

            // Show if there's no data
            noItemsFoundIndicatorBuilder:
                (_) => Center(child: EmptyWidget(text: "No chats found.")),

            // Show if there’s an error
            firstPageErrorIndicatorBuilder:
                (_) => Center(
                  child: EmptyWidget(text: "Failed to load conversations."),
                ),

            newPageErrorIndicatorBuilder:
                (_) => Center(
                  child: EmptyWidget(
                    text: "Failed to load more. Pull to retry.",
                  ),
                ),
          ),
        ),
      ),
    );
  }
}
