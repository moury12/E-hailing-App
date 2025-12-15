import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:e_hailing_app/core/api-client/api_service.dart';
import 'package:e_hailing_app/core/constants/app_static_strings_constant.dart';
import 'package:e_hailing_app/core/constants/hive_boxes.dart';
import 'package:e_hailing_app/core/helper/helper_function.dart';
import 'package:e_hailing_app/core/service/location-service/location_service.dart';
import 'package:e_hailing_app/core/service/socket-service/socket_events_variable.dart';
import 'package:e_hailing_app/core/service/socket-service/socket_service.dart';
import 'package:e_hailing_app/core/utils/enum.dart';
import 'package:e_hailing_app/core/utils/variables.dart';
import 'package:e_hailing_app/presentations/payment/views/online_payment.dart';
import 'package:e_hailing_app/presentations/profile/controllers/account_information_controller.dart';
import 'package:e_hailing_app/presentations/profile/model/review_model.dart';
import 'package:e_hailing_app/presentations/splash/controllers/boundary_controller.dart';
import 'package:e_hailing_app/presentations/splash/model/announcment_model.dart';
import 'package:e_hailing_app/presentations/trip/model/trip_cancellation_model.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../../core/api-client/api_endpoints.dart';
import '../../../core/utils/google_map_api_key.dart';

class CommonController extends GetxController {
  static CommonController get to => Get.find();
RxList<String> images =<String>[].obs;
  RxBool isPaid =false.obs;

  final locationService = LocationTrackingService();
  Rx<LatLng> markerPositionDriver = Rx<LatLng>(LatLng(0.0, 0.0));
  Rx<LatLng> markerPositionRider = Rx<LatLng>(LatLng(0.0, 0.0));
  GoogleMapController? mapControllerDriver;
  GoogleMapController? mapControllerRider;
  RxList<ReviewModel> reviewList = <ReviewModel>[].obs;
  Rx<AnnouncementModel> announcement = AnnouncementModel().obs;
  List<TripCancellationModel> get tripCancellationList =>
      CommonController.to.isDriver.value ? [
        TripCancellationModel(
          title: AppStaticStrings.riderNoShow.tr,
          isChecked: false.obs,
        ),
        TripCancellationModel(
          title: AppStaticStrings.wrongPickupLocation.tr,
          isChecked: false.obs,
        ),
        TripCancellationModel(
          title: AppStaticStrings.safetyConcerns.tr,
          isChecked: false.obs,
        ),
        TripCancellationModel(
          title: AppStaticStrings.vehicleIssue.tr,
          isChecked: false.obs,
        ),
        TripCancellationModel(
          title: AppStaticStrings.tripRequestError.tr,
          isChecked: false.obs,
        ),
      ] : [
        TripCancellationModel(
          title: AppStaticStrings.waitingTimeIsLong.tr,
          isChecked: false.obs,
        ),
        TripCancellationModel(
          title: AppStaticStrings.changeOfTravelPlan.tr,
          isChecked: false.obs,
        ),
        TripCancellationModel(
          title: AppStaticStrings.tripReqError.tr,
          isChecked: false.obs,
        ),
      ];

  RxBool isDriver = false.obs;
  RxBool isVerifingIdentity = false.obs;
  RxBool isLoadingPayment = false.obs;
  RxBool isLoadingReview = false.obs;
  RxBool isLoadingAnnouncement = false.obs;
  RxDouble driverRating = 0.0.obs;
  RxBool isLoadingOnLocationSuggestion = false.obs;
  RxList<dynamic> addressSuggestion = [].obs;
  void setMapControllerRider(GoogleMapController controller) {
    mapControllerRider = controller;
    startTrackingLocationMethod();
  }

  RxString stripeUrl = ''.obs;

  void setMapControllerDriver(GoogleMapController controller) {
    mapControllerDriver = controller;
    startTrackingLocationMethod();
  }

  Future<void> getReviewListRequest({required String driverId}) async {
    isLoadingReview.value = true;

    try {
      ApiService().setAuthToken(Boxes.getUserData().get(tokenKey).toString());
      final response = await ApiService().request(
        endpoint: getAllReviewEndpoint,
        method: 'GET',
        useAuth: true,
        queryParams: {'driverId': driverId},
      );
      // logger.d(response);
      if (response['success'] == true) {
        driverRating.value = double.parse(
          response['data']['averageRating'].toString(),
        );
        reviewList.value =
            (response['data']['reviews'] as List)
                .map((e) => ReviewModel.fromJson(e))
                .toList();
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
    } finally {
      isLoadingReview.value = false;
    }
  }
  Future<void> getAnnouncmentRequest() async {
    isLoadingAnnouncement.value = true;

    try {
      ApiService().setAuthToken(Boxes.getUserData().get(tokenKey).toString());
      final response = await ApiService().request(
        endpoint: getAnnouncmentEndpoint,
        method: 'GET',
        useAuth: true,

      );
    logger.d(response);
      if (response['success'] == true) {
        
        announcement.value = AnnouncementModel.fromJson(response['data']);
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
    } finally {
      isLoadingAnnouncement.value = false;
    }
  }

  Future<NrcVerificationStatus> verifyUserIdentity({
    required String id,
    required List<String> images,
    required String token,
  }) async {
    isVerifingIdentity.value = true;
    try {
      ApiService().setAuthToken(token);
      Map<String, String> fields = {'identification_number': id};
      List<File> imageFiles = images.map((e) => File(e)).toList();

      Map<String, dynamic> files = {'nrc_image': imageFiles};
      final response = await ApiService().multipartRequest(
        endpoint: verifyIdentityEndPoint,
        method: "POST",
        fields: fields,
        files: files,
      );
      final statusString =
          response['data']['nrc_verification_status'] as String?;
      // if (statusString == null) return NrcVerificationStatus.unverified;
      return NrcVerificationStatus.fromString(statusString ?? 'unverified');
    } catch (e) {
      logger.e(e.toString());
      return NrcVerificationStatus.unverified;
    } finally {
      isVerifingIdentity.value = false;
    }
  }

  @override
  void onInit() async {
    // locationService.handleLocationPermission();
    logger.d(
      "--check role----${Boxes.getUserRole().get(role, defaultValue: user).toString()}",
    );
    if (Boxes.getUserData().get(tokenKey) != null &&
        Boxes.getUserData().get(tokenKey).toString().isNotEmpty) {
      initialSetup();
    }
    getAnnouncmentRequest();
    // Only setup socket if we have a valid user ID

    super.onInit();
  }

  var isLoading = true.obs;

  WebViewController? webController;
  void initializeWebViewController() {
    if (webController != null) {
      return; // Avoid re-initialization
    }
    webController =
        WebViewController()
          ..setJavaScriptMode(JavaScriptMode.unrestricted)
          ..setUserAgent(
            'Mozilla/5.0 (Mobile; rv:52.0) Gecko/52.0 Firefox/52.0',
          )
          ..setNavigationDelegate(
            NavigationDelegate(
              onProgress: (int progress) {
                debugPrint("WebView progress: $progress");
                isLoading.value = progress < 100;
              },
              onPageStarted: (String url) {
                debugPrint("Page started loading: $url");
                isLoading.value = true;
              },
              onPageFinished: (String url) {
                debugPrint("Page finished loading: $url");
                isLoading.value = false;
              },
              onHttpError: (HttpResponseError error) {
                debugPrint("HTTP Error: ${error}");
              },
              onWebResourceError: (WebResourceError error) {
                debugPrint("Web Resource Error: ${error.description}");
              },
              onNavigationRequest: (NavigationRequest request) {
                /* if (request.url.startsWith("https://www.google.com/webhp?hl=en&sa=X&ved=0ahUKEwj4-qy6koSLAxVLRmwGHT7zHXIQPAgI")) {
              return NavigationDecision.prevent;
            }*/
                // if (request.url.contains('${ApiClient.baseUrl}/payment/success')) {
                //   Get.offAllNamed(BottomNavigationScreen.routeName);
                // }
                return NavigationDecision.navigate;
              },
            ),
          )
          ..loadRequest(Uri.parse(stripeUrl.value));
  }

  Future<void> fetchSuggestedPlacesWithRadius(
    String input, {
    double radiusInMeters = 5000,
  })
  async {
    isLoadingOnLocationSuggestion.value = true;

    try {
      Rx<LatLng> markerPosition =
          isDriver.value ? markerPositionDriver : markerPositionRider;

      String url =
          'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=${Uri.encodeComponent(input)}&key=${GoogleClient.googleMapUrl}';

      if (markerPosition.value.latitude != 0.0 &&
          markerPosition.value.longitude != 0.0) {
        url +=
            '&location=${markerPosition.value.latitude},${markerPosition.value.longitude}';
        url += '&radius=${radiusInMeters.toInt()}';
      }

      final response = await http.get(Uri.parse(url));
      debugPrint(url);

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);

        // Clear the previous suggestions before adding new ones
        addressSuggestion.clear();
logger.d(response.body);
        // Loop through the predictions and fetch detailed info for each
        for (var prediction in data['predictions']) {
          if (addressSuggestion.length >= 5) {
            break; // Stop once we have 5 results
          }

          String placeId = prediction['place_id'];
          String placeName = prediction['description'];

          // Fetch place details using Place Details API
          await _fetchPlaceDetails(placeId,placeName);
        }
      } else {
        debugPrint("API error: ${response.statusCode}");
      }
    } catch (e) {
      debugPrint("Error fetching suggestions: $e");
    } finally {
      isLoadingOnLocationSuggestion.value = false;
    }
  }
  Future<void> _fetchPlaceDetails(String placeId, String placeName) async {
    final detailsUrl =
        'https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&key=${GoogleClient.googleMapUrl}';
    final response = await http.get(Uri.parse(detailsUrl));

    if (response.statusCode == 200) {
      final Map<String, dynamic> detailsData = jsonDecode(response.body);
      logger.d(detailsData);
      if (detailsData['status'] == 'OK') {
        var location = detailsData['result']['geometry']['location'];
        double lat = location['lat'];
        double lng = location['lng'];

        LatLng suggestionLatLng = LatLng(lat, lng);
        logger.d(response.body);

        // Check if the suggestion is inside the country boundary
        if (BoundaryController.to.contains(suggestionLatLng)) {
          // If the location is within bounds, add to the list
          addressSuggestion.add({'lat':lat,
          'lng':lng,
          'name': placeName});
        }
      }
    } else {
      debugPrint("Failed to fetch place details for placeId: $placeId");
    }
  }

  void initialSetup() {
    Future.wait([checkUserRole()]);
  }

  /// Fetch Place Details for a given place ID

  Future<void> fetchCurrentLocationMethod({String? tripId}) async {
    try {
      logger.d("🚀 Starting location fetch process");

      // 1. Check permission
      final hasPermission = await locationService.handleLocationPermission();
      logger.i(hasPermission);
      if (!hasPermission) {
        logger.d("❌ Location permission not granted, using fallback");
        locationService.fallbackToDefaultLocation();
        final markerPosition = isDriver.value ? markerPositionDriver : markerPositionRider;
        await BoundaryController.to.initialize(markerPosition.value);
        return;
      }

      final markerPosition = isDriver.value ? markerPositionDriver : markerPositionRider;
      logger.d("✅ Location service enabled, fetching current location...");

      // 2. Fetch location
      await locationService.fetchCurrentLocation(markerPosition: markerPosition);

      // 3. Initialize boundary
      await BoundaryController.to.initialize(markerPosition.value);

      // 4. Emit driver location update if user is driver
      if (isDriver.value && tripId!=null) {
      SocketService().emit(
          DriverEvent.driverLocationUpdate,
          {

              "tripId":tripId,
              "lat":markerPosition.value.latitude,
              "long":markerPosition.value.longitude


            // Add any other info you want to send
          },
        );
        logger.d("📡 Emitted driver location update");
      }

    } catch (e) {
      logger.e("🔥 Error in fetchCurrentLocationMethod: $e");
      locationService.fallbackToDefaultLocation();
    }
  }


  ///------------------------------ Post payment method -------------------------///

  Future<void> postPaymentRequest({String? tripId, String? dCoinId,bool fromDcoin= false}) async {
    try {
      isLoadingPayment.value = true;
logger.i("-----------------payment hit---------------");
      final response = await ApiService().request(
        endpoint: postPaymentEndPoint,
        method: 'POST',
        body: {
          if (tripId != null) "tripId": tripId, //optional
          "name": AccountInformationController.to.userModel.value.name,
          "email": AccountInformationController.to.userModel.value.email,
          "phone": AccountInformationController.to.userModel.value.phoneNumber,
          if (dCoinId != null) "dCoinId": dCoinId, //optional
        },
      );
      logger.d(response);
      if (response['success'] == true) {
        if(fromDcoin){
          showCustomSnackbar(title: 'Success', message: response['message']);

          // Get.back();
          isPaid.value=true;

        }
        else{
          showCustomSnackbar(title: 'Success', message: response['message']);

          stripeUrl.value = response['data'];
          Get.to(OnlinePaymentScreen(), arguments: response['data']);
        }
        // Boxes.getRattingData().delete("rating");

        // Navigator.pop(Get.context!);
      } else {
        logger.e(response);

        showCustomSnackbar(
          title: 'Failed',
          message: response['message'],
          type: SnackBarType.failed,
        );
      }
    } catch (e) {
      // loadingProcess.value = AuthProcess.none;
      logger.e(e.toString());
    } finally {
      isLoadingPayment.value = false;
    }
  }

  Future<void> startTrackingLocationMethod() async {
    Rx<LatLng> markerPosition =
        isDriver.value ? markerPositionDriver : markerPositionRider;
    GoogleMapController? mapController =
        isDriver.value ? mapControllerDriver : mapControllerRider;

    if (mapController == null) {
      logger.e("❌ Map controller not initialized yet.");
      return;
    }
    await locationService.startTrackingLocation(
      markerPosition: markerPosition,
      mapController: mapController,
    );
  }

  Future<void> checkUserRole() async {
    logger.d("token - ${Boxes.getUserData().get(tokenKey)}");
    if (Boxes.getUserData().get(tokenKey) != null &&
        Boxes.getUserData().get(tokenKey).toString().isNotEmpty) {
      Map<String, dynamic> decodedToken = JwtDecoder.decode(
        Boxes.getUserData().get(tokenKey).toString(),
      );

      isDriver.value = decodedToken['role'] == "DRIVER";
    }
  }

  @override
  void onClose() {
    locationService.stopTracking();
    SocketService().disconnect();
    if (mapControllerDriver != null) {
      mapControllerDriver!.dispose();
    } else if (mapControllerRider != null) {
      mapControllerRider!.dispose();
    }
    super.onClose();
  }
}
