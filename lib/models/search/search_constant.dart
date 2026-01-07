import 'package:mapbox_search/generated_enums/poi_category.dart';

class SearchConstant {
  SearchConstant._();
  static const String change = 'Change';
  static const List<POICategory> poiCategories = [
    POICategory.publicTransportationStation,
    POICategory.railwayStation,
    POICategory.railwayPlatform,
    POICategory.busStation,
    POICategory.busStop,
    POICategory.taxi,

    // Airport & long-distance travel
    POICategory.airport,
    POICategory.airportTerminal,
    POICategory.airportGate,
    POICategory.baggageClaim,

    // Daily destination types
    POICategory.office,
    POICategory.coworkingSpace,
    POICategory.factory,
    POICategory.warehouse,

    // Home / stay
    POICategory.hotel,
    POICategory.hostel,
    POICategory.motel,
    POICategory.vacationRental,

    // Education
    POICategory.school,
    POICategory.college,
    POICategory.university,

    // Critical / high-importance arrivals
    POICategory.hospital,
    POICategory.medicalClinic,
    POICategory.emergencyRoom,

    // Public & civic landmarks (commonly used as stops)
    POICategory.governmentOffices,
    POICategory.courthouse,
    POICategory.townhall,
    POICategory.postOffice,

    // Large, easy-to-detect arrival points
    POICategory.shoppingMall,
    POICategory.stadium,
    POICategory.touristAttraction,
    POICategory.parkingLot,
    POICategory.restArea,
  ];
}
