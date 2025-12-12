import 'package:e_hailing_app/core/api-client/api_endpoints.dart';
import 'package:e_hailing_app/core/api-client/api_service.dart';
import 'package:e_hailing_app/core/constants/hive_boxes.dart';
import 'package:e_hailing_app/presentations/driver-statics/model/StaticModel.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

import '../../../core/constants/app_static_strings_constant.dart';
import '../../../core/constants/image_constant.dart';
import '../../../core/utils/variables.dart';

class StaticsController extends GetxController{
  static StaticsController get to => Get.find();
  var staticList = <StaticModel>[].obs;
  RxMap<String, List<StaticModel>> staticsCache= <String, List<StaticModel>>{}.obs;
  void initStaticList() {
    staticList.value = [
      StaticModel(img: totalEarnIcon, title: AppStaticStrings.totalEarn.tr, val: 'RM 0'),
      StaticModel(img: handCash1Icon, title: AppStaticStrings.handCash.tr, val: 'RM 0'),
      StaticModel(img: coinIcon, title: AppStaticStrings.dCoin.tr, val: 'RM 0'),
      StaticModel(img: onlineCashIcon, title: AppStaticStrings.onlineCash.tr, val: 'RM 0'),
      StaticModel(img: tripTodayIcon, title: AppStaticStrings.tripToday.tr, val: '0'),
      StaticModel(img: activeHourIcon, title: AppStaticStrings.activeHour.tr, val: '0h'),
      StaticModel(img: distanceTodayIcon, title: AppStaticStrings.tripDistanceToday.tr, val: '0 km'),
    ];
  }
  RxBool isLoadingStatics = false.obs;
  Rx<StaticsValueModel> staticsVal = StaticsValueModel().obs;

  @override
  void onInit() {
    initStaticList();

    getDriverStaticsRequest(filter: today);

    super.onInit();
  }
 List<String> get tabLabels  {return
   [
     AppStaticStrings.today.tr,
     AppStaticStrings.thisWeek.tr,
     AppStaticStrings.thisMonth.tr,
   ].obs;
}
  Future<void> getDriverStaticsRequest({required String filter}) async {
    try {
      if(staticsCache.containsKey(filter)){
        staticList.value=staticsCache[filter]??[];
        return;
      }
      isLoadingStatics.value = true;
      ApiService().setAuthToken(Boxes.getUserData().get(tokenKey).toString());

      final response = await ApiService().request(
          endpoint: staticsEndpoint,
          method: 'GET',
          queryParams: {"filter":filter}
      );
      if (response['success'] == true) {
        logger.d(response);
        staticsVal.value = StaticsValueModel.fromJson(response['data']);

      final list   = [
          StaticModel(img: totalEarnIcon, title: AppStaticStrings.totalEarn.tr, val: 'RM ${staticsVal.value.totalEarn ?? 0}'),
          StaticModel(img: handCash1Icon, title: AppStaticStrings.handCash.tr, val: 'RM ${staticsVal.value.cash ?? 0}'),
          StaticModel(img: coinIcon, title: AppStaticStrings.dCoin.tr, val: '${staticsVal.value.coin ?? 0}'),
          StaticModel(img: onlineCashIcon, title: AppStaticStrings.onlineCash.tr, val: 'RM ${(staticsVal.value.totalEarn ?? 0) - (staticsVal.value.cash ?? 0)}'),
          StaticModel(img: tripTodayIcon, title: AppStaticStrings.tripToday.tr, val: '${staticsVal.value.numberOfTrips ?? 0}'),
          StaticModel(img: activeHourIcon, title: AppStaticStrings.activeHour.tr, val: '${(staticsVal.value.activeHours ?? 0).toStringAsFixed(1)} h'),
          StaticModel(img: distanceTodayIcon, title: AppStaticStrings.tripDistanceToday.tr, val: '${staticsVal.value.tripDistance ?? 0} km'),
        ];
        staticsCache[filter] = list;
        staticList.value = list;
      } else {
        logger.e(response);
        if (kDebugMode) {
          // showCustomSnackbar(
          //   title: 'Failed',
          //   message: response['message'],
          //   type: SnackBarType.failed,
          // );
        }
      }
    } catch (e) {
      logger.e(e.toString());
      isLoadingStatics.value = false;
    }finally{
      isLoadingStatics.value = false;

    }
  }

}