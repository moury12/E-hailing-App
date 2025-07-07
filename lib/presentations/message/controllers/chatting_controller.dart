import 'package:e_hailing_app/core/api-client/api_endpoints.dart';
import 'package:e_hailing_app/core/api-client/api_service.dart';
import 'package:e_hailing_app/core/constants/hive_boxes.dart';
import 'package:e_hailing_app/core/helper/helper_function.dart';
import 'package:e_hailing_app/core/socket/socket_events_variable.dart';
import 'package:e_hailing_app/core/socket/socket_service.dart';
import 'package:e_hailing_app/core/utils/variables.dart';
import 'package:e_hailing_app/presentations/message/model/chat_message_model.dart';
import 'package:e_hailing_app/presentations/splash/controllers/common_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class ChattingController extends GetxController {
  static ChattingController get to => Get.find();
  final SocketService socket = SocketService();
  PagingController<int, Messages> messagePagingController = PagingController(
    firstPageKey: 1,
  );
  RxBool isLoadingMessage = false.obs;
  Rx<ChatModel?> chatMetaModel = Rx<ChatModel?>(null);

  TextEditingController messageTextController = TextEditingController();

  @override
  void onInit() {
    initializeSocket();
    super.onInit();
  }

  ///------------------------------  seen conversation method -------------------------///

  Future<void> updateSeenRequest({required String chatId}) async {
    try {
      ApiService().setAuthToken(Boxes.getUserData().get(tokenKey).toString());

      final response = await ApiService().request(
        endpoint: updateMessageSeenEndpoint,
        method: 'PATCH',
        body: {"chatId": chatId},
      );

      if (response['success'] == true) {
        logger.d(response);
      } else {
        logger.e(response);
      }
    } catch (e) {
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
    super.onClose();
  }
}
