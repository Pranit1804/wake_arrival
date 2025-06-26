import 'package:geofence_foreground_service/constants/geofence_event_type.dart';
import 'package:geofence_foreground_service/models/zone.dart';
import 'package:latlng/latlng.dart' as lng;
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart' as loc;
import 'package:geofence_foreground_service/geofence_foreground_service.dart'
    as gfs;
import 'package:wake_arrival/main.dart';

class GeofencingService {
  static Future<bool> initPlatformState(LatLng latLng) async {
    bool serviceEnabled;
    final location = loc.Location.instance;

    bool locationServiceAccessible =
        await location.hasPermission() == loc.PermissionStatus.granted;

    if (!locationServiceAccessible) {
      return false;
    }

    serviceEnabled = await loc.Location().serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await loc.Location().requestService();
      if (!serviceEnabled) {
        return false;
      }
    } // Remember to handle permissions before initiating the plugin

    bool hasServiceStarted =
        await gfs.GeofenceForegroundService().startGeofencingService(
      contentTitle: 'Test app is running in the background',
      contentText:
          'Test app will be running to ensure seamless integration with ops team',
      notificationChannelId: 'com.app.geofencing_notifications_channel',
      serviceId: 525600,
      callbackDispatcher: callbackDispatcher,
    );

    if (hasServiceStarted) {
      return await gfs.GeofenceForegroundService().addGeofenceZone(
        zone: Zone(
          id: 'zone#1_id',
          radius: 400, // measured in meters
          coordinates: [
            lng.LatLng(lng.Angle.degree(latLng.latitude),
                lng.Angle.degree(latLng.longitude)),
          ],
          triggers: [
            GeofenceEventType.dwell,
            GeofenceEventType.enter,
            GeofenceEventType.exit
          ],
          expirationDuration: const Duration(days: 1),
          dwellLoiteringDelay: const Duration(hours: 1),
          initialTrigger: GeofenceEventType.unKnown,
        ),
      );
    } else {
      return false;
    }
  }
}
