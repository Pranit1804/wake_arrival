import 'dart:async';

import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:mapbox_search/mapbox_search.dart';
import 'package:wake_arrival/common/constants/app_constants.dart';
import 'package:wake_arrival/common/constants/layout_constants.dart';
import 'package:wake_arrival/common/theme/app_color.dart';
import 'package:wake_arrival/common/theme/app_text_theme.dart';
import 'package:wake_arrival/common/widgets/primary_text_field.dart';
import 'package:wake_arrival/models/routes/routes_constant.dart';
import 'package:wake_arrival/models/search/presentation/pages/search_landing_page.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  late SearchBoxAPI placesSearch;
  final ValueNotifier<List<SuggestedPlace>> placesNotifier = ValueNotifier([]);
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
          Container(
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
                  color: AppColor.primaryDarkColor.withOpacity(0.8),
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
          ),
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
                                  (index) => Column(
                                        children: [
                                          InkWell(
                                            onTap: () async {
                                              final place = await placesSearch
                                                  .getPlace(placesNotifier
                                                      .value[index].id);

                                              Navigator.pushNamed(
                                                context,
                                                RouteConstant.searchLandingPage,
                                                arguments:
                                                    SearchLandingPageArgs(
                                                  searchedLatLng: LatLng(
                                                    place
                                                        .success!
                                                        .features[0]
                                                        .geometry
                                                        .coordinates
                                                        .lat,
                                                    place
                                                        .success!
                                                        .features[0]
                                                        .geometry
                                                        .coordinates
                                                        .long,
                                                  ),
                                                  titleAddress: placesNotifier
                                                      .value[index]
                                                      .mainLocation,
                                                  subtitleAddress:
                                                      placesNotifier
                                                          .value[index]
                                                          .completeAddress,
                                                ),
                                              );
                                            },
                                            child: singleAutocompleteText(
                                              title: placesNotifier
                                                  .value[index].mainLocation,
                                              subtitle: placesNotifier
                                                  .value[index].completeAddress,
                                            ),
                                          ),
                                          const SizedBox(
                                            height: LayoutConstants.dimen_12,
                                          ),
                                          Container(
                                            height: 1,
                                            width: LayoutConstants.dimen_350,
                                            margin: const EdgeInsets.only(
                                                left: LayoutConstants.dimen_24),
                                            color:
                                                Colors.white.withOpacity(0.1),
                                          )
                                        ],
                                      )),
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

  void onTextChanged(String value) async {
    if (value.isEmpty) {
      placesNotifier.value = [];
    }
    if (value.length % 2 == 0) {
      List<SuggestedPlace>? places = await getPlaces(value);
      placesNotifier.value = [...places ?? []];
    }
  }

  Future<List<SuggestedPlace>?> getPlaces(String value) async {
    ApiResponse<SuggestionResponse> places = await placesSearch.getSuggestions(
      value,
      proximity: Proximity.LatLong(lat: 19.0596, long: 72.8295),
    );

    List<SuggestedPlace> placemarks = [];
    for (var place in places.success!.suggestions) {
      placemarks.add(SuggestedPlace(
          id: place.mapboxId,
          mainLocation: place.name,
          completeAddress: place.placeFormatted,
          location: const LatLng(
            19.312213,
            19.12315,
          )));
    }
    return placemarks;
  }

  Widget singleAutocompleteText({
    required String? title,
    required String? subtitle,
  }) {
    return Row(
      children: [
        Container(
          height: 24,
          width: 24,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: AppColor.primaryDarkColor,
          ),
          child: Icon(
            Icons.location_pin,
            color: Colors.white.withOpacity(0.5),
            size: 12,
          ),
        ),
        const SizedBox(
          width: LayoutConstants.dimen_8,
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title ?? "",
              style: AppTextTheme.bodyText1.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              subtitle ?? "",
              style: AppTextTheme.caption.copyWith(
                color: Colors.white,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ],
    );
  }
}

class SuggestedPlace {
  final String id;
  final String mainLocation;
  final String completeAddress;
  final LatLng location;

  SuggestedPlace({
    required this.id,
    required this.mainLocation,
    required this.completeAddress,
    required this.location,
  });
}
