import 'package:e_hailing_app/core/components/custom_button.dart';
import 'package:e_hailing_app/core/components/tab-bar/dynamic_tab_widget.dart';
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
    return Padding(
      padding: padding16H.copyWith(top: 0),
      child: Column(
        children: [
          DynamicTabWidget(
            tabs: MessageController.to.tabLabels,
            tabContent: [messageListItemWidget(), messageListItemWidget()],
          ),
        ],
      ),
    );
  }

  Padding messageListItemWidget() {
    return Padding(
      padding: padding12V.copyWith(top: 0),
      child: PagedListView<int, ConversationModel>(
        pagingController: MessageController.to.pagingController,
        builderDelegate: PagedChildBuilderDelegate<ConversationModel>(
          itemBuilder: (context, item, index) {
            return MessageCardItemWidget(/*item: item*/); // your item widget
          },

          // Show when initially loading the first page
          firstPageProgressIndicatorBuilder: (_) => DefaultProgressIndicator(),

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
                child: EmptyWidget(text: "Failed to load more. Pull to retry."),
              ),
        ),
      ),
    );
  }
}
