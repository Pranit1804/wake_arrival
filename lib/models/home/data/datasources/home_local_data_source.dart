import 'package:wake_arrival/common/local_database/object_box.dart';
import 'package:wake_arrival/models/home/data/entity/home_geofencing_detail_entity.dart';

class HomeLocalDataSource {
  HomeGeofencingDetailEntity? getOngoingGeoFencingDetail() {
    List<HomeGeofencingDetailEntity> geoFencing =
        ObjectBox.getHomeGeofencingDetailEntity().getAll();
    if (geoFencing.isEmpty) return null;
    return geoFencing.first;
  }

  void removeOngoingTrip() {
    ObjectBox.getHomeGeofencingDetailEntity().removeAll();
  }
}
