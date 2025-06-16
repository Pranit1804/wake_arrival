import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wake_arrival/models/search/domain/usecase/search_usecase.dart';

part 'search_event.dart';
part 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final SearchUsecase _searchUsecase;
  SearchBloc({
    required SearchUsecase searchUsecase,
  })  : _searchUsecase = searchUsecase,
        // _profileUseCase = profileUseCase,
        super(SearchInitalState()) {}
}
