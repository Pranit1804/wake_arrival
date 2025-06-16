import 'package:kiwi/kiwi.dart';
import 'package:wake_arrival/models/search/data/datasources/search_local_data_source.dart';
import 'package:wake_arrival/models/search/data/datasources/search_remote_data_source.dart';
import 'package:wake_arrival/models/search/data/repositories/search_repository_impl.dart';
import 'package:wake_arrival/models/search/domain/repositories/search_repository.dart';
import 'package:wake_arrival/models/search/domain/usecase/search_usecase.dart';
import 'package:wake_arrival/models/search/presentation/state/search_bloc.dart';

part 'injector_config.g.dart';

abstract class InjectorConfig {
  static late KiwiContainer container;

  static setUp() {
    container = KiwiContainer();
    final injector = _$InjectorConfig();
    injector._configure();
  }

  static final resolve = container.resolve;

  void _configure() {
    _configureBlocs();
    _configureUseCases();
    _configureRepositories();
    _configureRemoteDataSources();
    _configureLocalDataSource();
  }

  @Register.singleton(SearchBloc)
  void _configureBlocs();

  @Register.factory(SearchUsecase)
  void _configureUseCases();

  @Register.factory(SearchRepository, from: SearchRepositoryImpl)
  void _configureRepositories();

  @Register.factory(SearchRemoteDataSource)
  void _configureRemoteDataSources();

  @Register.factory(SearchLocalDataSource)
  void _configureLocalDataSource();
}
