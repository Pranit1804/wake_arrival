part of 'home_bloc.dart';

abstract class HomeState {}

class HomeInitialState extends HomeState {}

class GetOngoingGeoFencingSuccess extends HomeState {
  final HomeGeofencingDetailEntity? data;

  GetOngoingGeoFencingSuccess(this.data);
}

class GetOngoingGeoFencingFailure extends HomeState {}

class DeleteOngoingTripSuccess extends HomeState {}
