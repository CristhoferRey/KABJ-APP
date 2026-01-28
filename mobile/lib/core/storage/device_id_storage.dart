import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

class DeviceIdStorage {
  static const _deviceKey = 'device_id';

  DeviceIdStorage._internal();

  static final DeviceIdStorage instance = DeviceIdStorage._internal();

  Future<String> getOrCreateDeviceId() async {
    final prefs = await SharedPreferences.getInstance();
    final existing = prefs.getString(_deviceKey);
    if (existing != null && existing.isNotEmpty) {
      return existing;
    }
    const uuid = Uuid();
    final newId = uuid.v4();
    await prefs.setString(_deviceKey, newId);
    return newId;
  }
}
