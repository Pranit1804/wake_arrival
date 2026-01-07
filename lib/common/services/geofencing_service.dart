import 'package:flutter/services.dart';
import 'package:geofence_foreground_service/constants/geofence_event_type.dart';
import 'package:geofence_foreground_service/models/zone.dart';
import 'package:latlng/latlng.dart' as lng;
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart' as loc;
import 'package:geofence_foreground_service/geofence_foreground_service.dart'
    as gfs;
import 'package:wake_arrival/main.dart';

class GeofencingService {
  static Future<void> initPlatformState(LatLng latLng) async {
    try {
      final location = loc.Location();

      // Check if service is enabled
      bool serviceEnabled = await location.serviceEnabled();
      if (!serviceEnabled) {
        serviceEnabled = await location.requestService();
        if (!serviceEnabled) {
          throw Exception('Location service is disabled');
        }
      }

      // Check and request permissions
      // Step 1: Request foreground location permission first
      loc.PermissionStatus permissionGranted = await location.hasPermission();
      if (permissionGranted == loc.PermissionStatus.denied ||
          permissionGranted == loc.PermissionStatus.deniedForever) {
        permissionGranted = await location.requestPermission();
        if (permissionGranted != loc.PermissionStatus.granted &&
            permissionGranted != loc.PermissionStatus.grantedLimited) {
          throw Exception('Foreground location permission denied');
        }
      }

      // Step 2: Request background location permission (Android 10+ / iOS)
      // For Android 10+, this must be requested separately after foreground permission
      if (permissionGranted == loc.PermissionStatus.granted ||
          permissionGranted == loc.PermissionStatus.grantedLimited) {
        // Request background permission (Always) for geofencing
        final backgroundPermission = await location.requestPermission();
        if (backgroundPermission != loc.PermissionStatus.granted &&
            backgroundPermission != loc.PermissionStatus.grantedLimited) {
          throw PlatformException(
            code: 'PERMISSION_DENIED',
            message: 'Background location permission denied',
          );
        }
      }

      // Enable background mode for iOS
      await location.enableBackgroundMode(enable: true);

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
    } catch (e) {
      rethrow;
    }
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
