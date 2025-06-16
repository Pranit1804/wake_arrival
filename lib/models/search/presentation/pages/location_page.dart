import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:latlong2/latlong.dart';
import 'package:mapbox_search/mapbox_search.dart';
import 'package:wake_arrival/common/constants/app_constants.dart';
import 'package:wake_arrival/common/constants/layout_constants.dart';
import 'package:wake_arrival/common/services/geofencing_service.dart';
import 'package:wake_arrival/common/theme/app_color.dart';
import 'package:wake_arrival/common/theme/app_text_theme.dart';
import 'package:wake_arrival/common/widgets/custom_map.dart';
import 'package:wake_arrival/common/widgets/primary_button.dart';

import 'package:wake_arrival/models/routes/routes_constant.dart';
import 'package:wake_arrival/models/search/search_constant.dart';

class LocationAddress {
  final String titleAddress;
  final String subtitleAddress;

  LocationAddress({required this.titleAddress, required this.subtitleAddress});
}

class LocationPageArgs {
  final LatLng searchedLatLng;
  final LocationAddress address;

  LocationPageArgs({
    required this.searchedLatLng,
    required this.address,
  });
}

class LocationPage extends StatefulWidget {
  final LocationPageArgs args;
  const LocationPage({super.key, required this.args});

  @override
  State<LocationPage> createState() => _LocationPageState();
}

class _LocationPageState extends State<LocationPage> {
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
      body: Column(
        children: [
          CustomMap(
              initialPosition: latLng,
              onLocationChange: (position) {
                latLng = position;
              }),
          Container(
            color: Colors.black.withValues(alpha: 0.1),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: LayoutConstants.dimen_180,
              width: double.infinity,
              padding: const EdgeInsets.all(LayoutConstants.dimen_16),
              decoration: const BoxDecoration(color: Colors.white),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  addressWidget(),
                  const Spacer(),
                  PrimaryButton(
                      title: AppConstants.confirm,
                      onTap: () async {
                        GeofencingService.initPlatformState(latLng);
                      })
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget addressWidget() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Flexible(
              flex: 3,
              child: Text(
                widget.args.address.titleAddress,
                style: AppTextTheme.headline6,
              ),
            ),
            const Spacer(),
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, RouteConstant.searchPage);
              },
              child: Flexible(
                  flex: 1,
                  child: Padding(
                    padding:
                        const EdgeInsets.only(top: LayoutConstants.dimen_3),
                    child: Text(
                      SearchConstant.change,
                      style: AppTextTheme.bodyText2.copyWith(
                        decoration: TextDecoration.underline,
                        decorationStyle: TextDecorationStyle.dashed,
                        decorationColor: AppColor.linkColor,
                        color: AppColor.linkColor,
                      ),
                    ),
                  )),
            ),
          ],
        ),
        const Gap(LayoutConstants.dimen_10),
        Text(widget.args.address.subtitleAddress),
        const Gap(LayoutConstants.dimen_10),
      ],
    );
  }
}
