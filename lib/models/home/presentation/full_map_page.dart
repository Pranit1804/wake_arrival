import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:wake_arrival/common/constants/layout_constants.dart';
import 'package:wake_arrival/common/services/geofencing_service.dart';
import 'package:wake_arrival/common/widgets/custom_map.dart';
import 'package:wake_arrival/models/routes/routes_constant.dart';

class FullMapPageArgs {
  final LatLng latLng;
  final bool showCurrentLatLng;

  FullMapPageArgs({
    required this.latLng,
    this.showCurrentLatLng = false,
  });
}

class FullMapPage extends StatefulWidget {
  final FullMapPageArgs args;

  const FullMapPage({
    super.key,
    required this.args,
  });

  @override
  State<FullMapPage> createState() => _FullMapPageState();
}

class _FullMapPageState extends State<FullMapPage> {
  LatLng? userLocation;
  @override
  void initState() {
    super.initState();
    getUserLocation();
  }

  void getUserLocation() async {
    GeofencingService.getCurrentLocation().then((value) {
      setState(() {
        userLocation = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: userLocation != null
            ? Stack(
                children: [
                  CustomMap(
                    initialPosition: widget.args.latLng,
                    onLocationChange: (location) {},
                    canInteract: false,
                  ),
                  _buildZoomOutIcon(),
                ],
              )
            : SizedBox.shrink(),
      ),
    );
  }

  Widget _buildZoomOutIcon() {
    return GestureDetector(
      onTap: () {
        Navigator.pop(context);
      },
      child: Align(
        alignment: Alignment.topRight,
        child: Container(
          margin: EdgeInsets.only(
            top: LayoutConstants.dimen_10,
            right: LayoutConstants.dimen_10,
          ),
          height: LayoutConstants.dimen_34,
          width: LayoutConstants.dimen_34,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white,
          ),
          child: Icon(Icons.fullscreen_exit),
        ),
      ),
    );
  }
}
