import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:mapbox_search/mapbox_search.dart';
import 'package:wake_arrival/common/constants/layout_constants.dart';
import 'package:wake_arrival/common/theme/app_text_theme.dart';
import 'package:wake_arrival/common/widgets/primary_text_field.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
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
              center: LatLng(51.509364, -0.128928),
              zoom: 9.2,
            ),
            children: [
              TileLayer(
                urlTemplate:
                    'https://api.mapbox.com/styles/v1/pranitbhogale/cke2tyj8n0tl319o6e4blx5k0/tiles/256/{z}/{x}/{y}@2x?access_token=pk.eyJ1IjoicHJhbml0YmhvZ2FsZSIsImEiOiJja2Fka29rdG4wM3F5MnhveWtrcWl4bXZzIn0.PqBsfK3X0mNxQIFxmSm79g',
                userAgentPackageName: 'com.example.app',
              ),
            ],
          ),
          Container(
            color: Colors.black.withOpacity(0.5),
          ),
          Column(
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                margin: const EdgeInsets.only(top: 80, left: 20, right: 20),
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.4),
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(
                    color: Colors.black.withOpacity(0.6),
                    width: 1,
                  ),
                ),
                child: PrimaryTextField(
                  textEditingController: _textController,
                  onTextChanged: onTextChanged,
                ),
              ),
              ValueListenableBuilder(
                  valueListenable: placesNotifier,
                  builder: (context, _, __) {
                    return placesNotifier.value.isNotEmpty
                        ? Container(
                            width: MediaQuery.of(context).size.width,
                            height: LayoutConstants.dimen_200,
                            color: Colors.grey.withOpacity(0.3),
                            margin: const EdgeInsets.only(left: 20, right: 20),
                            padding: const EdgeInsets.only(
                                left: 20, right: 20, top: 10),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: List.generate(
                                placesNotifier.value.length,
                                (index) => singleAutocompleteText(
                                  title:
                                      placesNotifier.value[index].placeName ??
                                          "",
                                  subtitle: '',
                                ),
                              ),
                            ),
                          )
                        : const Placeholder();
                  }),
            ],
          )
        ],
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
