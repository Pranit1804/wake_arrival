import 'dart:async';

import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:mapbox_search/mapbox_search.dart';
import 'package:wake_arrival/common/constants/app_constants.dart';
import 'package:wake_arrival/common/constants/layout_constants.dart';
import 'package:wake_arrival/common/extension/common_extension.dart';
import 'package:wake_arrival/common/theme/app_color.dart';
import 'package:wake_arrival/common/widgets/primary_text_field.dart';
import 'package:wake_arrival/models/routes/routes_constant.dart';
import 'package:wake_arrival/models/search/presentation/pages/location_page.dart';
import 'package:wake_arrival/models/search/presentation/widgets/single_auto_complete_widget.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  late SearchBoxAPI placesSearch;
  final ValueNotifier<List<WKSuggestedPlace>> placesNotifier =
      ValueNotifier([]);
  final TextEditingController _textController = TextEditingController();
  String searchedText = '';
  @override
  void initState() {
    super.initState();
    placesSearch = SearchBoxAPI(
      apiKey: AppConstants.mapBoxApiCode,
      limit: 5,
    );
    Timer.periodic(const Duration(milliseconds: 400), (timer) {
      if (_textController.text != searchedText) {
        onTextChanged(_textController.text);
        searchedText = _textController.text;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.primaryDarkColor,
      body: Column(
        children: [
          _buildSearchBox(),
          const SizedBox(
            height: LayoutConstants.dimen_12,
          ),
          Container(
            height: MediaQuery.of(context).size.height * 0.6,
            width: double.infinity,
            color: AppColor.primaryColor,
            padding: const EdgeInsets.symmetric(
              horizontal: LayoutConstants.dimen_12,
              vertical: LayoutConstants.dimen_20,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [],
                ),
                ValueListenableBuilder(
                    valueListenable: placesNotifier,
                    builder: (context, _, __) {
                      return placesNotifier.value.isNotEmpty
                          ? Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: List.generate(
                                  placesNotifier.value.length,
                                  (index) => _buildAdressTile(index)),
                            )
                          : Container();
                    }),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildSearchBox() {
    return Container(
      height: LayoutConstants.dimen_130,
      width: double.infinity,
      color: AppColor.primaryColor,
      padding: const EdgeInsets.only(
        top: LayoutConstants.dimen_60,
        bottom: LayoutConstants.dimen_10,
      ),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            height: LayoutConstants.dimen_55,
            color: AppColor.primaryDarkColor.withValues(alpha: .8),
            margin: const EdgeInsets.symmetric(
              horizontal: LayoutConstants.dimen_10,
            ),
            child: PrimaryTextField(
              textEditingController: _textController,
              onTextChanged: (_) {},
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAdressTile(int index) {
    return Column(
      children: [
        InkWell(
          onTap: () async {
            WKSuggestedPlace place = placesNotifier.value[index];
            Navigator.pushNamed(
              context,
              RouteConstant.searchLandingPage,
              arguments: LocationPageArgs(
                  searchedLatLng: place.location, address: place.getAddress),
            );
          },
          child: SingleAutoCompleteWidget(
            address: placesNotifier.value[index].getAddress,
          ),
        ),
        const SizedBox(
          height: LayoutConstants.dimen_12,
        ),
        Container(
          height: 1,
          width: LayoutConstants.dimen_350,
          margin: const EdgeInsets.only(left: LayoutConstants.dimen_24),
          color: Colors.white.withValues(alpha: .1),
        )
      ],
    );
  }

  void onTextChanged(String value) async {
    if (value.isEmpty) {
      placesNotifier.value = [];
    }
    if (value.length % 2 == 0) {
      List<WKSuggestedPlace>? places = await getPlaces(value);
      placesNotifier.value = places ?? [];
    }
  }

  Future<List<WKSuggestedPlace>?> getPlaces(String value) async {
    ApiResponse<SuggestionResponse> places = await placesSearch.getSuggestions(
      value,
      proximity: Proximity.LatLong(lat: 19.0596, long: 72.8295),
    );

    List<WKSuggestedPlace> placemarks = [];
    for (var place in places.success!.suggestions) {
      final latLong = await placesSearch.getPlace(place.mapboxId);
      placemarks.add(WKSuggestedPlace(
        id: place.mapboxId,
        mainLocation: place.name,
        completeAddress: place.placeFormatted,
        location: latLong.success!.getLatLong,
      ));
    }
    return placemarks;
  }
}

class WKSuggestedPlace {
  final String id;
  final String mainLocation;
  final String completeAddress;
  final LatLng location;

  WKSuggestedPlace({
    required this.id,
    required this.mainLocation,
    required this.completeAddress,
    required this.location,
  });

  LocationAddress get getAddress {
    return LocationAddress(
      titleAddress: mainLocation,
      subtitleAddress: completeAddress,
    );
  }
}
