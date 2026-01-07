import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:wake_arrival/common/constants/app_constants.dart';
import 'package:wake_arrival/common/theme/app_color.dart';
import 'package:wake_arrival/models/home/data/alarm_model.dart';
import 'package:wake_arrival/models/home/presentation/state/alarm_details_cubit.dart';
import 'package:wake_arrival/models/home/presentation/state/alarm_details_state.dart';

class AlarmDetailsPage extends StatefulWidget {
  final AlarmModel alarm;
  final LatLng? currentLocation;
  final String distance;
  final String duration;

  const AlarmDetailsPage({
    super.key,
    required this.alarm,
    required this.currentLocation,
    required this.distance,
    required this.duration,
  });

  @override
  State<AlarmDetailsPage> createState() => _AlarmDetailsPageState();
}

class _AlarmDetailsPageState extends State<AlarmDetailsPage> {
  late AlarmDetailsCubit _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = AlarmDetailsCubit(
      alarm: widget.alarm,
      currentLocation: widget.currentLocation,
      distance: widget.distance,
      duration: widget.duration,
    );
  }

  @override
  void dispose() {
    _cubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AlarmDetailsCubit, AlarmDetailsState>(
      bloc: _cubit,
      builder: (context, state) {
        final destination = LatLng(state.alarm.latitude, state.alarm.longitude);
        final hasCurrentLocation = state.currentLocation != null;

        return _buildScaffold(context, state, destination, hasCurrentLocation);
      },
    );
  }

  Widget _buildScaffold(
    BuildContext context,
    AlarmDetailsState state,
    LatLng destination,
    bool hasCurrentLocation,
  ) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
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
        title: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: AppColor.cardBackground,
            borderRadius: BorderRadius.circular(20),
          ),
          child: const Text(
            'Active Alarm',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColor.primaryTextColor,
            ),
          ),
        ),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          FlutterMap(
            options: MapOptions(
              center: hasCurrentLocation
                  ? _calculateCenter(state.currentLocation!, destination)
                  : destination,
              zoom: hasCurrentLocation
                  ? _calculateZoom(state.currentLocation!, destination)
                  : 14,
            ),
            children: [
              TileLayer(
                urlTemplate: AppConstants.mapBoxStyleTileUrl,
                userAgentPackageName: "com.bytecoder.wakearrival.wakeArrival",
              ),
              if (hasCurrentLocation)
                PolylineLayer(
                  polylines: [
                    Polyline(
                      points: [state.currentLocation!, destination],
                      strokeWidth: 4,
                      color: AppColor.accentPurple,
                      borderStrokeWidth: 2,
                      borderColor: AppColor.primaryTextColor.withOpacity(0.3),
                    ),
                  ],
                ),
              CircleLayer(
                circles: [
                  CircleMarker(
                    point: destination,
                    radius: _calculateRadiusInPixels(
                        destination,
                        hasCurrentLocation
                            ? _calculateZoom(
                                state.currentLocation!, destination)
                            : 14),
                    color: AppColor.accentPurple.withOpacity(0.2),
                    borderStrokeWidth: 2,
                    borderColor: AppColor.accentPurple,
                  ),
                ],
              ),
              MarkerLayer(
                markers: [
                  if (hasCurrentLocation)
                    Marker(
                      point: state.currentLocation!,
                      width: 50,
                      height: 50,
                      builder: (context) => Container(
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 3),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.blue.withOpacity(0.5),
                              blurRadius: 8,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.navigation,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                    ),
                  Marker(
                    point: destination,
                    width: 50,
                    height: 50,
                    builder: (context) => Container(
                      decoration: BoxDecoration(
                        color: AppColor.accentPink,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 3),
                        boxShadow: [
                          BoxShadow(
                            color: AppColor.accentPink.withOpacity(0.5),
                            blurRadius: 8,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.location_on,
                        color: Colors.white,
                        size: 28,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: _buildInfoCard(context, state),
          ),
          if (hasCurrentLocation)
            Positioned(
              top: MediaQuery.of(context).padding.top + 70,
              left: 16,
              right: 16,
              child: _buildTopInfo(state),
            ),
        ],
      ),
    );
  }

  Widget _buildTopInfo(AlarmDetailsState state) {
    return Row(
      children: [
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColor.cardBackground,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              children: [
                const Icon(Icons.access_time,
                    color: AppColor.accentPurple, size: 24),
                const SizedBox(height: 4),
                Text(
                  state.duration,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColor.primaryTextColor,
                  ),
                ),
                Text(
                  'ETA @ ${state.currentSpeed}',
                  style: const TextStyle(
                      fontSize: 11, color: AppColor.secondaryTextColor),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColor.cardBackground,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              children: [
                const Icon(Icons.straighten,
                    color: AppColor.accentPink, size: 24),
                const SizedBox(height: 4),
                Text(
                  state.distance,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColor.primaryTextColor,
                  ),
                ),
                const Text('Distance',
                    style: TextStyle(
                        fontSize: 11, color: AppColor.secondaryTextColor)),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInfoCard(BuildContext context, AlarmDetailsState state) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColor.cardBackground,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColor.tertiaryTextColor,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: Colors.greenAccent,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 8),
                const Text(
                  'Active',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Colors.greenAccent,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              state.alarm.destinationName,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: AppColor.primaryTextColor,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 8),
            Text(
              state.alarm.address,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: AppColor.secondaryTextColor,
                height: 1.5,
              ),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.directions, size: 20),
                    label: const Text('Directions'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColor.accentPurple,
                      foregroundColor: AppColor.primaryTextColor,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close, size: 20),
                    label: const Text('Close'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColor.primaryTextColor,
                      side: BorderSide(
                        color: AppColor.primaryTextColor.withOpacity(0.3),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  LatLng _calculateCenter(LatLng start, LatLng end) {
    final lat = (start.latitude + end.latitude) / 2;
    final lng = (start.longitude + end.longitude) / 2;
    return LatLng(lat, lng);
  }

  double _calculateZoom(LatLng start, LatLng end) {
    const distance = Distance();
    final distanceInMeters = distance.as(LengthUnit.Meter, start, end);

    if (distanceInMeters < 1000) return 15;
    if (distanceInMeters < 5000) return 13;
    if (distanceInMeters < 10000) return 12;
    return 11;
  }

  double _calculateRadiusInPixels(LatLng center, double zoom) {
    const radiusInMeters = 1000.0;
    final metersPerPixel =
        156543.03392 * cos(center.latitude * pi / 180) / pow(2, zoom);
    return radiusInMeters / metersPerPixel;
  }
}
