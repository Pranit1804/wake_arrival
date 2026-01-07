import 'package:latlong2/latlong.dart';

class DistanceCalculatorService {
  static const Distance _distance = Distance();

  static double calculateDistanceInMeters(LatLng from, LatLng to) {
    return _distance.as(LengthUnit.Meter, from, to);
  }

  static String getFormattedDistance(LatLng from, LatLng to) {
    final distanceInMeters = calculateDistanceInMeters(from, to);

    if (distanceInMeters < 1000) {
      return '${distanceInMeters.toStringAsFixed(0)} m';
    } else {
      return '${(distanceInMeters / 1000).toStringAsFixed(1)} km';
    }
  }

  static String calculateETA(LatLng from, LatLng to,
      {double avgSpeedKmh = 40}) {
    final distanceInKm = calculateDistanceInMeters(from, to) / 1000;
    final timeInHours = distanceInKm / avgSpeedKmh;
    final timeInMinutes = (timeInHours * 60).round();

    if (timeInMinutes < 60) {
      return '$timeInMinutes min';
    } else {
      final hours = timeInMinutes ~/ 60;
      final minutes = timeInMinutes % 60;
      return '${hours}h ${minutes}m';
    }
  }

  static Map<String, String> getDistanceAndETA(LatLng from, LatLng to) {
    return {
      'distance': getFormattedDistance(from, to),
      'duration': calculateETA(from, to),
    };
  }
}
