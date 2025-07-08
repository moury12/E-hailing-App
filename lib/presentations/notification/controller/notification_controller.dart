import 'package:e_hailing_app/core/api-client/api_endpoints.dart';
import 'package:e_hailing_app/core/api-client/api_service.dart';
import 'package:e_hailing_app/core/constants/hive_boxes.dart';
import 'package:e_hailing_app/core/helper/helper_function.dart';
import 'package:e_hailing_app/core/utils/variables.dart';
import 'package:e_hailing_app/presentations/notification/model/notification_model.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class NotificationController extends GetxController {
  static NotificationController get to => Get.find();
  final PagingController<int, NotificationModel> notificationPagingController =
      PagingController(firstPageKey: 1);
  final RxInt itemsPerPage = 10.obs;
  RxBool isLoadingDelete = false.obs;

  @override
  void onInit() {
    super.onInit();
    notificationPagingController.addPageRequestListener((pageKey) {
      getNotificationListRequest(pageKey: pageKey);
    });
  }

  ///------------------------------  get notification list method -------------------------///

  Future<void> getNotificationListRequest({required int pageKey}) async {
    try {
      ApiService().setAuthToken(Boxes.getUserData().get(tokenKey).toString());

      final response = await ApiService().request(
        endpoint: getAllNotificationEndpoint,
        method: 'GET',
        queryParams: {
          'page': pageKey.toString(),
          'limit': itemsPerPage.value.toString(),
        },
      );
      logger.d(response);
      if (response['success'] == true) {
        final newItems =
            (response['data']['notification'] as List)
                .map((e) => NotificationModel.fromJson(e))
                .toList();

        final isLastPage = newItems.length < itemsPerPage.value;
        if (isLastPage) {
          notificationPagingController.appendLastPage(newItems);
        } else {
          final nextPageKey = pageKey + 1;
          notificationPagingController.appendPage(newItems, nextPageKey);
        }
      } else {
        notificationPagingController.error =
            response['message'] ?? 'Something went wrong';
      }
    } catch (e) {
      notificationPagingController.error = e.toString();
    }
  }

  ///------------------------------  seen conversation method -------------------------///

  Future<void> updateNotificationReadRequest() async {
    try {
      ApiService().setAuthToken(Boxes.getUserData().get(tokenKey).toString());

      final response = await ApiService().request(
        endpoint: updateNotificationSeenEndpoint,
        method: 'PATCH',
        body: {"isRead": true},
      );

      if (response['success'] == true) {
        final currentItems = notificationPagingController.itemList;
        if (currentItems != null) {
          for (var item in currentItems) {
            item.isRead = true;
          }
          notificationPagingController.itemList = [...currentItems];
        }

        logger.d(response);
      } else {
        logger.e(response);
      }
    } catch (e) {
      logger.e(e.toString());
    }
  }

  ///------------------------------  delete notification method -------------------------///

  Future<void> deleteNotificationRequest({
    required String notificationId,
  }) async {
    try {
      isLoadingDelete.value = true;
      ApiService().setAuthToken(Boxes.getUserData().get(tokenKey).toString());

      final response = await ApiService().request(
        endpoint: deleteNotificationEndPoint,
        method: 'DELETE',
        body: {"notificationId": notificationId},
      );

      if (response['success'] == true) {
        logger.d(response);
        final currentItems = notificationPagingController.itemList;
        if (currentItems != null) {
          currentItems.removeWhere((element) => element.sId == notificationId);
          notificationPagingController.itemList = [...currentItems];
        }
        showCustomSnackbar(title: 'Success', message: response['message']);
      } else {
        logger.e(response);
        showCustomSnackbar(title: 'Failed', message: response['message']);
      }
    } catch (e) {
      logger.e(e.toString());
    } finally {
      isLoadingDelete.value = false;
    }
  }
}
