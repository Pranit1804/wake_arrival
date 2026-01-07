import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geofence_foreground_service/constants/geofence_event_type.dart';
import 'package:geofence_foreground_service/models/zone.dart';
import 'package:latlng/latlng.dart' as lng;
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart' as loc;
import 'package:geofence_foreground_service/geofence_foreground_service.dart'
    as gfs;
import 'package:permission_handler/permission_handler.dart';
import 'package:wake_arrival/common/widgets/background_location_disclosure_dialog.dart';
import 'package:wake_arrival/main.dart';

class GeofencingService {
  static Future<void> initPlatformState(
      LatLng latLng, BuildContext context) async {
    try {
      // Step 1: Show prominent disclosure dialog for background location
      // This is REQUIRED by Google Play Store policy before requesting background location
      if (context.mounted) {
        final userConsent = await showDialog<bool>(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext dialogContext) =>
              const BackgroundLocationDisclosureDialog(),
        );

        // If user declines, don't proceed with background permission
        if (userConsent != true) {
          throw PlatformException(
            code: 'USER_DECLINED',
            message: 'User declined background location disclosure',
          );
        }
      }

      // Step 2: Request permissions and start service
      await _askPermissionAndStartService(latLng);
    } catch (e) {
      rethrow;
    }
  }

  static Future<void> _askPermissionAndStartService(
    LatLng latLng,
  ) async {
    final location = loc.Location();

    // Check if location service is enabled first
    bool serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        throw Exception('Location service is disabled');
      }
    }

    // Step 1: Request FOREGROUND location permission first
    PermissionStatus foregroundPermission = await Permission.location.status;
    if (foregroundPermission.isDenied) {
      foregroundPermission = await Permission.location.request();
    }

    if (foregroundPermission.isPermanentlyDenied) {
      await openAppSettings();
      throw PlatformException(
        code: 'PERMISSION_DENIED',
        message:
            'Foreground location permission denied. Please enable location access in system settings.',
      );
    }

    if (!foregroundPermission.isGranted && !foregroundPermission.isLimited) {
      throw PlatformException(
        code: 'PERMISSION_DENIED',
        message: 'Foreground location permission is required',
      );
    }

    // Step 2: Request BACKGROUND location permission (Android 10+ / iOS)
    // This must be requested AFTER foreground permission is granted
    PermissionStatus backgroundPermission =
        await Permission.locationAlways.status;
    if (backgroundPermission.isDenied) {
      backgroundPermission = await Permission.locationAlways.request();
    }

    if (backgroundPermission.isPermanentlyDenied) {
      await openAppSettings();
      throw PlatformException(
        code: 'PERMISSION_DENIED',
        message:
            'Background location permission denied. Please choose "Allow all the time" in system settings.',
      );
    }

    if (!backgroundPermission.isGranted && !backgroundPermission.isLimited) {
      await openAppSettings();
      throw PlatformException(
        code: 'PERMISSION_DENIED',
        message:
            'Background location permission is required. Please choose "Allow all the time" in system settings.',
      );
    }

    // Step 3: Enable background mode for iOS
    final backgroundEnabled = await location.enableBackgroundMode(enable: true);
    if (!backgroundEnabled && Platform.isAndroid) {
      await openAppSettings();
      throw PlatformException(
        code: 'BACKGROUND_DISABLED',
        message:
            'Background location is not fully enabled. Please set permission to "Allow all the time".',
      );
    }

    // Start geofencing service
    bool hasServiceStarted =
        await gfs.GeofenceForegroundService().startGeofencingService(
      contentTitle: 'Wake Arrival is active',
      contentText: 'Monitoring your location for arrival alerts',
      notificationChannelId: 'com.app.geofencing_notifications_channel',
      serviceId: 525600,
      callbackDispatcher: callbackDispatcher,
    );

    if (!hasServiceStarted) {
      throw Exception('Failed to start geofencing service');
    }

    // Add geofence zone
    await gfs.GeofenceForegroundService().addGeofenceZone(
      zone: Zone(
        id: 'zone#1_id',
        radius: 1000, // 1km radius in meters
        coordinates: [
          lng.LatLng(lng.Angle.degree(latLng.latitude),
              lng.Angle.degree(latLng.longitude)),
        ],
        triggers: [
          GeofenceEventType.enter,
          GeofenceEventType.exit,
        ],
        expirationDuration: const Duration(days: 1),
        initialTrigger: GeofenceEventType.unKnown,
      ),
    );
  }

  // Stop geofencing service
  static Future<void> stopGeofencing() async {
    try {
      await gfs.GeofenceForegroundService().stopGeofencingService();
    } catch (e) {
      // Handle error silently or log
    }
  }
}
