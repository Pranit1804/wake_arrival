import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:wake_arrival/common/services/alarm_storage_service.dart';
import 'package:wake_arrival/common/services/geofencing_service.dart';
import 'package:wake_arrival/common/theme/app_color.dart';
import 'package:wake_arrival/common/widgets/custom_map.dart';
import 'package:wake_arrival/common/widgets/location_details_bottom_sheet.dart';
import 'package:wake_arrival/models/home/data/alarm_model.dart';
import 'package:wake_arrival/models/routes/routes_constant.dart';

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
  late LatLng latLng;

  @override
  void initState() {
    super.initState();
    latLng = widget.args.searchedLatLng;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: const BoxDecoration(
              color: AppColor.cardBackground,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.arrow_back_ios_new,
              color: AppColor.primaryTextColor,
              size: 18,
            ),
          ),
          onPressed: () => Navigator.pop(context),
        ),
        actions: const [
          // TODO: Get current location
          // Padding(
          //   padding: const EdgeInsets.only(right: 16),
          //   child: IconButton(
          //     icon: Container(
          //       padding: const EdgeInsets.all(8),
          //       decoration: const BoxDecoration(
          //         color: AppColor.cardBackground,
          //         shape: BoxShape.circle,
          //       ),
          //       child: const Icon(
          //         Icons.my_location,
          //         color: AppColor.accentPurple,
          //         size: 20,
          //       ),
          //     ),
          //     onPressed: () {
          //     },
          //   ),
          // ),
        ],
      ),
      body: Stack(
        children: [
          CustomMap(
            initialPosition: latLng,
            onLocationChange: (position) {
              setState(() {
                latLng = position;
              });
            },
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: LocationDetailsBottomSheet(
              title: widget.args.address.titleAddress,
              subtitle: widget.args.address.subtitleAddress,
              onConfirm: () async {
                try {
                  // Create and save alarm
                  final alarm = AlarmModel.fromLocation(
                    destinationName: widget.args.address.titleAddress,
                    address: widget.args.address.subtitleAddress,
                    latitude: latLng.latitude,
                    longitude: latLng.longitude,
                  );

                  await AlarmStorageService.saveActiveAlarm(alarm);

                  // Initialize geofencing
                  await GeofencingService.initPlatformState(latLng);

                  if (context.mounted) {
                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      RouteConstant.home,
                      (route) => false,
                    );
                  }
                } catch (e) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Failed to setup alarm: $e'),
                        backgroundColor: AppColor.accentPink,
                      ),
                    );
                  }
                }
              },
              onChangeLocation: () {
                Navigator.pushNamed(context, RouteConstant.searchPage);
              },
            ),
          ),
        ],
      ),
    );
  }
}
