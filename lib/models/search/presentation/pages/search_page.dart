import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:mapbox_search/mapbox_search.dart';
import 'package:wake_arrival/common/constants/app_constants.dart';
import 'package:wake_arrival/common/constants/layout_constants.dart';
import 'package:wake_arrival/common/theme/app_color.dart';
import 'package:wake_arrival/common/theme/app_text_theme.dart';
import 'package:wake_arrival/common/widgets/primary_text_field.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  var placesSearch = PlacesSearch(
    apiKey: AppConstants.mapBoxApiCode,
    limit: 5,
  );
  final ValueNotifier<List<Placemark>> placesNotifier = ValueNotifier([]);
  final TextEditingController _textController = TextEditingController();
  String searchedText = '';
  @override
  void initState() {
    super.initState();

    Timer.periodic(const Duration(seconds: 2), (timer) {
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
            height: MediaQuery.of(context).size.height * 0.15,
            width: double.infinity,
            color: AppColor.primaryColor,
            child: Column(
              children: [
                const SizedBox(
                  height: LayoutConstants.dimen_70,
                ),
                Container(
                  width: double.infinity,
                  height: LayoutConstants.dimen_50,
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
                Column(
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
                                          singleAutocompleteText(
                                            title: placesNotifier
                                                    .value[index].name ??
                                                "",
                                            subtitle: placesNotifier
                                                    .value[index].locality ??
                                                "",
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
      List<Placemark>? places = await getPlaces(value);
      placesNotifier.value = [...places ?? []];
    }
  }

  Future<List<Placemark>?> getPlaces(String value) async {
    List<MapBoxPlace>? places = await placesSearch.getPlaces(value);
    List<Placemark> placemarks = [];
    for (var element in places!) {
      Placemark place =
          await placemarkFromCoordinates(element.center![1], element.center![0])
              .then(
        (value) => value[0],
      );
      placemarks.add(place);
    }
    return placemarks;
  }

  Widget singleAutocompleteText({
    required String title,
    required String subtitle,
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
              title,
              style: AppTextTheme.bodyText1.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              subtitle,
              style: AppTextTheme.caption.copyWith(
                color: Colors.white,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
