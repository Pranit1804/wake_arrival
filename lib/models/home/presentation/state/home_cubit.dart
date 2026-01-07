import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:latlong2/latlong.dart';
import 'package:wake_arrival/common/services/geofencing_service.dart';
import 'package:wake_arrival/common/services/alarm_storage_service.dart';
import 'package:wake_arrival/common/services/location_service.dart';
import 'package:wake_arrival/common/services/distance_calculator_service.dart';
import 'package:wake_arrival/models/home/presentation/state/home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  StreamSubscription? _locationSubscription;

  HomeCubit() : super(const HomeState());

  // Load active alarm from storage
  Future<void> loadActiveAlarm() async {
    final alarm = await AlarmStorageService.getActiveAlarm();

    if (alarm != null) {
      emit(state.copyWith(activeAlarm: alarm));
      await _startLocationTracking();
    }
  }

  // Start tracking user location for real-time updates
  Future<void> _startLocationTracking() async {
    // Get initial location
    final currentLocation = await LocationService.getCurrentLocation();
    if (currentLocation != null) {
      emit(state.copyWith(currentLocation: currentLocation));
      _updateDistanceAndDuration(currentLocation);
    }

    // Subscribe to location updates
    _locationSubscription =
        LocationService.getLocationStream().listen((location) {
      if (location != null) {
        emit(state.copyWith(currentLocation: location));
        _updateDistanceAndDuration(location);
      }
    });
  }

  // Update distance and duration
  void _updateDistanceAndDuration(LatLng currentLocation) {
    if (state.activeAlarm != null) {
      final result = DistanceCalculatorService.getDistanceAndETA(
        currentLocation,
        LatLng(state.activeAlarm!.latitude, state.activeAlarm!.longitude),
      );
      emit(state.copyWith(
        distance: result['distance']!,
        duration: result['duration']!,
      ));
    }
  }

  // Delete active alarm
  Future<bool> deleteActiveAlarm() async {
    final deleted = await AlarmStorageService.deleteActiveAlarm();

    if (deleted) {
      await _stopLocationTracking();
      await GeofencingService.stopGeofencing();
      emit(const HomeState()); // Reset to initial state
    }

    return deleted;
  }

  // Stop location tracking
  Future<void> _stopLocationTracking() async {
    await _locationSubscription?.cancel();
    _locationSubscription = null;
  }

  @override
  Future<void> close() {
    _stopLocationTracking();
    return super.close();
  }
}
