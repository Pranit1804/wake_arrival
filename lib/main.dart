import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:geofence_foreground_service/constants/geofence_event_type.dart';
import 'package:geofence_foreground_service/geofence_foreground_service.dart';
import 'package:wake_arrival/app.dart';
import 'package:wake_arrival/common/services/alarm_storage_service.dart';
import 'package:wake_arrival/common/services/audio_service.dart';
import 'package:wake_arrival/common/services/notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize local notifications
  await NotificationService.initialize();

  runApp(const App());
}

@pragma('vm:entry-point')
void callbackDispatcher() async {
  GeofenceForegroundService().handleTrigger(
    backgroundTriggerHandler: (zoneID, triggerType) async {
      log(zoneID, name: 'zoneID');

      if (triggerType == GeofenceEventType.enter) {
        log('enter', name: 'triggerType');
        GeofenceForegroundService().removeAllGeoFences();
        GeofenceForegroundService().stopGeofencingService();
        AudioService.playReachedLocationAudio();
        await NotificationService.showDestinationReachedNotification();
        AlarmStorageService.deleteActiveAlarm();
      } else if (triggerType == GeofenceEventType.exit) {
        log('exit', name: 'triggerType');
      } else if (triggerType == GeofenceEventType.dwell) {
        log('dwell', name: 'triggerType');
      } else {
        log('unknown', name: 'triggerType');
      }

      return Future.value(true);
    },
  );
}
