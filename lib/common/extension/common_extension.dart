import 'package:latlong2/latlong.dart';
import 'package:mapbox_search/models/retrieve_response.dart';

extension LatLngExt on RetrieveResonse {
  LatLng get getLatLong {
    return LatLng(features[0].geometry.coordinates.lat,
        features[0].geometry.coordinates.long);
  }
}
