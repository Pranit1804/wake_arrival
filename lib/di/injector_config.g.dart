// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'injector_config.dart';

// **************************************************************************
// KiwiInjectorGenerator
// **************************************************************************

class _$InjectorConfig extends InjectorConfig {
  @override
  void _configureBlocs() {
    final KiwiContainer container = KiwiContainer();
    container
      ..registerFactory(
          (c) => SearchBloc(searchUsecase: c.resolve<SearchUsecase>()))
      ..registerFactory((c) => HomeBloc(homeUsecase: c.resolve<HomeUsecase>()));
  }

  @override
  void _configureUseCases() {
    final KiwiContainer container = KiwiContainer();
    container
      ..registerFactory((c) => SearchUsecase(c.resolve<SearchRepository>()))
      ..registerFactory((c) => HomeUsecase(c.resolve<HomeRepository>()));
  }

  @override
  void _configureRepositories() {
    final KiwiContainer container = KiwiContainer();
    container
      ..registerFactory<SearchRepository>(
          (c) => SearchRepositoryImpl(c.resolve<SearchLocalDataSource>()))
      ..registerFactory<HomeRepository>(
          (c) => HomeRepositoryImpl(c.resolve<HomeLocalDataSource>()));
  }

  @override
  void _configureRemoteDataSources() {
    final KiwiContainer container = KiwiContainer();
    container.registerFactory((c) => SearchRemoteDataSource());
  }

  @override
  void _configureLocalDataSource() {
    final KiwiContainer container = KiwiContainer();
    container
      ..registerFactory((c) => SearchLocalDataSource())
      ..registerFactory((c) => HomeLocalDataSource());
  }
}
