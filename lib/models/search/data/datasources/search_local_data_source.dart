import 'package:wake_arrival/common/local_database/object_box.dart';
import 'package:wake_arrival/models/home/data/entity/home_geofencing_detail_entity.dart';

class SearchLocalDataSource {
  void saveGeoFencingData(HomeGeofencingDetailEntity geoFencingEntity) {
    ObjectBox.getHomeGeofencingDetailEntity().removeAll();
    ObjectBox.getHomeGeofencingDetailEntity().put(geoFencingEntity);
  }
}
