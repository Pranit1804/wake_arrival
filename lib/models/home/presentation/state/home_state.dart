import 'package:equatable/equatable.dart';
import 'package:latlong2/latlong.dart';
import 'package:wake_arrival/models/home/data/alarm_model.dart';

class HomeState extends Equatable {
  final AlarmModel? activeAlarm;
  final LatLng? currentLocation;
  final String distance;
  final String duration;

  const HomeState({
    this.activeAlarm,
    this.currentLocation,
    this.distance = '--',
    this.duration = '--',
  });

  bool get hasActiveAlarm => activeAlarm != null;

  HomeState copyWith({
    AlarmModel? activeAlarm,
    LatLng? currentLocation,
    String? distance,
    String? duration,
  }) {
    return HomeState(
      activeAlarm: activeAlarm ?? this.activeAlarm,
      currentLocation: currentLocation ?? this.currentLocation,
      distance: distance ?? this.distance,
      duration: duration ?? this.duration,
    );
  }

  @override
  List<Object?> get props => [activeAlarm, currentLocation, distance, duration];
}
