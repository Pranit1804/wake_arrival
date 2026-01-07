import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:wake_arrival/common/constants/app_constants.dart';

class CustomMap extends StatefulWidget {
  final LatLng initialPosition;
  final Function(LatLng) onLocationChange;
  const CustomMap({
    super.key,
    required this.initialPosition,
    required this.onLocationChange,
  });

  @override
  State<CustomMap> createState() => _CustomMapState();
}

class _CustomMapState extends State<CustomMap> {
  late LatLng latLng;
  late double _radiusInPixels;
  final double zoomLevel = 13;

  @override
  void initState() {
    super.initState();
    latLng = widget.initialPosition;
    _radiusInPixels = _calculateRadiusInPixels();
  }

  double _calculateRadiusInPixels() {
    final double metersPerPixel =
        156543.03392 * cos(latLng.latitude * pi / 180) / pow(2, zoomLevel);

    return (1000 / metersPerPixel);
  }

  @override
  Widget build(BuildContext context) {
    return FlutterMap(
      options: MapOptions(
        onTap: (position, latLong) {
          setState(() {
            latLng = latLong;
            widget.onLocationChange(latLng);
          });
        },
        center: latLng,
        zoom: zoomLevel,
        onPositionChanged: (position, hasGesture) {
          _calculateRadiusInPixels();
        },
      ),
      children: [
        TileLayer(
          urlTemplate: AppConstants.mapBoxStyleTileUrl,
          userAgentPackageName: "com.bytecoder.wakearrival.wakeArrival",
        ),
        CircleLayer(
          circles: [
            CircleMarker(
              point: latLng,
              radius: _radiusInPixels,
              color: const Color(0x4D8B7FD8), // Purple with opacity
              borderStrokeWidth: 2,
              borderColor: const Color(0xff8B7FD8), // Accent purple
            ),
          ],
        ),
        MarkerLayer(
          markers: [
            Marker(
              point: latLng,
              width: 40,
              height: 40,
              builder: (BuildContext context) {
                return Container(
                  decoration: BoxDecoration(
                    color: const Color(0xffE91E63), // Pink accent
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xffE91E63).withOpacity(0.5),
                        blurRadius: 8,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.location_on,
                    color: Colors.white,
                    size: 24,
                  ),
                );
              },
            ),
          ],
        ),
      ],
    );
  }
}
