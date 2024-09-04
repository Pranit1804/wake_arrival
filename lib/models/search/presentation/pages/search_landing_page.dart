import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:mapbox_search/mapbox_search.dart';
import 'package:wake_arrival/common/constants/app_constants.dart';
import 'package:wake_arrival/common/constants/layout_constants.dart';
import 'package:wake_arrival/common/theme/app_text_theme.dart';
import 'package:wake_arrival/models/routes/routes_constant.dart';
import 'package:latlong2/latlong.dart'; // For handling geographical coordinates

class SearchLandingPageArgs {
  final LatLng? searchedLatLng;

  SearchLandingPageArgs({this.searchedLatLng});
}

class SearchLandingPage extends StatefulWidget {
  final SearchLandingPageArgs args;
  const SearchLandingPage({super.key, required this.args});

  @override
  State<SearchLandingPage> createState() => _SearchLandingPageState();
}

class _SearchLandingPageState extends State<SearchLandingPage> {
  final ValueNotifier<List<Suggestion>> placesNotifier = ValueNotifier([]);

  SearchBoxAPI search = SearchBoxAPI(
    apiKey: AppConstants.mapBoxApiCode,
    limit: 6,
  );

  late double _radiusInPixels;
  late LatLng latLng;

  @override
  void initState() {
    super.initState();
    setLatLng();
    _radiusInPixels = _calculateRadiusInPixels(latLng);
  }

  void setLatLng() {
    latLng = widget.args.searchedLatLng != null
        ? LatLng(
            widget.args.searchedLatLng!.latitude,
            widget.args.searchedLatLng!.longitude,
          )
        : LatLng(19.0760, 72.8777);
  }

  void _updateCircleRadius(double zoom) {
    final double metersPerPixel =
        156543.03392 * cos(latLng.latitude * pi / 180) / pow(2, zoom);

    setState(() {
      _radiusInPixels = 1000 / metersPerPixel; // 1km in meters
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          FlutterMap(
            options: MapOptions(
              center: latLng,
              zoom: 15,
              onPositionChanged: (position, hasGesture) {
                _updateCircleRadius(position.zoom!);
              },
            ),
            children: [
              TileLayer(
                urlTemplate: AppConstants.mapBoxStyleTileUrl,
              ),
              CircleLayer(
                circles: [
                  CircleMarker(
                    point: latLng, // Center of the circle
                    radius: _radiusInPixels, // Radius in meters (1km)
                    color: Colors.blue.withOpacity(0.4),
                    borderStrokeWidth: 2,
                    borderColor: Colors.blue,
                  ),
                ],
              )
            ],
          ),
          Container(
            color: Colors.black.withOpacity(0.1),
          ),
          _clickableSearchBox(),
          // Container(
          //   color: Colors.black.withOpacity(0.5),
          // ),
          // Column(
          //   children: [
          //     Container(
          //       width: MediaQuery.of(context).size.width,
          //       margin: const EdgeInsets.only(top: 80, left: 20, right: 20),
          //       decoration: BoxDecoration(
          //         color: Colors.grey.withOpacity(0.4),
          //         borderRadius: BorderRadius.circular(4),
          //         border: Border.all(
          //           color: Colors.black.withOpacity(0.6),
          //           width: 1,
          //         ),
          //       ),
          //       child: PrimaryTextField(
          //         textEditingController: _textController,
          //         onTextChanged: onTextChanged,
          //       ),
          //     ),
          //     ValueListenableBuilder(
          //         valueListenable: placesNotifier,
          //         builder: (context, _, __) {
          //           return placesNotifier.value.isNotEmpty
          //               ? Container(
          //                   width: MediaQuery.of(context).size.width,
          //                   height: LayoutConstants.dimen_200,
          //                   color: Colors.grey.withOpacity(0.3),
          //                   margin: const EdgeInsets.only(left: 20, right: 20),
          //                   padding: const EdgeInsets.only(
          //                       left: 20, right: 20, top: 10),
          //                   child: Column(
          //                     mainAxisAlignment: MainAxisAlignment.start,
          //                     crossAxisAlignment: CrossAxisAlignment.start,
          //                     children: List.generate(
          //                       placesNotifier.value.length,
          //                       (index) => singleAutocompleteText(
          //                         title:
          //                             placesNotifier.value[index].placeName ??
          //                                 "",
          //                         subtitle: '',
          //                       ),
          //                     ),
          //                   ),
          //                 )
          //               : const Placeholder();
          //         }),
          //   ],
          // )
        ],
      ),
    );
  }

  double _calculateRadiusInPixels(LatLng latLng) {
    final double metersPerPixel = 156543.03392 *
        cos(latLng.latitude * pi / 180) /
        pow(2, 13); // 13 is the zoom level

    return (2000 / metersPerPixel);
  }

  Widget _clickableSearchBox() {
    return Positioned(
      top: LayoutConstants.dimen_80,
      left: 16,
      right: 16,
      child: GestureDetector(
        onTap: () {
          Navigator.pushNamed(context, RouteConstant.searchPage);
        },
        child: Container(
          width: double.infinity,
          height: LayoutConstants.dimen_50,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            border: Border.all(
              color: Colors.black.withOpacity(0.3),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                offset: const Offset(0, 6),
                spreadRadius: 8,
                blurRadius: 6,
              )
            ],
          ),
          child: Row(
            children: [
              const SizedBox(
                width: LayoutConstants.dimen_10,
              ),
              const Icon(
                Icons.search,
                color: Colors.white,
              ),
              const SizedBox(
                width: LayoutConstants.dimen_10,
              ),
              Text(
                'Search Destination',
                style: AppTextTheme.bodyText1.copyWith(
                  fontWeight: FontWeight.w600,
                  color: Colors.white.withOpacity(0.8),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void onTextChanged(String value) async {
    if (value.length % 3 == 0) {
      List<Suggestion>? places = await getPlaces(value);

      placesNotifier.value = [...places ?? []];
    }
  }

  Future<List<Suggestion>?> getPlaces(String value) async {
    ApiResponse<SuggestionResponse> searchPlace =
        await search.getSuggestions(value);
    return searchPlace.success?.suggestions;
  }

  Widget singleAutocompleteText({
    required String title,
    required String subtitle,
  }) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppTextTheme.bodyText1.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w700,
          ),
        ),
        Text(
          subtitle,
          style: AppTextTheme.caption.copyWith(
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}
