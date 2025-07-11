import 'package:e_hailing_app/core/api-client/api_endpoints.dart';
import 'package:e_hailing_app/core/api-client/api_service.dart';
import 'package:e_hailing_app/core/constants/hive_boxes.dart';
import 'package:e_hailing_app/core/utils/variables.dart';
import 'package:e_hailing_app/presentations/message/model/conversation_model.dart'
    as convo;
import 'package:e_hailing_app/presentations/message/model/conversation_model.dart';
import 'package:e_hailing_app/presentations/message/views/chatting_page.dart';
import 'package:e_hailing_app/presentations/splash/controllers/common_controller.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class MessageController extends GetxController {
  RxBool isLoadingCreateConversation = false.obs;
  RxBool isLoadingCreateMessage = false.obs;
  RxBool isLoadingConversation = false.obs;

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

  final PagingController<int, ConversationModel> conversationPagingController =
      PagingController(firstPageKey: 1);

  @override
  void onInit() {
    super.onInit();
    conversationPagingController.addPageRequestListener((pageKey) {
      getConversationListRequest(pageKey: pageKey);
    });
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
          conversationPagingController.appendLastPage(newItems);
        } else {
          final nextPageKey = pageKey + 1;
          conversationPagingController.appendPage(newItems, nextPageKey);
        }
      } else {
        conversationPagingController.error =
            response['message'] ?? 'Something went wrong';
      }
    } catch (e) {
      conversationPagingController.error = e.toString();
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
        // fetchMessagesPage()
        Get.toNamed(ChattingPage.routeName, arguments: response['data']['_id']);
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

  convo.Participants? getOtherUser(ConversationModel chatModel) {
    final myId = CommonController.to.userModel.value.sId;
    return chatModel.participants?.firstWhere(
      (p) => p.sId != myId,
      orElse: () => convo.Participants(name: 'Unknown', profileImage: null),
    );
  }

  @override
  void onClose() {
    conversationPagingController.dispose();
    super.onClose();
  }
}
