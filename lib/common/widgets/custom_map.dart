import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:wake_arrival/common/constants/app_constants.dart';

class CustomMap extends StatefulWidget {
  final LatLng initialPosition;
  final Function(LatLng) onLocationChange;
  final bool canInteract;
  final List<LatLng>? otherPositions;
  const CustomMap({
    super.key,
    required this.initialPosition,
    required this.onLocationChange,
    this.canInteract = true,
    this.otherPositions,
  });

  @override
  State<CustomMap> createState() => _CustomMapState();
}

class _CustomMapState extends State<CustomMap> {
  late LatLng latLng;
  late double _radiusInPixels;
  final double zoomLevel = 13;
  final MapController _mapController = MapController();

  @override
  void initState() {
    super.initState();
    latLng = widget.initialPosition;
    _radiusInPixels = _calculateRadiusInPixels();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fitToBounds();
    });
  }

  void _fitToBounds() {
    final allPoints = [latLng, ...?widget.otherPositions];
    if (allPoints.length <= 1) return;

    final bounds = LatLngBounds.fromPoints(allPoints);
    _mapController.fitBounds(
      bounds,
      options: const FitBoundsOptions(
        padding: EdgeInsets.all(50),
      ),
    );
  }

  double _calculateRadiusInPixels() {
    final double metersPerPixel =
        156543.03392 * cos(latLng.latitude * pi / 180) / pow(2, zoomLevel);

    return (1000 / metersPerPixel);
  }

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      ignoring: !widget.canInteract,
      child: FlutterMap(
        mapController: _mapController,
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
              if (widget.otherPositions != null &&
                  widget.otherPositions!.isNotEmpty)
                ...List.generate(
                  widget.otherPositions!.length,
                  (index) => Marker(
                    point: widget.otherPositions![index],
                    width: 24,
                    height: 24,
                    builder: (context) => const Icon(
                      Icons.location_on,
                      color: Colors.blue,
                      size: 24,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
