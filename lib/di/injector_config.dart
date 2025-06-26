import 'package:kiwi/kiwi.dart';
import 'package:wake_arrival/models/home/data/datasources/home_local_data_source.dart';
import 'package:wake_arrival/models/home/domain/repositories/home_repository.dart';
import 'package:wake_arrival/models/home/domain/repositories/home_repository_impl.dart';
import 'package:wake_arrival/models/home/domain/usecase/home_usecase.dart';
import 'package:wake_arrival/models/home/presentation/state/home_bloc.dart';
import 'package:wake_arrival/models/search/data/datasources/search_local_data_source.dart';
import 'package:wake_arrival/models/search/data/datasources/search_remote_data_source.dart';
import 'package:wake_arrival/models/search/domain/repositories/search_repository_impl.dart';
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

  @Register.factory(SearchBloc)
  @Register.factory(HomeBloc)
  void _configureBlocs();

  @Register.factory(SearchUsecase)
  @Register.factory(HomeUsecase)
  void _configureUseCases();

  @Register.factory(SearchRepository, from: SearchRepositoryImpl)
  @Register.factory(HomeRepository, from: HomeRepositoryImpl)
  void _configureRepositories();

  @Register.factory(SearchRemoteDataSource)
  void _configureRemoteDataSources();

  @Register.factory(SearchLocalDataSource)
  @Register.factory(HomeLocalDataSource)
  void _configureLocalDataSource();
}
