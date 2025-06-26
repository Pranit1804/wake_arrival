import 'package:wake_arrival/models/home/data/entity/home_geofencing_detail_entity.dart';

abstract class SearchRepository {
  void saveGeoFencingData(HomeGeofencingDetailEntity geoFencingEntity);
}
