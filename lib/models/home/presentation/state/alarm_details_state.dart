import 'package:equatable/equatable.dart';
import 'package:latlong2/latlong.dart';
import 'package:wake_arrival/models/home/data/alarm_model.dart';

class AlarmDetailsState extends Equatable {
  final AlarmModel alarm;
  final LatLng? currentLocation;
  final String distance;
  final String duration;
  final String currentSpeed;

  const AlarmDetailsState({
    required this.alarm,
    required this.currentLocation,
    required this.distance,
    required this.duration,
    required this.currentSpeed,
  });

  AlarmDetailsState copyWith({
    AlarmModel? alarm,
    LatLng? currentLocation,
    String? distance,
    String? duration,
    String? currentSpeed,
  }) {
    return AlarmDetailsState(
      alarm: alarm ?? this.alarm,
      currentLocation: currentLocation ?? this.currentLocation,
      distance: distance ?? this.distance,
      duration: duration ?? this.duration,
      currentSpeed: currentSpeed ?? this.currentSpeed,
    );
  }

  @override
  List<Object?> get props => [
        alarm,
        currentLocation,
        distance,
        duration,
        currentSpeed,
      ];
}
