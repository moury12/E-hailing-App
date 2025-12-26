import 'dart:convert';
import 'package:e_hailing_app/core/utils/variables.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;

import '../../../core/utils/google_map_api_key.dart';

class BoundaryController extends GetxController {
  static BoundaryController get to => Get.find<BoundaryController>();

  final Rx<LatLngBounds?> bounds = Rx<LatLngBounds?>(null);
  final RxString _detectedCity = ''.obs;
  final List<List<LatLng>> _rings = [];
  bool _ready = false;

  // Getter to check which city was detected
  String get detectedCity => _detectedCity.value;

  /// City boundary definitions (covering whole metropolitan areas)
  static final Map<String, CityBoundary> _cityBoundaries = {
    'selangor': CityBoundary(
      name: 'Selangor',
      country: 'MY',
      rings: [
        // Selangor state boundary (simplified but covers full area)
        [
          LatLng(3.7236, 101.0742), // Northwest
          LatLng(3.8158, 101.2561), // North
          LatLng(3.7847, 101.4521), // Northeast
          LatLng(3.6234, 101.6789), // East
          LatLng(3.3456, 101.7234), // Southeast
          LatLng(3.0123, 101.6543), // South
          LatLng(2.7891, 101.4321), // Southwest
          LatLng(2.6543, 101.2876), // Southwest coast
          LatLng(2.7234, 101.0987), // West coast
          LatLng(3.2456, 100.9876), // West
          LatLng(3.5678, 100.9543), // Northwest coast
        ],
      ],
    ),
    'kuala_lumpur': CityBoundary(
      name: 'Kuala Lumpur',
      country: 'MY',
      rings: [
        // KL Federal Territory boundary (full area)
        [
          LatLng(3.2334, 101.6234), // Northwest
          LatLng(3.2456, 101.6789), // North
          LatLng(3.2234, 101.7456), // Northeast
          LatLng(3.1789, 101.7623), // East
          LatLng(3.0876, 101.7456), // Southeast
          LatLng(3.0543, 101.7012), // South
          LatLng(3.0678, 101.6456), // Southwest
          LatLng(3.0987, 101.6123), // West
          LatLng(3.1456, 101.6012), // Northwest
        ],
      ],
    ),
    'dhaka': CityBoundary(
      name: 'Dhaka',
      country: 'BD',
      rings: [
        // Dhaka metropolitan area (North & South city corporations combined)
        [
          LatLng(23.9876, 90.3234), // Northwest
          LatLng(24.0234, 90.3789), // North
          LatLng(24.0123, 90.4567), // Northeast
          LatLng(23.9456, 90.5234), // East
          LatLng(23.8234, 90.5456), // Southeast
          LatLng(23.6789, 90.5123), // South
          LatLng(23.6234, 90.4456), // South
          LatLng(23.6543, 90.3567), // Southwest
          LatLng(23.7123, 90.3012), // West
          LatLng(23.8456, 90.2987), // West
          LatLng(23.9234, 90.3123), // Northwest
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
  Future<void> initialize(LatLng userPosition) async {
    // Detect which city the user is in
    final cityKey = await _detectCity(userPosition);

    if (cityKey == null) {
      _ready = false;
      _detectedCity.value = 'unknown';
      return;
    }

    _detectedCity.value = cityKey;
    _loadCityBoundary(cityKey);
    _ready = true;
  }

  /// Detect which city user is currently in
  Future<String?> _detectCity(LatLng pos) async {
    try {
      // Try Google Geocoding first
      final gUrl =
          'https://maps.googleapis.com/maps/api/geocode/json?'
          'latlng=${pos.latitude},${pos.longitude}&key=${GoogleClient.googleMapUrl}';
      final gRes = await http
          .get(Uri.parse(gUrl))
          .timeout(const Duration(seconds: 8));

      logger.d(gRes.body);
      if (gRes.statusCode == 200) {
        final results = (jsonDecode(gRes.body)['results'] as List?) ?? [];

        for (final r in results) {
          final formatted = (r['formatted_address'] as String).toLowerCase();
          logger.d("Checking address: $formatted");

          // Check for city matches
          if (formatted.contains('dhaka')) {
            logger.i("City detected via formatted address: Dhaka");
            return 'dhaka';
          }
          if (formatted.contains('selangor')) {
            logger.i("City detected via formatted address: Selangor");
            return 'selangor';
          }
          if (formatted.contains('kuala lumpur') || formatted.contains('kl')) {
            logger.i("City detected via formatted address: Kuala Lumpur");
            return 'kuala_lumpur';
          }

          // Check address components
          for (final c in (r['address_components'] as List)) {
            final longName = (c['long_name'] as String).toLowerCase();
            final types = (c['types'] as List).cast<String>();

            if (types.contains('administrative_area_level_1') ||
                types.contains('locality')) {
              if (longName.contains('dhaka')) return 'dhaka';
              if (longName.contains('selangor')) return 'selangor';
              if (longName.contains('kuala lumpur')) return 'kuala_lumpur';
            }
          }
        }
      }
    } catch (e, stack) {
      logger.e(
        "Error in _detectCity API call: $e",
        error: e,
        stackTrace: stack,
      );
    }

    // Fallback: Check if point is within any city boundary
    logger.d("Falling back to polygon check for city detection");
    for (final entry in _cityBoundaries.entries) {
      for (final ring in entry.value.rings) {
        if (_pointInRing(pos, ring)) {
          logger.i("City detected via polygon: ${entry.key}");
          return entry.key;
        }
      }
    }

    // If no city detected, return null
    return null;
  }

  /// Load boundary from hardcoded city data
  void _loadCityBoundary(String cityKey) {
    final cityBoundary = _cityBoundaries[cityKey];
    if (cityBoundary == null) return;

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
  }

  /// Allow manual city selection (if you want users to choose)
  void setCityManually(String cityKey) {
    if (_cityBoundaries.containsKey(cityKey)) {
      _detectedCity.value = cityKey;
      _loadCityBoundary(cityKey);
      _ready = true;
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
