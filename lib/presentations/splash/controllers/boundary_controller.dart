import 'dart:convert';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;

class BoundaryController extends GetxController {
  static BoundaryController get to => Get.find<BoundaryController>();

  final Rx<LatLngBounds?> bounds = Rx<LatLngBounds?>(null);

  // Define allowed operational regions
  final List<String> _allowedRegions = [
    'Kuala Lumpur',
    'Selangor',
    'Dhaka',
    'Rangpur',
  ];

  final List<List<LatLng>> _rings = [];
  bool _ready = false;

  /// PUBLIC: hard check before setting marker/tap/pickup/dropoff
  bool contains(LatLng p) {
    // If no regions loaded yet, enforce restriction or allow based on policy.
    // For safety, if we aren't ready or have no rings, return false (restricted).
    if (_rings.isEmpty) return false;

    // Check if point is in ANY of the loaded regions
    for (final ring in _rings) {
      if (_pointInRing(p, ring)) return true;
    }
    return false;
  }

  /// PUBLIC: initialize - loads all allowed regions
  Future<void> initialize(LatLng? userPosition) async {
    if (_ready) return;

    // Load all regions in parallel
    await Future.wait(
      _allowedRegions.map((region) => _loadRegionFromNominatim(region)),
    );

    _calculateBounds();
    _ready = true;
  }

  // -------------------- internals --------------------

  Future<void> _loadRegionFromNominatim(String query) async {
    try {
      // Nominatim search API with polygon_geojson=1
      final url =
          'https://nominatim.openstreetmap.org/search?q=$query&format=json&polygon_geojson=1&limit=1';

      // User-Agent is REQUIRED by Nominatim Usage Policy
      final headers = {
        'User-Agent': 'EHailingApp/1.0 (generic_contact@example.com)',
      };

      final response = await http
          .get(Uri.parse(url), headers: headers)
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data is List && data.isNotEmpty) {
          final result = data[0];
          final geojson = result['geojson'];
          _parseGeoJSON(geojson);
        }
      }
    } catch (e) {
      // debugPrint('Failed to load boundary for $query: $e');
    }
  }

  void _parseGeoJSON(dynamic geometry) {
    if (geometry == null) return;

    final type = geometry['type'];
    final coords = geometry['coordinates'] as List;

    LatLng _pt(List c) =>
        LatLng((c[1] as num).toDouble(), (c[0] as num).toDouble());

    if (type == 'Polygon') {
      // Polygon: [ [ [lon, lat], ... ] ]
      final outer = coords.first as List;
      _rings.add(outer.map<LatLng>((c) => _pt(c as List)).toList());
    } else if (type == 'MultiPolygon') {
      // MultiPolygon: [ [ [ [lon, lat], ... ] ], ... ]
      for (final poly in coords) {
        final outer = (poly as List).first as List;
        _rings.add(outer.map<LatLng>((c) => _pt(c as List)).toList());
      }
    }
  }

  void _calculateBounds() {
    if (_rings.isEmpty) return;

    double minLat = 90, maxLat = -90, minLng = 180, maxLng = -180;

    for (final ring in _rings) {
      for (final p in ring) {
        if (p.latitude < minLat) minLat = p.latitude;
        if (p.latitude > maxLat) maxLat = p.latitude;
        if (p.longitude < minLng) minLng = p.longitude;
        if (p.longitude > maxLng) maxLng = p.longitude;
      }
    }

    const pad = 0.01;
    bounds.value = LatLngBounds(
      southwest: LatLng(minLat - pad, minLng - pad),
      northeast: LatLng(maxLat + pad, maxLng + pad),
    );
  }

  // Ray-casting algorithm
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
}
