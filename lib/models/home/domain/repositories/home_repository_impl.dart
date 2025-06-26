import 'package:wake_arrival/models/home/data/datasources/home_local_data_source.dart';
import 'package:wake_arrival/models/home/data/entity/home_geofencing_detail_entity.dart';
import 'package:wake_arrival/models/home/domain/repositories/home_repository.dart';

class HomeRepositoryImpl extends HomeRepository {
  final HomeLocalDataSource _homeLocalDataSource;

  HomeRepositoryImpl(this._homeLocalDataSource);

  @override
  HomeGeofencingDetailEntity? getOngoingGeoFencingDetail() {
    return _homeLocalDataSource.getOngoingGeoFencingDetail();
  }

  @override
  void removeOngoingTrip() {
    _homeLocalDataSource.removeOngoingTrip();
  }
}
