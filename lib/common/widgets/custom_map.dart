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
    return Expanded(
      child: FlutterMap(
        options: MapOptions(
          onTap: (position, latLong) {
            setState(() {
              latLng = latLong;
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
                point: latLng, // Center of the circle
                radius: _radiusInPixels, // Radius in meters (1km)
                color: Colors.blue.withOpacity(0.4),
                borderStrokeWidth: 2,
                borderColor: Colors.blue,
              ),
            ],
          ),
          MarkerLayer(
            markers: [
              Marker(
                point: latLng,
                width: 20,
                height: 20,
                builder: (BuildContext context) {
                  return const Icon(
                    Icons.pin_drop_sharp,
                    color: Colors.red,
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
