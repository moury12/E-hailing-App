import 'package:e_hailing_app/core/api-client/api_endpoints.dart';
import 'package:e_hailing_app/core/api-client/api_service.dart';
import 'package:e_hailing_app/core/constants/hive_boxes.dart';
import 'package:e_hailing_app/core/helper/helper_function.dart';
import 'package:e_hailing_app/core/utils/variables.dart';
import 'package:e_hailing_app/presentations/message/model/conversation_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../../../core/constants/app_static_strings_constant.dart';
import '../model/chat_message_model.dart';

class MessageController extends GetxController {
  final messages = <ChatMessage>[].obs;
  RxBool isLoadingCreateConversation = false.obs;
  RxBool isLoadingCreateMessage = false.obs;
  RxBool isLoadingConversation = false.obs;
  RxBool isLoadingMessage = false.obs;

  ///====================conversation pagination variable========================///

  final RxInt currentPage = 1.obs;
  final RxInt itemsPerPage = 10.obs;
  final RxInt totalCategoryPages = 5.obs;
  final RxBool isLoadingMore = false.obs;

  ///===============================message pagination variable======================///
  RxInt messageCurrentPage = 1.obs;
  RxInt totalMessagePages = 1.obs;
  RxInt messageItemsPerPage = 10.obs;
  RxBool isLoadingMoreMessages = false.obs;

  static MessageController get to => Get.find();
  RxList<String> tabLabels =
      [AppStaticStrings.allMessages, AppStaticStrings.newMessages].obs;
  var tabContent = <Widget>[].obs;
  final PagingController<int, ConversationModel> pagingController =
      PagingController(firstPageKey: 1);

  @override
  void onInit() {
    super.onInit();
    // Add static message examples
    messages.addAll([
      ChatMessage(
        content: "Hello! I'm available to pick you up. I'll be there in about",
        time: "02:15 PM",
        isFromDriver: true,
      ),
      ChatMessage(
        content: "Thankyou Sir" * 10,
        time: "02:20 PM",
        isFromDriver: false,
      ),
      ChatMessage(
        content:
            "I've arrived at Location. Look for a Red Car with the license plate XXXX.",
        time: "02:35 PM",
        isFromDriver: true,
      ),
      ChatMessage(
        content: "Great! I'll be there in a minute.",
        time: "02:36 PM",
        isFromDriver: false,
      ),
    ]);
  }

  ///------------------------------  get conversation list method -------------------------///

  Future<void> getConversationListRequest({required int pageKey}) async {
    try {
      ApiService().setAuthToken(Boxes.getUserData().get(tokenKey).toString());

      final response = await ApiService().request(
        endpoint: getAlChatEndpoint,
        method: 'GET',
        queryParams: {
          'page': pageKey.toString(),
          'limit': itemsPerPage.value.toString(),
          'sort': 'updatedAt',
          'order': 'desc',
        },
      );

      if (response['success'] == true) {
        final newItems =
            (response['data'] as List)
                .map((e) => ConversationModel.fromJson(e))
                .toList();

        final isLastPage = newItems.length < itemsPerPage.value;
        if (isLastPage) {
          pagingController.appendLastPage(newItems);
        } else {
          final nextPageKey = pageKey + 1;
          pagingController.appendPage(newItems, nextPageKey);
        }
      } else {
        pagingController.error = response['message'] ?? 'Something went wrong';
      }
    } catch (e) {
      pagingController.error = e.toString();
    }
  }

  ///------------------------------ get message list method -------------------------///

  Future<void> getMessageListRequest({
    required String conversationId,
    bool loadMore = false,
  }) async {
    try {
      if (loadMore && messageCurrentPage.value >= totalMessagePages.value) {
        return;
      }

      if (loadMore) {
        messageCurrentPage.value++;
        isLoadingMoreMessages.value = true;
      } else {
        messageCurrentPage.value = 1;
        isLoadingMessage.value = true;
      }

      ApiService().setAuthToken(Boxes.getUserData().get(tokenKey).toString());

      final response = await ApiService().request(
        endpoint: getChatMessagesEndpoint,
        queryParams: {
          "conversation_id": conversationId,
          "page": messageCurrentPage.value.toString(),
          "limit": messageItemsPerPage.value.toString(),
          "sort": "createdAt",
          "order": "desc", // or "asc" depending on your display order
        },
        method: 'GET',
      );

      isLoadingMessage.value = false;
      isLoadingMoreMessages.value = false;

      if (response['success'] == true) {
        logger.d(response);

        if (response['pagination'] != null) {
          messageCurrentPage.value = response['pagination']['currentPage'] ?? 1;
          totalMessagePages.value = response['pagination']['totalPages'] ?? 1;
          messageItemsPerPage.value =
              response['pagination']['itemsPerPage'] ?? 20;
        }

        // final newMessages =
        //     (response['data'] as List)
        //         .map((e) => MessageModel.fromJson(e))
        //         .toList();
        // final imageUrls =
        //     newMessages
        //         .map((cat) => "${ApiService().baseUrl}/${cat.img}")
        //         .where((url) => url.isNotEmpty)
        //         .toList();
        // preloadImagesFromUrls(imageUrls);
        // if (loadMore) {
        //   messageList.addAll(newMessages); // append
        // } else {
        //   messageList.value = newMessages; // reset
        // }
      } else {
        logger.e(response);
        if (kDebugMode) {
          showCustomSnackbar(
            title: 'Failed',
            message: response['message'],
            type: SnackBarType.failed,
          );
        }
      }
    } catch (e) {
      logger.e(e.toString());
      isLoadingMessage.value = false;
      isLoadingMoreMessages.value = false;
    }
  }

  ///------------------------------  create conversation method -------------------------///

  Future<void> createConversationRequest({required String userId}) async {
    try {
      isLoadingCreateConversation.value = true;
      ApiService().setAuthToken(Boxes.getUserData().get(tokenKey).toString());

      final response = await ApiService().request(
        endpoint: postChatEndpoint,
        method: 'POST',
        body: {"receiverId": userId},
      );

      if (response['success'] == true) {
        logger.d(response);

        showCustomSnackbar(title: 'Success', message: response['message']);
        // await getConversationListRequest();
        // NavigationController.to.selectedNavIndex.value = 3;
        // isLoadingCreateConversation.value = false;
        // Get.toNamed(NavigationPage.routeName);
      } else {
        logger.e(response);

        // NavigationController.to.selectedNavIndex.value = 3;
        // Get.toNamed(NavigationPage.routeName);
      }
    } catch (e) {
      isLoadingCreateConversation.value = false;
      logger.e(e.toString());
    }
  }
}
