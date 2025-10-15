import 'package:latlong2/latlong.dart';
import 'package:objectbox/objectbox.dart';
import 'package:wake_arrival/models/search/presentation/pages/location_page.dart';

@Entity()
class HomeGeofencingDetailEntity {
  int? id;
  final double lat;
  final double long;
  final String locationTitle;
  final String locationSubtitle;

  HomeGeofencingDetailEntity(
    this.lat,
    this.long,
    this.locationTitle,
    this.locationSubtitle, {
    this.id,
  });

  factory HomeGeofencingDetailEntity.fromLocationAddress(
          LatLng latlng, LocationAddress address) =>
      HomeGeofencingDetailEntity(
        latlng.latitude,
        latlng.longitude,
        address.titleAddress,
        address.subtitleAddress,
      );

  LatLng get latLng => LatLng(lat, long);
}
