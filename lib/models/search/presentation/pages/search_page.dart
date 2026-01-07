import 'dart:async';
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:mapbox_search/mapbox_search.dart';
import 'package:wake_arrival/common/constants/app_constants.dart';
import 'package:wake_arrival/common/theme/app_color.dart';
import 'package:wake_arrival/common/widgets/glassmorphic_search_bar.dart';
import 'package:wake_arrival/common/widgets/location_result_card.dart';
import 'package:wake_arrival/common/widgets/search_loading_shimmer.dart';
import 'package:wake_arrival/common/widgets/search_empty_state.dart';
import 'package:wake_arrival/models/routes/routes_constant.dart';
import 'package:wake_arrival/models/search/presentation/pages/location_page.dart';
import 'package:wake_arrival/models/search/search_constant.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  late SearchBoxAPI placesSearch;
  final ValueNotifier<List<WKSuggestedPlace>> placesNotifier =
      ValueNotifier([]);
  final ValueNotifier<bool> isLoadingNotifier = ValueNotifier(false);
  final TextEditingController _textController = TextEditingController();
  String searchedText = '';
  Timer? _debounceTimer;

  @override
  void initState() {
    super.initState();
    placesSearch = SearchBoxAPI(
      apiKey: AppConstants.mapBoxApiCode,
      limit: 5,
    );
    _textController.addListener(_onSearchTextChanged);
  }

  void _onSearchTextChanged() {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 400), () {
      if (_textController.text != searchedText) {
        onTextChanged(_textController.text);
        searchedText = _textController.text;
      }
    });
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    _textController.dispose();
    placesNotifier.dispose();
    isLoadingNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppColor.backgroundGradientStart,
              AppColor.backgroundGradientEnd,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(),
              Expanded(
                child: _buildSearchResults(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              IconButton(
                icon: const Icon(
                  Icons.arrow_back_ios,
                  color: AppColor.primaryTextColor,
                  size: 20,
                ),
                onPressed: () => Navigator.pop(context),
              ),
              const Expanded(
                child: Text(
                  'Search Destination',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: AppColor.primaryTextColor,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          GlassmorphicSearchBar(
            controller: _textController,
            onClear: () {
              _textController.clear();
              placesNotifier.value = [];
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSearchResults() {
    return ValueListenableBuilder(
      valueListenable: isLoadingNotifier,
      builder: (context, isLoading, _) {
        if (isLoading) {
          return const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: SearchLoadingShimmer(),
          );
        }

        return ValueListenableBuilder(
          valueListenable: placesNotifier,
          builder: (context, places, _) {
            if (_textController.text.isEmpty) {
              return const SearchEmptyState(
                message: 'Start typing to search',
              );
            }

            if (places.isEmpty && _textController.text.isNotEmpty) {
              return const SearchEmptyState();
            }

            return ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: places.length,
              itemBuilder: (context, index) {
                final place = places[index];
                return LocationResultCard(
                  title: place.mainLocation,
                  subtitle: place.completeAddress,
                  onTap: () => _navigateToLocation(place),
                );
              },
            );
          },
        );
      },
    );
  }

  void _navigateToLocation(WKSuggestedPlace place) {
    Navigator.pushNamed(
      context,
      RouteConstant.searchLandingPage,
      arguments: LocationPageArgs(
        searchedLatLng: place.location,
        address: place.getAddress,
      ),
    );
  }

  void onTextChanged(String value) async {
    if (value.isEmpty) {
      placesNotifier.value = [];
      isLoadingNotifier.value = false;
      return;
    }

    if (value.length >= 2) {
      isLoadingNotifier.value = true;
      try {
        List<WKSuggestedPlace>? places = await getPlaces(value);
        placesNotifier.value = places ?? [];
      } catch (e) {
        placesNotifier.value = [];
      } finally {
        isLoadingNotifier.value = false;
      }
    }
  }

  Future<List<WKSuggestedPlace>?> getPlaces(String value) async {
    ApiResponse<SuggestionResponse> places = await placesSearch.getSuggestions(
      value,
      proximity: Proximity.LatLong(lat: 19.0596, long: 72.8295),
      poi: SearchConstant.poiCategories,
    );

    List<WKSuggestedPlace> placemarks = [];
    for (var place in places.success!.suggestions) {
      final retrieveResponse = await placesSearch.getPlace(place.mapboxId);
      final coordinates =
          retrieveResponse.success!.features[0].geometry.coordinates;
      placemarks.add(WKSuggestedPlace(
        id: place.mapboxId,
        mainLocation: place.name,
        completeAddress: place.placeFormatted,
        location: LatLng(coordinates.lat, coordinates.long),
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
