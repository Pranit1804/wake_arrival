import 'package:wake_arrival/models/home/data/entity/home_geofencing_detail_entity.dart';
import 'package:wake_arrival/models/search/data/datasources/search_local_data_source.dart';
import 'package:wake_arrival/models/search/domain/repositories/search_repository.dart';

class SearchRepositoryImpl implements SearchRepository {
  final SearchLocalDataSource _searchLocalDataSource;

  SearchRepositoryImpl(this._searchLocalDataSource);

  @override
  void saveGeoFencingData(HomeGeofencingDetailEntity geoFencingEntity) {
    _searchLocalDataSource.saveGeoFencingData(geoFencingEntity);
  }
}
