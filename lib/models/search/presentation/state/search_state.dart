// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'search_bloc.dart';

class SearchState {}

class SearchInitalState extends SearchState {}

class GeoFencingInitiatedState extends SearchState {
  bool isGeoFencingEnabled;
  GeoFencingInitiatedState(this.isGeoFencingEnabled);
}

class GeoFencingInitatedFailureState extends SearchState {}
