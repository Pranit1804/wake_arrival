import 'package:flutter/material.dart';
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
  final ValueNotifier<List<MapBoxPlace>> placesNotifier = ValueNotifier([]);
  final TextEditingController _textController = TextEditingController();

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
                    onTextChanged: onTextChanged,
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
              horizontal: LayoutConstants.dimen_24,
              vertical: LayoutConstants.dimen_20,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                singleAutocompleteText(
                  title: 'WhiteField',
                  subtitle: 'Banglore',
                ),
                ValueListenableBuilder(
                    valueListenable: placesNotifier,
                    builder: (context, _, __) {
                      return placesNotifier.value.isNotEmpty
                          ? Container(
                              width: MediaQuery.of(context).size.width,
                              height: LayoutConstants.dimen_200,
                              color: Colors.grey.withOpacity(0.3),
                              margin:
                                  const EdgeInsets.only(left: 20, right: 20),
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
    );
  }
}
