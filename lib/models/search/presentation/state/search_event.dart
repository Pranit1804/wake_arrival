// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'search_bloc.dart';

class SearchEvent {}

class ConfirmLocationEvent extends SearchEvent {
  LatLng latLng;
  LocationAddress address;
  ConfirmLocationEvent({required this.latLng, required this.address});
}
