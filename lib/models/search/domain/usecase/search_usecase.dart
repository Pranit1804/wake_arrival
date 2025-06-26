import 'package:latlong2/latlong.dart';
import 'package:wake_arrival/common/services/geofencing_service.dart';
import 'package:wake_arrival/models/home/data/entity/home_geofencing_detail_entity.dart';
import 'package:wake_arrival/models/search/domain/repositories/search_repository.dart';
import 'package:wake_arrival/models/search/presentation/pages/location_page.dart';

class SearchUsecase {
  final SearchRepository _searchRepository;

  SearchUsecase(this._searchRepository);
  Future<bool> initiateGeoFencing(
    LatLng latlng,
    LocationAddress address,
  ) async {
    bool geoFencingEnabled = await GeofencingService.initPlatformState(latlng);
    _searchRepository.saveGeoFencingData(
      HomeGeofencingDetailEntity.fromLocationAddress(latlng, address),
    );
    return geoFencingEnabled;
  }
}
