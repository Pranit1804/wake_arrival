import 'package:wake_arrival/common/services/objectbox_service.dart';
import 'package:wake_arrival/models/home/data/alarm_model.dart';
import 'package:wake_arrival/objectbox.g.dart';

class AlarmStorageService {
  // Save active alarm (replaces any existing active alarm)
  static Future<int> saveActiveAlarm(AlarmModel alarm) async {
    try {
      final objectBox = await ObjectBoxService.getInstance();

      // Delete any existing active alarms first (single alarm system)
      final existingAlarms = objectBox.alarmBox
          .query(AlarmModel_.isActive.equals(true))
          .build()
          .find();

      for (var existingAlarm in existingAlarms) {
        objectBox.alarmBox.remove(existingAlarm.id);
      }

      // Save new alarm
      return objectBox.alarmBox.put(alarm);
    } catch (e) {
      return 0;
    }
  }

  // Get the single active alarm
  static Future<AlarmModel?> getActiveAlarm() async {
    try {
      final objectBox = await ObjectBoxService.getInstance();
      final query =
          objectBox.alarmBox.query(AlarmModel_.isActive.equals(true)).build();

      return query.findFirst();
    } catch (e) {
      return null;
    }
  }

  // Delete active alarm
  static Future<bool> deleteActiveAlarm() async {
    try {
      final alarm = await getActiveAlarm();
      if (alarm == null) return false;

      final objectBox = await ObjectBoxService.getInstance();
      return objectBox.alarmBox.remove(alarm.id);
    } catch (e) {
      return false;
    }
  }

  // Check if an active alarm exists
  static Future<bool> hasActiveAlarm() async {
    try {
      final alarm = await getActiveAlarm();
      return alarm != null;
    } catch (e) {
      return false;
    }
  }

  // Get all alarms (for history)
  static Future<List<AlarmModel>> getAllAlarms() async {
    try {
      final objectBox = await ObjectBoxService.getInstance();
      return objectBox.alarmBox.getAll();
    } catch (e) {
      return [];
    }
  }
}
