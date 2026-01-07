import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart' as loc;
import 'package:wake_arrival/models/home/data/alarm_model.dart';
import 'package:wake_arrival/models/home/presentation/state/alarm_details_state.dart';

class AlarmDetailsCubit extends Cubit<AlarmDetailsState> {
  final loc.Location _location = loc.Location();
  StreamSubscription<loc.LocationData>? _locationSubscription;

  AlarmDetailsCubit({
    required AlarmModel alarm,
    required LatLng? currentLocation,
    required String distance,
    required String duration,
  }) : super(AlarmDetailsState(
          alarm: alarm,
          currentLocation: currentLocation,
          distance: distance,
          duration: duration,
          currentSpeed: '-- km/h',
        )) {
    _startLocationTracking();
  }

  void _startLocationTracking() {
    _locationSubscription = _location.onLocationChanged.listen((locationData) {
      if (locationData.latitude != null && locationData.longitude != null) {
        _updateLocationData(locationData);
      }
    });
  }

  void _updateLocationData(loc.LocationData locationData) {
    final newLocation = LatLng(locationData.latitude!, locationData.longitude!);
    final destination = LatLng(state.alarm.latitude, state.alarm.longitude);

    final distanceInMeters = _calculateDistance(newLocation, destination);
    final formattedDistance = _formatDistance(distanceInMeters);
    final speedData =
        _calculateSpeedAndETA(locationData.speed, distanceInMeters);

    emit(state.copyWith(
      currentLocation: newLocation,
      distance: formattedDistance,
      duration: speedData['duration'],
      currentSpeed: speedData['speed'],
    ));
  }

  double _calculateDistance(LatLng from, LatLng to) {
    const distance = Distance();
    return distance.as(LengthUnit.Meter, from, to);
  }

  String _formatDistance(double distanceInMeters) {
    if (distanceInMeters < 1000) {
      return '${distanceInMeters.toStringAsFixed(0)} m';
    } else {
      return '${(distanceInMeters / 1000).toStringAsFixed(1)} km';
    }
  }

  Map<String, String> _calculateSpeedAndETA(
      double? speedMps, double distanceInMeters) {
    String formattedSpeed;
    String formattedDuration;

    if (speedMps != null && speedMps > 0) {
      final speedKmh = speedMps * 3.6;
      formattedSpeed = '${speedKmh.toStringAsFixed(0)} km/h';

      final distanceInKm = distanceInMeters / 1000;
      final timeInHours = distanceInKm / speedKmh;
      final timeInMinutes = (timeInHours * 60).round();

      formattedDuration = _formatDuration(timeInMinutes);
    } else {
      formattedSpeed = '-- km/h';
      final distanceInKm = distanceInMeters / 1000;
      final timeInHours = distanceInKm / 40; // Default 40 km/h
      final timeInMinutes = (timeInHours * 60).round();
      formattedDuration = _formatDuration(timeInMinutes);
    }

    return {
      'speed': formattedSpeed,
      'duration': formattedDuration,
    };
  }

  String _formatDuration(int timeInMinutes) {
    if (timeInMinutes < 1) {
      return '< 1 min';
    } else if (timeInMinutes < 60) {
      return '$timeInMinutes min';
    } else {
      final hours = timeInMinutes ~/ 60;
      final minutes = timeInMinutes % 60;
      return '${hours}h ${minutes}m';
    }
  }

  @override
  Future<void> close() {
    _locationSubscription?.cancel();
    return super.close();
  }
}
