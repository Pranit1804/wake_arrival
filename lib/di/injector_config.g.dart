// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'injector_config.dart';

// **************************************************************************
// KiwiInjectorGenerator
// **************************************************************************

class _$InjectorConfig extends InjectorConfig {
  @override
  void _configureBlocs() {
    final KiwiContainer container = KiwiContainer();
    container.registerSingleton(
        (c) => SearchBloc(searchUsecase: c.resolve<SearchUsecase>()));
  }

  @override
  void _configureUseCases() {
    final KiwiContainer container = KiwiContainer();
    container.registerFactory((c) => SearchUsecase());
  }

  @override
  void _configureRepositories() {
    final KiwiContainer container = KiwiContainer();
    container.registerFactory<SearchRepository>((c) => SearchRepositoryImpl());
  }

  @override
  void _configureRemoteDataSources() {
    final KiwiContainer container = KiwiContainer();
    container.registerFactory((c) => SearchRemoteDataSource());
  }

  @override
  void _configureLocalDataSource() {
    final KiwiContainer container = KiwiContainer();
    container.registerFactory((c) => SearchLocalDataSource());
  }
}
