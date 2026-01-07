import 'dart:async';
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart' as loc;

class LocationService {
  static final loc.Location _location = loc.Location();

  static Future<LatLng?> getCurrentLocation() async {
    try {
      bool serviceEnabled = await _location.serviceEnabled();
      if (!serviceEnabled) {
        serviceEnabled = await _location.requestService();
        if (!serviceEnabled) return null;
      }

      loc.PermissionStatus permissionGranted = await _location.hasPermission();
      if (permissionGranted == loc.PermissionStatus.denied) {
        permissionGranted = await _location.requestPermission();
        if (permissionGranted != loc.PermissionStatus.granted) {
          return null;
        }
      }

      final locationData = await _location.getLocation();

      if (locationData.latitude != null && locationData.longitude != null) {
        return LatLng(locationData.latitude!, locationData.longitude!);
      }

      return null;
    } catch (e) {
      return null;
    }
  }

  static Stream<LatLng?> getLocationStream() {
    return _location.onLocationChanged.map((locationData) {
      if (locationData.latitude != null && locationData.longitude != null) {
        return LatLng(locationData.latitude!, locationData.longitude!);
      }
      return null;
    });
  }
}
