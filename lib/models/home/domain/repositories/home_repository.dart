import 'package:wake_arrival/models/home/data/entity/home_geofencing_detail_entity.dart';

abstract class HomeRepository {
  HomeGeofencingDetailEntity? getOngoingGeoFencingDetail();
  void removeOngoingTrip();
}
