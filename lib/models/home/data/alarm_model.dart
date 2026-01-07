import 'package:objectbox/objectbox.dart';

@Entity()
class AlarmModel {
  @Id()
  int id;

  String destinationName;
  String address;
  double latitude;
  double longitude;

  @Property(type: PropertyType.date)
  DateTime createdAt;

  bool isActive;

  AlarmModel({
    this.id = 0,
    required this.destinationName,
    required this.address,
    required this.latitude,
    required this.longitude,
    required this.createdAt,
    this.isActive = true,
  });

  // Helper to create from LatLng
  factory AlarmModel.fromLocation({
    required String destinationName,
    required String address,
    required double latitude,
    required double longitude,
  }) {
    return AlarmModel(
      destinationName: destinationName,
      address: address,
      latitude: latitude,
      longitude: longitude,
      createdAt: DateTime.now(),
    );
  }
}
