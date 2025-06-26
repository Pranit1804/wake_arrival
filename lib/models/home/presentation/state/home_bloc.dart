import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wake_arrival/models/home/data/entity/home_geofencing_detail_entity.dart';
import 'package:wake_arrival/models/home/domain/usecase/home_usecase.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final HomeUsecase _homeUsecase;

  HomeBloc({
    required HomeUsecase homeUsecase,
  })  : _homeUsecase = homeUsecase,
        super(HomeInitialState()) {
    on<GetOngoingGeoFencingEvent>(_onGetOngoingGeoFencingEvent);
    on<DeleteOngoingTripEvent>(_onDeleteOngoingTripEvent);
  }

  void _onDeleteOngoingTripEvent(DeleteOngoingTripEvent event, Emitter emit) {
    try {
      _homeUsecase.removeOngoingTrip();
      emit(DeleteOngoingTripSuccess());
    } catch (e) {}
  }

  void _onGetOngoingGeoFencingEvent(
      GetOngoingGeoFencingEvent event, Emitter emit) {
    try {
      HomeGeofencingDetailEntity? detail =
          _homeUsecase.getOngoingGeoFencingDetail();
      emit(GetOngoingGeoFencingSuccess(detail));
    } catch (e) {
      emit(GetOngoingGeoFencingFailure());
    }
  }
}
