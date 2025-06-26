import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:latlong2/latlong.dart';
import 'package:wake_arrival/models/search/domain/usecase/search_usecase.dart';
import 'package:wake_arrival/models/search/presentation/pages/location_page.dart';

part 'search_event.dart';
part 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final SearchUsecase _searchUsecase;
  SearchBloc({
    required SearchUsecase searchUsecase,
  })  : _searchUsecase = searchUsecase,
        // _profileUseCase = profileUseCase,
        super(SearchInitalState()) {
    on<ConfirmLocationEvent>(_onConfirmLocationEvent);
  }

  void _onConfirmLocationEvent(ConfirmLocationEvent event, Emitter emit) async {
    try {
      bool geoFencingEnabled =
          await _searchUsecase.initiateGeoFencing(event.latLng, event.address);
      emit(GeoFencingInitiatedState(geoFencingEnabled));
    } catch (e) {
      emit(GeoFencingInitatedFailureState());
    }
  }
}
