import 'dart:convert';
import 'package:e_hailing_app/core/constants/hive_boxes.dart';
import 'package:e_hailing_app/core/utils/variables.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../core/utils/google_map_api_key.dart';
import 'package:e_hailing_app/presentations/profile/model/user_profile_model.dart';
import 'package:e_hailing_app/presentations/splash/controllers/common_controller.dart';
import 'package:flutter/foundation.dart';
import 'package:e_hailing_app/core/api-client/api_endpoints.dart';
import 'package:e_hailing_app/core/api-client/api_service.dart';import 'package:e_hailing_app/core/helper/helper_function.dart';

class CommonController extends GetxController {
  static CommonController get to => Get.find();
  RxBool isLoadingProfile = false.obs;
  Rx<UserProfileModel> userModel = UserProfileModel().obs;
  var selectedRoleOption = Boxes.getUserData().get(roleKey) != null
      ? Boxes.getUserData().get(roleKey) == 'USER'
      ? 0.obs
      : 1.obs
      : 0.obs;
  RxBool isDriver =
      (Boxes.getUserRole().get(role, defaultValue: user).toString() == driver)
          .obs;
  RxBool isLoadingOnLocationSuggestion = false.obs;
  RxList<dynamic> addressSuggestion = [].obs;
  @override
  void onInit() {
    debugPrint(Boxes.getUserRole().get(role, defaultValue: user).toString());
    requestLocationPermission();
    super.onInit();
  }

  Future<void> requestLocationPermission() async {
    var status = await Permission.location.request();
    if (status.isGranted) {
      debugPrint("Location permission granted.");
    } else {
      debugPrint("Location permission denied.");
    }
  }

  Future<void> fetchSuggestedPlaces(String input) async {
    isLoadingOnLocationSuggestion.value = true;
    final url =
        'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=${Uri.encodeComponent(input)}&key=${GoogleClient.googleMapUrl}';
    final response = await http.get(Uri.parse(url));
    debugPrint(url);
    debugPrint(response.body);

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      addressSuggestion.value = data['predictions'];
      isLoadingOnLocationSuggestion.value = false;
    } else {
      isLoadingOnLocationSuggestion.value = false;
    }
  }
  Future<void> checkUserRole()async{
    logger.d("token - ${Boxes.getUserData().get(tokenKey)}");
    if (Boxes.getUserData().get(tokenKey) != null &&
        Boxes.getUserData().get(tokenKey).toString().isNotEmpty)  {
      await getUserProfileRequest();
      Boxes.getUserRole().put(role, userModel.value.role!.toLowerCase());
isDriver.value =
          userModel.value.role!.toLowerCase() == driver;
    }
  }
  ///------------------------------ get User profile method -------------------------///

  Future<void> getUserProfileRequest() async {
    try {
      isLoadingProfile.value = true;
      ApiService().setAuthToken(Boxes.getUserData().get(tokenKey).toString());

      final response = await ApiService().request(
        endpoint: getProfileEndPoint,
        method: 'GET',
      );
      isLoadingProfile.value = false;
      if (response['success'] == true) {
        logger.d(response);
        userModel.value = UserProfileModel.fromJson(response['data']);

        // if (userModel.value.i != null && userModel.value.i!.isNotEmpty) {
        //    preloadImagesFromUrls([userModel.value.img.toString()]);
        // }

      } else {
        logger.e(response);
        if(kDebugMode){
          showCustomSnackbar(
            title: 'Failed',
            message: response['message'],
            type: SnackBarType.failed,
          );
        }
      }
    } catch (e) {
      logger.e(e.toString());
      isLoadingProfile.value = false;
    }
  }
  Future<void> getLatLngFromPlace(
    String placeId, {
    required RxString lat,
    required RxString lng,
    required RxString selectedAddress,
  }) async {
    final String url =
        'https://maps.googleapis.com/maps/api/geocode/json?place_id=$placeId&key=${GoogleClient.googleMapUrl}';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        // Parse response
        final Map<String, dynamic> data = json.decode(response.body);

        if (data['results'].isNotEmpty) {
          final location = data['results'][0]['geometry']['location'];

          // Update RxString values
          selectedAddress.value = data['results'][0]['formatted_address'];
          lat.value = location['lat'].toString();
          lng.value = location['lng'].toString();
          debugPrint(lat.value);
          debugPrint(lng.value);
        } else {
          debugPrint("No results found for the provided placeId.");
        }
      } else {
        debugPrint(
          "HTTP Error: ${response.statusCode} - ${response.reasonPhrase}",
        );
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}
