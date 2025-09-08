import 'dart:convert';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;

import '../../../core/utils/google_map_api_key.dart';

class BoundaryController extends GetxController {
  static BoundaryController get to => Get.find<BoundaryController>();

  final Rx<LatLngBounds?> bounds = Rx<LatLngBounds?>(null);
  final RxString _iso2 = ''.obs; // e.g., "MY"
  final List<List<LatLng>> _rings = []; // country outer rings
  bool _ready = false;

  /// PUBLIC: camera bounds for GoogleMap.cameraTargetBounds
  // LatLngBounds? get bounds => _bounds.value;

  /// PUBLIC: hard check before setting marker/tap/pickup/dropoff
  bool contains(LatLng p) {
    final b = bounds.value;
    if (b == null) return true; // no restriction if not ready
    if (!_inBounds(p, b)) return false;
    // polygon check (outer rings only)
    for (final ring in _rings) {
      if (_pointInRing(p, ring)) return true;
    }
    return false;
  }

  /// PUBLIC: initialize once with user GPS
  Future<void> initialize(LatLng userPosition) async {
    // if (_ready) return;

    // 1) detect ISO2 (fallback Malaysia)
    final iso2 = await _detectISO2(userPosition) ?? 'MY';
    _iso2.value = iso2;

    // 2) convert to ISO3
    final iso3 = await _iso2to3(iso2);

    // 3) fetch simplified GeoJSON + parse
    await _loadFenceFromGeoBoundaries(iso3);

    _ready = true;
  }

  // -------------------- internals (tiny + focused) --------------------

  Future<String?> _detectISO2(LatLng pos) async {
    try {
      // Google Geocoding
      final gUrl =
          'https://maps.googleapis.com/maps/api/geocode/json?latlng=${pos.latitude},${pos.longitude}&key=${GoogleClient.googleMapUrl}';
      final gRes = await http.get(Uri.parse(gUrl)).timeout(const Duration(seconds: 8));
      if (gRes.statusCode == 200) {
        final results = (jsonDecode(gRes.body)['results'] as List?) ?? [];
        for (final r in results) {
          for (final c in (r['address_components'] as List)) {
            final types = (c['types'] as List).cast<String>();
            if (types.contains('country')) {
              return (c['short_name'] as String).toUpperCase();
            }
          }
        }
      }
    } catch (_) {}

    // Fallback: BigDataCloud (free)
    try {
      final bUrl =
          'https://api.bigdatacloud.net/data/reverse-geocode-client?latitude=${pos.latitude}&longitude=${pos.longitude}&localityLanguage=en';
      final bRes = await http.get(Uri.parse(bUrl)).timeout(const Duration(seconds: 6));
      if (bRes.statusCode == 200) {
        final data = jsonDecode(bRes.body);
        final code = (data['countryCode'] as String?)?.toUpperCase();
        if (code != null && code.isNotEmpty) return code;
      }
    } catch (_) {}

    // Final fallback: Malaysia
    return 'MY';
  }

  // tiny local map for speed; falls back to RESTCountries if missing
  static const Map<String, String> _iso2to3Local = {
    'MY': 'MYS', 'BD': 'BGD', 'IN': 'IND', 'US': 'USA', 'SG': 'SGP',
    'PK': 'PAK', 'GB': 'GBR', 'CA': 'CAN', 'AU': 'AUS', 'ID': 'IDN'
  };

  Future<String> _iso2to3(String iso2) async {
    final hit = _iso2to3Local[iso2];
    if (hit != null) return hit;
    try {
      final url = 'https://restcountries.com/v3.1/alpha/$iso2';
      final res = await http.get(Uri.parse(url)).timeout(const Duration(seconds: 6));
      if (res.statusCode == 200) {
        final arr = jsonDecode(res.body);
        final cca3 = (arr is List && arr.isNotEmpty) ? arr[0]['cca3'] as String? : null;
        if (cca3 != null) return cca3;
      }
    } catch (_) {}
    // best-effort: use iso2 as-is (may fail with geoboundaries, but we tried)
    return iso2;
  }

  Future<void> _loadFenceFromGeoBoundaries(String iso3) async {
    try {
      final metaUrl = 'https://www.geoboundaries.org/api/current/gbOpen/$iso3/ADM0';
      final metaRes = await http.get(Uri.parse(metaUrl)).timeout(const Duration(seconds: 8));
      if (metaRes.statusCode != 200) return;

      final meta = jsonDecode(metaRes.body);
      // logger.d("_____________________________________________________");
      // logger.d(meta);
      final geoUrl = (meta['simplifiedGeometryGeoJSON'] as String?) ?? (meta['gjDownloadURL'] as String);
      final gjRes = await http.get(Uri.parse(geoUrl)).timeout(const Duration(seconds: 12));
      if (gjRes.statusCode != 200) return;

      final gj = jsonDecode(gjRes.body);

      Map<String, dynamic> _geom(dynamic root) {
        if (root is Map<String, dynamic>) {
          if (root['type'] == 'FeatureCollection') return (root['features'] as List).first['geometry'];
          if (root['type'] == 'Feature') return root['geometry'];
          if (root['type'] == 'Polygon' || root['type'] == 'MultiPolygon') return root;
        }
        throw Exception('Unsupported GeoJSON');
      }

      LatLng _pt(List c) => LatLng((c[1] as num).toDouble(), (c[0] as num).toDouble());

      final geom = _geom(gj);
      _rings.clear();

      if (geom['type'] == 'Polygon') {
        final outer = (geom['coordinates'] as List).first as List;
        _rings.add(outer.map<LatLng>((c) => _pt(c as List)).toList());
      } else if (geom['type'] == 'MultiPolygon') {
        for (final poly in (geom['coordinates'] as List)) {
          final outer = (poly as List).first as List;
          _rings.add(outer.map<LatLng>((c) => _pt(c as List)).toList());
        }
      }

      if (_rings.isEmpty) return;

      // compute bbox
      double minLat =  90, maxLat = -90, minLng =  180, maxLng = -180;
      for (final ring in _rings) {
        for (final p in ring) {
          if (p.latitude  < minLat) minLat = p.latitude;
          if (p.latitude  > maxLat) maxLat = p.latitude;
          if (p.longitude < minLng) minLng = p.longitude;
          if (p.longitude > maxLng) maxLng = p.longitude;
        }
      }
      const pad = 0.01;
      bounds.value = LatLngBounds(
        southwest: LatLng(minLat - pad, minLng - pad),
        northeast: LatLng(maxLat + pad, maxLng + pad),
      );
    } catch (_) {
      // leave bounds null (no restriction) if anything fails
    }
  }

  // helpers
  bool _inBounds(LatLng p, LatLngBounds b) =>
      p.latitude  >= b.southwest.latitude &&
          p.latitude  <= b.northeast.latitude &&
          p.longitude >= b.southwest.longitude &&
          p.longitude <= b.northeast.longitude;

  bool _pointInRing(LatLng p, List<LatLng> ring) {
    bool inside = false;
    for (int i = 0, j = ring.length - 1; i < ring.length; j = i++) {
      final xi = ring[i].latitude, yi = ring[i].longitude;
      final xj = ring[j].latitude, yj = ring[j].longitude;
      final intersect = ((yi > p.longitude) != (yj > p.longitude)) &&
          (p.latitude < (xj - xi) * (p.longitude - yi) / ((yj - yi) + 0.0) + xi);
      if (intersect) inside = !inside;
    }
    return inside;
  }
}
