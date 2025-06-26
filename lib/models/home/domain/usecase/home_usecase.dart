import 'package:wake_arrival/models/home/data/entity/home_geofencing_detail_entity.dart';
import 'package:wake_arrival/models/home/domain/repositories/home_repository.dart';

class HomeUsecase {
  final HomeRepository _homeRepository;

  HomeUsecase(this._homeRepository);

  HomeGeofencingDetailEntity? getOngoingGeoFencingDetail() {
    return _homeRepository.getOngoingGeoFencingDetail();
  }

  void removeOngoingTrip() {
    _homeRepository.removeOngoingTrip();
  }
}
