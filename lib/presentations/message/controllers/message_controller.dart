import 'package:e_hailing_app/core/api-client/api_endpoints.dart';
import 'package:e_hailing_app/core/api-client/api_service.dart';
import 'package:e_hailing_app/core/constants/hive_boxes.dart';
import 'package:e_hailing_app/core/helper/helper_function.dart';
import 'package:e_hailing_app/core/socket/socket_events_variable.dart';
import 'package:e_hailing_app/core/socket/socket_service.dart';
import 'package:e_hailing_app/core/utils/variables.dart';
import 'package:e_hailing_app/presentations/message/model/chat_message_model.dart';
import 'package:e_hailing_app/presentations/message/model/conversation_model.dart'
    as convo;
import 'package:e_hailing_app/presentations/message/model/conversation_model.dart';
import 'package:e_hailing_app/presentations/message/views/chatting_page.dart';
import 'package:e_hailing_app/presentations/splash/controllers/common_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../../../core/constants/app_static_strings_constant.dart';

class MessageController extends GetxController {
  RxBool isLoadingCreateConversation = false.obs;
  RxBool isLoadingCreateMessage = false.obs;
  RxBool isLoadingConversation = false.obs;
  RxBool isLoadingMessage = false.obs;
  TextEditingController messageTextController = TextEditingController();

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
  final PagingController<int, ConversationModel> pagingController =
      PagingController(firstPageKey: 1);
  final SocketService socket = SocketService();
  PagingController<int, Messages> messagePagingController = PagingController(
    firstPageKey: 1,
  );
  Rx<ChatModel?> chatMetaModel = Rx<ChatModel?>(null);

  @override
  void onInit() {
    super.onInit();
    pagingController.addPageRequestListener((pageKey) {
      getConversationListRequest(pageKey: pageKey);
    });
    initializeSocket();
  }

  void getMessages({required String chatId}) {
    // Dispose the old controller
    messagePagingController.dispose();

    // Create a new controller
    messagePagingController = PagingController<int, Messages>(firstPageKey: 1);

    // Add page listener
    messagePagingController.addPageRequestListener((pageKey) {
      fetchMessagesPage(chatId, pageKey);
    });

    // Navigate after setup
    Get.toNamed(ChattingPage.routeName, arguments: chatId);
  }

  void initializeSocket() {
    if (socket.isConnected) {
      socket.on(ChatEvent.sendMessage, (data) {
        logger.d("-------send message---------");
        logger.d(data);
        if (data["success"]) {
          // Convert the new message from JSON
          final newMessage = Messages.fromJson(data['data']);

          // Add message at the top (or bottom based on your order)
          final oldItems = messagePagingController.itemList ?? [];
          if (!oldItems.any((element) => element.sId == newMessage.sId)) {
            messagePagingController.itemList = [newMessage, ...oldItems];
          }
        }
      });
    } else {
      socketConnection();
    }
  }

  void socketConnection() {
    String userId = CommonController.to.userModel.value.sId ?? "";

    if (userId.isNotEmpty) {
      socket.connect(
        userId,
        CommonController.to.userModel.value.role == "DRIVER",
      );
    } else {
      logger.e('User ID is empty, cannot connect to socket');
    }
  }

  ///------------------------------  get conversation list method -------------------------///

  Future<void> getConversationListRequest({required int pageKey}) async {
    try {
      ApiService().setAuthToken(Boxes.getUserData().get(tokenKey).toString());

      final response = await ApiService().request(
        endpoint: getAlChatEndpoint,
        method: 'GET',
        queryParams: {'page': pageKey.toString()},
      );
      logger.d(response);
      if (response['success'] == true) {
        final newItems =
            (response['data']['chats'] as List)
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

  Future<void> fetchMessagesPage(String chatId, int pageKey) async {
    try {
      isLoadingMessage.value = true;

      final response = await ApiService().request(
        endpoint: getChatMessagesEndpoint,
        method: 'GET',
        queryParams: {'chatId': chatId, 'page': pageKey.toString()},
      );
      logger.d(response);
      if (response['success'] == true) {
        final data = response['data'];
        if (pageKey == 1) {
          chatMetaModel.value = ChatModel.fromJson(data);
        }
        final List<Messages> messages =
            (data['messages'] as List)
                .map((e) => Messages.fromJson(e))
                .toList();
        final totalPages = data['meta']['totalPage'] ?? 1;
        final isLastPage = pageKey >= totalPages;
        if (isLastPage) {
          messagePagingController.appendLastPage(messages);
        } else {
          final nextPageKey = pageKey + 1;
          messagePagingController.appendPage(messages, nextPageKey);
        }
      } else {
        messagePagingController.error = response['message'];
      }
    } catch (e) {
      messagePagingController.error = e;
    } finally {
      isLoadingMessage.value = false;
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

  ///------------------------------  seen conversation method -------------------------///

  Future<void> updateSeenRequest({required String chatId}) async {
    try {
      isLoadingCreateConversation.value = true;
      ApiService().setAuthToken(Boxes.getUserData().get(tokenKey).toString());

      final response = await ApiService().request(
        endpoint: updateMessageSeenEndpoint,
        method: 'PATCH',
        body: {"chatId": chatId},
      );

      if (response['success'] == true) {
        logger.d(response);

        // {
        //   showCustomSnackbar(title: 'Success', message: response['message']);
        // }
      } else {
        logger.e(response);
      }
    } catch (e) {
      isLoadingCreateConversation.value = false;
      logger.e(e.toString());
    }
  }

  Future<void> sendMessageSocket({required Map<String, dynamic> body}) async {
    if (!socket.isConnected) {
      showCustomSnackbar(
        title: 'Connection Error',
        message: 'Not connected to server. Please wait and try again.',
        type: SnackBarType.failed,
      );
      socketConnection();
      return;
    }

    socket.emit(ChatEvent.sendMessage, body);
    messageTextController.clear();
  }

  convo.Participants? getOtherUser(ConversationModel chatModel) {
    final myId = CommonController.to.userModel.value.sId;
    return chatModel.participants?.firstWhere(
      (p) => p.sId != myId,
      orElse: () => convo.Participants(name: 'Unknown', profileImage: null),
    );
  }

  @override
  void onClose() {
    messagePagingController.dispose();
    pagingController.dispose();
    super.onClose();
  }
}
