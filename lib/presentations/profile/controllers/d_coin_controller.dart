import 'package:e_hailing_app/core/api-client/api_endpoints.dart';
import 'package:e_hailing_app/core/api-client/api_service.dart';
import 'package:e_hailing_app/core/constants/hive_boxes.dart';
import 'package:e_hailing_app/core/utils/variables.dart';
import 'package:e_hailing_app/presentations/profile/model/d_coin_model.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class DCoinController extends GetxController {
  static DCoinController get to => Get.find();
  final PagingController<int, DcoinModel> dCoinsPagingController =
      PagingController(firstPageKey: 1);

  @override
  void onInit() {
    super.onInit();
    dCoinsPagingController.addPageRequestListener((pageKey) {
      getDCoinListRequest(pageKey: pageKey);
    });
  }

  ///------------------------------  get D coin list method -------------------------///

  Future<void> getDCoinListRequest({required int pageKey}) async {
    try {
      ApiService().setAuthToken(Boxes.getUserData().get(tokenKey).toString());

      final response = await ApiService().request(
        endpoint: getAlDCoinEndpoint,
        method: 'GET',
        queryParams: {'page': pageKey.toString(), 'limit': "10"},
      );
      logger.d(response);
      if (response['success'] == true) {
        final newItems =
            (response['data']['dCoins'] as List)
                .map((e) => DcoinModel.fromJson(e))
                .toList();

        final isLastPage = newItems.length < 10;
        if (isLastPage) {
          dCoinsPagingController.appendLastPage(newItems);
        } else {
          final nextPageKey = pageKey + 1;
          dCoinsPagingController.appendPage(newItems, nextPageKey);
        }
      } else {
        dCoinsPagingController.error =
            response['message'] ?? 'Something went wrong';
      }
    } catch (e) {
      dCoinsPagingController.error = e.toString();
    }
  }
}
