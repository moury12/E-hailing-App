import 'package:e_hailing_app/core/utils/variables.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart';

class BoundaryController extends GetxController {
  static BoundaryController get to => Get.find<BoundaryController>();

  final Rx<LatLngBounds?> bounds = Rx<LatLngBounds?>(null);
  final RxString _detectedCity = ''.obs;
  final List<List<LatLng>> _rings = [];
  bool _ready = false;

  // Getter to check which city was detected
  String get detectedCity => _detectedCity.value;

  /// City boundary definitions - REAL COORDINATES
  static final Map<String, CityBoundary> _cityBoundaries = {
    'dhaka': CityBoundary(
      name: 'Dhaka',
      country: 'BD',
      rings: [
        // Dhaka Metropolitan Area (Greater Dhaka)
        // Covers Dhaka North & South City Corporation + surrounding areas
        [
          LatLng(24.0500, 90.2500), // Far Northwest (Savar)
          LatLng(24.0800, 90.3500), // North (Uttara North)
          LatLng(24.0200, 90.5000), // Northeast (Gazipur border)
          LatLng(23.9500, 90.5200), // East (Demra area)
          LatLng(23.8500, 90.5500), // Southeast (Narayanganj border)
          LatLng(23.6800, 90.5000), // South (Keraniganj)
          LatLng(23.6500, 90.4000), // South-Central
          LatLng(23.6800, 90.3000), // Southwest
          LatLng(23.7500, 90.2800), // West (Dhanmondi-Mohammadpur area)
          LatLng(23.9000, 90.2700), // Northwest (Mirpur-Pallabi)
        ],
      ],
    ),
    'kl_selangor': CityBoundary(
      name: 'KL & Selangor',
      country: 'MY',
      rings: [
        [
          LatLng(3.258081, 101.639366),
          LatLng(3.274510, 101.678954),
          LatLng(3.256947, 101.710788),
          LatLng(3.262655, 101.736515),
          LatLng(3.254091, 101.744077),
          LatLng(3.211835, 101.790012),
          LatLng(3.129126, 101.794304),
          LatLng(3.095644, 101.770352),
          LatLng(3.060713, 101.817576),
          LatLng(2.990603, 101.829460),
          LatLng(2.925149, 101.784007),
          LatLng(2.873975, 101.675389),
          LatLng(2.896957, 101.628022),
          LatLng(2.954859, 101.540714),
          LatLng(2.958793, 101.436344),
          LatLng(3.001206, 101.354937),
          LatLng(3.093010, 101.353660),
          LatLng(3.269100, 101.554003),
          LatLng(3.226744, 101.602315),
        ],
      ],
    ),
  };

  /// PUBLIC: hard check before setting marker/tap/pickup/dropoff
  bool contains(LatLng p) {
    final b = bounds.value;
    if (b == null) {
      logger.w("BoundaryController contains: bounds are null (not ready)");
      return false; // Restrict if not ready
    }
    if (!_inBounds(p, b)) {
      logger.w("BoundaryController contains: point $p outside bounding box $b");
      return false;
    }

    // Polygon check (outer rings only)
    for (final ring in _rings) {
      if (_pointInRing(p, ring)) {
        logger.i("BoundaryController contains: point $p INSIDE ring");
        return true;
      }
    }
    logger.w("BoundaryController contains: point $p OUTSIDE all rings");
    return false;
  }

  /// PUBLIC: initialize with user GPS position
  /// Uses cached result if city was already detected (saves Geocoding API calls)
  Future<void> initialize(LatLng userPosition) async {
    // Skip if already initialized — cached result (FREE)
    if (_ready &&
        _detectedCity.value.isNotEmpty &&
        _detectedCity.value != 'unknown') {
      logger.i(
        "City already cached: ${_detectedCity.value} — skipping detection",
      );
      return;
    }

    // Detect which city the user is in
    final cityKey = await _detectCity(userPosition);

    if (cityKey == null) {
      _ready = false;
      _detectedCity.value = 'unknown';
      logger.e("Failed to detect city for position: $userPosition");
      return;
    }

    _detectedCity.value = cityKey;
    _loadCityBoundary(cityKey);
    _ready = true;
    logger.i("Successfully initialized boundary for city: $cityKey");
  }

  /// Detect which city user is currently in
  Future<String?> _detectCity(LatLng pos) async {
    // 1️⃣ Try FREE polygon check first (no API cost)
    for (final entry in _cityBoundaries.entries) {
      for (final ring in entry.value.rings) {
        if (_pointInRing(pos, ring)) {
          logger.i("City detected via polygon (FREE): ${entry.key}");
          return entry.key;
        }
      }
    }

    // 2️⃣ Fallback: Native Geocoding (FREE)
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        pos.latitude,
        pos.longitude,
      );

      for (final p in placemarks) {
        final String? locality = p.locality?.toLowerCase();
        final String? administrativeArea = p.administrativeArea?.toLowerCase();
        final String? subAdministrativeArea =
            p.subAdministrativeArea?.toLowerCase();
        final String? name = p.name?.toLowerCase();

        logger.d(
          "Checking placemark: $locality, $administrativeArea, $subAdministrativeArea, $name",
        );

        // Check for Dhaka
        if ((locality?.contains('dhaka') ?? false) ||
            (administrativeArea?.contains('dhaka') ?? false) ||
            (name?.contains('dhaka') ?? false)) {
          logger.i("City detected via Native Geocoding: Dhaka");
          return 'dhaka';
        }

        // Check for KL/Selangor
        if ((locality?.contains('selangor') ?? false) ||
            (administrativeArea?.contains('selangor') ?? false) ||
            (locality?.contains('kuala lumpur') ?? false) ||
            (administrativeArea?.contains('kuala lumpur') ?? false) ||
            (locality?.contains('kl') ?? false) ||
            (administrativeArea?.contains('kl') ?? false)) {
          logger.i("City detected via Native Geocoding: KL/Selangor");
          return 'kl_selangor';
        }
      }
    } catch (e, stack) {
      logger.e(
        "Error in _detectCity Native Geocoding: $e",
        error: e,
        stackTrace: stack,
      );
    }

    logger.e("No city detected for position: $pos");
    return null;
  }

  /// Load boundary from hardcoded city data
  void _loadCityBoundary(String cityKey) {
    final cityBoundary = _cityBoundaries[cityKey];
    if (cityBoundary == null) {
      logger.e("No boundary data found for city: $cityKey");
      return;
    }

    _rings.clear();
    _rings.addAll(cityBoundary.rings);

    // Compute bounding box
    double minLat = 90, maxLat = -90, minLng = 180, maxLng = -180;

    for (final ring in _rings) {
      for (final p in ring) {
        if (p.latitude < minLat) minLat = p.latitude;
        if (p.latitude > maxLat) maxLat = p.latitude;
        if (p.longitude < minLng) minLng = p.longitude;
        if (p.longitude > maxLng) maxLng = p.longitude;
      }
    }

    const pad = 0.02;
    bounds.value = LatLngBounds(
      southwest: LatLng(minLat - pad, minLng - pad),
      northeast: LatLng(maxLat + pad, maxLng + pad),
    );

    logger.i("Loaded boundary for $cityKey: ${bounds.value}");
  }

  /// Allow manual city selection (if you want users to choose)
  void setCityManually(String cityKey) {
    if (_cityBoundaries.containsKey(cityKey)) {
      _detectedCity.value = cityKey;
      _loadCityBoundary(cityKey);
      _ready = true;
      logger.i("Manually set city to: $cityKey");
    }
  }

  /// Get list of available cities
  List<String> getAvailableCities() {
    return _cityBoundaries.keys.toList();
  }

  /// Get display name for city
  String getCityDisplayName(String cityKey) {
    return _cityBoundaries[cityKey]?.name ?? cityKey;
  }

  // -------------------- Helper methods --------------------

  bool _inBounds(LatLng p, LatLngBounds b) =>
      p.latitude >= b.southwest.latitude &&
      p.latitude <= b.northeast.latitude &&
      p.longitude >= b.southwest.longitude &&
      p.longitude <= b.northeast.longitude;

  bool _pointInRing(LatLng p, List<LatLng> ring) {
    bool inside = false;
    for (int i = 0, j = ring.length - 1; i < ring.length; j = i++) {
      final xi = ring[i].latitude, yi = ring[i].longitude;
      final xj = ring[j].latitude, yj = ring[j].longitude;
      final intersect =
          ((yi > p.longitude) != (yj > p.longitude)) &&
          (p.latitude <
              (xj - xi) * (p.longitude - yi) / ((yj - yi) + 0.0) + xi);
      if (intersect) inside = !inside;
    }
    return inside;
  }

  bool get isReady => _ready;
}

/// City boundary data model
class CityBoundary {
  final String name;
  final String country;
  final List<List<LatLng>> rings;

  CityBoundary({
    required this.name,
    required this.country,
    required this.rings,
  });
}
