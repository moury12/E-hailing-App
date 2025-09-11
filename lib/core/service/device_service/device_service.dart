import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:uuid/uuid.dart';

class DeviceIdService {
  static const _storage = FlutterSecureStorage();
  static const _deviceIdKey = 'device_id';

  /// Get constant device ID (persists across reinstalls)
  static Future<String> getDeviceId() async {
    // Try reading existing ID
    String? deviceId = await _storage.read(key: _deviceIdKey);

    if (deviceId == null) {
      // Generate new UUID
      deviceId = const Uuid().v4();

      // Store securely
      await _storage.write(key: _deviceIdKey, value: deviceId);
    }

    return deviceId;
  }
}
