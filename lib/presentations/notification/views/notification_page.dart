import 'package:e_hailing_app/core/components/custom_appbar.dart';
import 'package:e_hailing_app/core/components/custom_button.dart';
import 'package:e_hailing_app/core/components/custom_refresh_indicator.dart';
import 'package:e_hailing_app/core/constants/app_static_strings_constant.dart';
import 'package:e_hailing_app/presentations/notification/controller/notification_controller.dart';
import 'package:e_hailing_app/presentations/notification/model/notification_model.dart';
import 'package:e_hailing_app/presentations/save-location/widgets/empty_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../widgets/notification_card_item_widget.dart';

class NotificationPage extends StatefulWidget {
  static const String routeName = '/notification';

  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      NotificationController.to.updateNotificationReadRequest();
    });
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: AppStaticStrings.notification.tr),
      body: CustomRefreshIndicator(
        onRefresh: () async {
          NotificationController.to.notificationPagingController.refresh();
        },
        child: PagedListView<int, NotificationModel>(
          pagingController:
              NotificationController.to.notificationPagingController,
          builderDelegate: PagedChildBuilderDelegate(
            itemBuilder:
                (context, item, index) => NotificationCardItemWidget(
                  index: index,
                  notificationModel: item,
                ),
            firstPageProgressIndicatorBuilder:
                (_) => DefaultProgressIndicator(),

            // Show when loading next page
            newPageProgressIndicatorBuilder: (_) => DefaultProgressIndicator(),

            // Show if there's no data
            noItemsFoundIndicatorBuilder:
                (_) => Center(child: EmptyWidget(text: "No chats found.")),

            // Show if there’s an error
            firstPageErrorIndicatorBuilder:
                (_) => Center(
                  child: EmptyWidget(text: "Failed to load Notifications."),
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
