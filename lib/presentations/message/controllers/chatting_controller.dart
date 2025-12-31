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
  PagingController<int, Messages> messagePagingController = PagingController(
    firstPageKey: 1,
  );
  RxBool isLoadingMessage = false.obs;
  RxBool isLoadingSent = false.obs;
  Rx<ChatModel?> chatMetaModel = Rx<ChatModel?>(null);

  final TranslationService translationService = TranslationService();
  TextEditingController messageTextController = TextEditingController();

  @override
  void onInit() {
    initializeSocket();
    super.onInit();
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

    // Optimistic Update
    // final tempId = 'temp_${DateTime.now().millisecondsSinceEpoch}';
    // final myId = AccountInformationController.to.userModel.value.sId;

    // final tempMessage = Messages(
    //   sId: tempId,
    //   sender: myId,
    //   receiver: receiverId,
    //   message: text,
    //   createdAt: DateTime.now().toIso8601String(),
    // );

    // final currentItems = messagePagingController.itemList ?? [];
    // messagePagingController.itemList = [tempMessage, ...currentItems];
    // messageTextController.clear();

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
      // Optionally handle failure UI here (e.g. show retry on the temp message)
    }
  }

  void initializeSocket() {
    if (socket.socket!.connected) {
      // Clean up previous listeners to prevent duplicates
      socket.off(ChatEvent.sendMessage);

      socket.on(ChatEvent.sendMessage, (data) {
        isLoadingSent.value = false;
        logger.d("-------send message---------");
        logger.d(data);
        if (data["success"]) {
          final newMessage = Messages.fromJson(data['data']);
          messageTextController.clear();

          final currentItems = messagePagingController.itemList ?? [];

          logger.d(
            "[Chat] Controller Hash: ${hashCode}, PagingController Hash: ${messagePagingController.hashCode}",
          );

          // Prevent duplicates by checking ID
          if (currentItems.any((element) => element.sId == newMessage.sId)) {
            logger.w(
              "[Chat] Duplicate message ignored (ID: ${newMessage.sId})",
            );
            return;
          }

          // Directly add the new message to the top of the list
          final newItems = [newMessage, ...currentItems];
          messagePagingController.itemList = newItems;

          // Force UI rebuild if needed (though itemList setter should do it)
          // messagePagingController.notifyListeners(); // Protected method
          logger.i(
            "[Chat] Added new message. New list length: ${newItems.length}",
          );
        }
      });
    } else {
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
    // Dispose the old controller
    messagePagingController.dispose();

    // Create a new controller
    messagePagingController = PagingController<int, Messages>(firstPageKey: 1);

    // Add page listener
    messagePagingController.addPageRequestListener((pageKey) {
      fetchMessagesPage(chatId, pageKey);
    });

    // Navigate after setup
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

  @override
  void onClose() {
    messagePagingController.dispose();
    socket.off(ChatEvent.sendMessage);
    super.onClose();
  }
}
