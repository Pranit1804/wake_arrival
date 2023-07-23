import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:mapbox_search/mapbox_search.dart';
import 'package:wake_arrival/common/constants/app_constants.dart';
import 'package:wake_arrival/common/constants/layout_constants.dart';
import 'package:wake_arrival/common/theme/app_text_theme.dart';
import 'package:wake_arrival/models/routes/routes_constant.dart';
import 'package:wake_arrival/models/search/search_routes.dart';

class SearchLandingPage extends StatefulWidget {
  const SearchLandingPage({super.key});

  @override
  State<SearchLandingPage> createState() => _SearchLandingPageState();
}

class _SearchLandingPageState extends State<SearchLandingPage> {
  final TextEditingController _textController = TextEditingController();

  final ValueNotifier<List<MapBoxPlace>> placesNotifier = ValueNotifier([]);

  var placesSearch = PlacesSearch(
    apiKey:
        'pk.eyJ1IjoicHJhbml0YmhvZ2FsZSIsImEiOiJja2Fka29rdG4wM3F5MnhveWtrcWl4bXZzIn0.PqBsfK3X0mNxQIFxmSm79g',
    limit: 5,
  );
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          FlutterMap(
            options: MapOptions(
              center: LatLng(19.0760, 72.8777),
              zoom: 12.6,
            ),
            children: [
              TileLayer(
                urlTemplate: AppConstants.mapBoxStyleTileUrl,
                userAgentPackageName: 'com.example.app',
              ),
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
      List<MapBoxPlace>? places = await getPlaces(value);
      placesNotifier.value = [...places ?? []];
    }
  }

  Future<List<MapBoxPlace>?> getPlaces(String value) async {
    List<MapBoxPlace>? places = await placesSearch.getPlaces(value);
    return places;
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
