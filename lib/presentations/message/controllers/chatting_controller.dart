import 'package:e_hailing_app/core/api-client/api_endpoints.dart';
import 'package:e_hailing_app/core/api-client/api_service.dart';
import 'package:e_hailing_app/core/constants/hive_boxes.dart';
import 'package:e_hailing_app/core/helper/helper_function.dart';
import 'package:e_hailing_app/core/service/socket-service/socket_events_variable.dart';
import 'package:e_hailing_app/core/service/socket-service/socket_service.dart';
import 'package:e_hailing_app/core/utils/variables.dart';
import 'package:e_hailing_app/presentations/message/controllers/message_controller.dart';
import 'package:e_hailing_app/presentations/message/model/chat_message_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:e_hailing_app/core/service/translation-service/translation_service.dart';
import 'package:e_hailing_app/presentations/profile/controllers/account_information_controller.dart';

class ChattingController extends GetxController {
  static ChattingController get to => Get.find();
  final SocketService socket = SocketService();

  // Replace PagingController with RxList and pagination variables
  RxList<Messages> messagesList = <Messages>[].obs;
  RxInt currentPage = 1.obs;
  RxInt totalPages = 1.obs;
  RxBool isLoadingMessage = false.obs;
  RxBool isLoadingMore = false.obs;
  RxBool hasMoreData = true.obs;
  RxBool isLoadingSent = false.obs;
  Rx<ChatModel?> chatMetaModel = Rx<ChatModel?>(null);
  String? activeChatId;

  final TranslationService translationService = TranslationService();
  TextEditingController messageTextController = TextEditingController();
  ScrollController scrollController = ScrollController();

  @override
  void onInit() {
    initializeSocket();
    setupScrollListener();

    // Initial fetch if we have arguments
    final args = Get.arguments;
    if (args is String) {
      getMessages(chatId: args);
      updateMessageSeenRequest(chatId: args);
    }

    super.onInit();
  }

  void setupScrollListener() {
    scrollController.addListener(() {
      if (scrollController.hasClients &&
          !isLoadingMore.value &&
          hasMoreData.value) {
        final maxScroll = scrollController.position.maxScrollExtent;
        final currentScroll = scrollController.position.pixels;

        // In a reversed list, maxScroll is the TOP (oldest messages).
        // Trigger when user scrolls up and is near the top.
        if (maxScroll > 50 && currentScroll >= maxScroll * 0.8) {
          logger.d(
            "[Chat] Pagination triggered at $currentScroll / $maxScroll",
          );
          loadMoreMessages();
        }
      }
    });
  }

  ///------------------------------  seen conversation method -------------------------///

  Future<void> updateMessageSeenRequest({required String chatId}) async {
    try {
      ApiService().setAuthToken(Boxes.getUserData().get(tokenKey).toString());

      final response = await ApiService().request(
        endpoint: updateMessageSeenEndpoint,
        method: 'PATCH',
        body: {"chatId": chatId},
      );

      if (response['success'] == true) {
        final currentItems =
            MessageController.to.conversationPagingController.itemList;
        if (currentItems != null) {
          final index = currentItems.indexWhere(
            (element) => element.sId == chatId,
          );
          if (index != -1) {
            final updatedItem = currentItems[index];
            updatedItem.unRead = 0;
            MessageController.to.conversationPagingController.itemList = [
              ...currentItems,
            ];
          }
        }
        logger.d(response);
      } else {
        logger.e(response);
      }
    } catch (e) {
      logger.e(e.toString());
    }
  }

  Future<void> sendMessage({
    required String chatId,
    required String receiverId,
  }) async {
    final text = messageTextController.text;
    if (text.isEmpty) return;

    try {
      isLoadingSent.value = true;
      final textEn = await translationService.translate(text, 'en');
      final textMs = await translationService.translate(text, 'ms');

      socket.emit(ChatEvent.sendMessage, {
        "chatId": chatId,
        "receiverId": receiverId,
        "message": text,
        "english": textEn,
        "malay": textMs,
      });
    } catch (e) {
      logger.e("Failed to send message: $e");
      isLoadingSent.value = false;
    }
  }

  void initializeSocket() {
    // Clean up previous listeners to prevent duplicates
    socket.off(ChatEvent.sendMessage);

    socket.on(ChatEvent.sendMessage, (data) {
      isLoadingSent.value = false;
      logger.d("-------received socket message---------");
      logger.d(data);
      if (data["success"]) {
        final newMessage = Messages.fromJson(data['data']);
        messageTextController.clear();

        logger.d("new message: ${newMessage.message}");

        // Prevent duplicates by checking ID
        if (messagesList.any((element) => element.sId == newMessage.sId)) {
          logger.w("[Chat] Duplicate message ignored (ID: ${newMessage.sId})");
          return;
        }

        // Update the list and force UI refresh
        messagesList.insert(0, newMessage);
        messagesList.refresh();
        update(['chat_list']);

        logger.i(
          "[Chat] Added new message. List length: ${messagesList.length} | Hash: ${hashCode}",
        );
        logger.d("Latest: ${newMessage.message}");
      }
    });

    if (!socket.socket!.connected) {
      socketConnection();
    }
  }

  void socketConnection() {
    Map<String, dynamic> decodedToken = JwtDecoder.decode(
      Boxes.getUserData().get(tokenKey).toString(),
    );

    socket.connect(decodedToken['userId'], decodedToken['role'] == "DRIVER");
  }

  void getMessages({required String chatId}) {
    activeChatId = chatId;
    // Reset pagination state
    messagesList.clear();
    currentPage.value = 1;
    totalPages.value = 1;
    hasMoreData.value = true;

    // Reset scroll position to bottom (newest)
    if (scrollController.hasClients) {
      scrollController.jumpTo(0);
    }

    // Fetch first page
    fetchMessagesPage(chatId, 1);
  }

  void loadMoreMessages() {
    if (currentPage.value < totalPages.value && activeChatId != null) {
      fetchMessagesPage(activeChatId!, currentPage.value + 1);
    }
  }

  ///------------------------------ get message list method -------------------------///

  Future<void> fetchMessagesPage(String chatId, int pageKey) async {
    try {
      if (pageKey == 1) {
        isLoadingMessage.value = true;
      } else {
        isLoadingMore.value = true;
      }

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

        totalPages.value = data['meta']['totalPage'] ?? 1;
        currentPage.value = pageKey;

        // Add messages to the list
        messagesList.addAll(messages);

        // Check if there's more data
        hasMoreData.value = pageKey < totalPages.value;

        logger.i(
          "[Chat] Loaded page $pageKey. Total messages: ${messagesList.length}",
        );
      } else {
        logger.e(response['message']);
      }
    } catch (e) {
      logger.e("Error fetching messages: $e");
    } finally {
      isLoadingMessage.value = false;
      isLoadingMore.value = false;
    }
  }

  @override
  void onClose() {
    scrollController.dispose();
    messagesList.clear();
    socket.off(ChatEvent.sendMessage);
    super.onClose();
  }
}
