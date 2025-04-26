import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:mapbox_search/mapbox_search.dart';
import 'package:wake_arrival/common/constants/app_constants.dart';
import 'package:wake_arrival/common/constants/layout_constants.dart';
import 'package:wake_arrival/common/theme/app_text_theme.dart';
import 'package:wake_arrival/common/widgets/custom_map.dart';
import 'package:wake_arrival/common/widgets/primary_button.dart';
import 'package:wake_arrival/models/routes/routes_constant.dart';

class SearchLandingPageArgs {
  final LatLng searchedLatLng;
  final String titleAddress;
  final String subtitleAddress;

  SearchLandingPageArgs({
    required this.searchedLatLng,
    required this.titleAddress,
    required this.subtitleAddress,
  });
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

  late LatLng latLng;

  @override
  void initState() {
    super.initState();
    setLatLng();
  }

  void setLatLng() {
    latLng = widget.args.searchedLatLng;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          CustomMap(
              initialPosition: latLng,
              onLocationChange: (position) {
                latLng = position;
              }),
          Container(
            color: Colors.black.withValues(alpha: 0.1),
          ),
          _clickableSearchBox(),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: LayoutConstants.dimen_160,
              width: double.infinity,
              padding: const EdgeInsets.all(LayoutConstants.dimen_16),
              decoration: const BoxDecoration(color: Colors.white),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Icon(Icons.pin_drop),
                      Text(
                        widget.args.titleAddress,
                        style: AppTextTheme.headline6,
                      ),
                    ],
                  ),
                  Text(widget.args.subtitleAddress),
                  const Spacer(),
                  const PrimaryButton(title: 'Confirm')
                ],
              ),
            ),
          )
        ],
      ),
    );
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
            color: Colors.white.withValues(alpha: 0.2),
            border: Border.all(
              color: Colors.black.withValues(alpha: 0.2),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
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
                  color: Colors.white.withValues(alpha: 0.8),
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
