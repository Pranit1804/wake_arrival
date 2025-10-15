// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:latlong2/latlong.dart';
import 'package:wake_arrival/common/constants/layout_constants.dart';
import 'package:wake_arrival/common/theme/app_text_theme.dart';

import 'package:wake_arrival/common/widgets/custom_map.dart';
import 'package:wake_arrival/common/widgets/primary_button.dart';
import 'package:wake_arrival/common/widgets/primary_link_button.dart';
import 'package:wake_arrival/di/injector.dart';
import 'package:wake_arrival/models/home/data/entity/home_geofencing_detail_entity.dart';
import 'package:wake_arrival/models/home/presentation/full_map_page.dart';
import 'package:wake_arrival/models/home/presentation/home_constants.dart';
import 'package:wake_arrival/models/home/presentation/state/home_bloc.dart';
import 'package:wake_arrival/models/routes/routes_constant.dart';

class OngoingTripPage extends StatefulWidget {
  final HomeGeofencingDetailEntity detailEntity;

  const OngoingTripPage({
    super.key,
    required this.detailEntity,
  });

  @override
  State<OngoingTripPage> createState() => _OngoingTripPageState();
}

class _OngoingTripPageState extends State<OngoingTripPage> {
  late HomeBloc _homeBloc;

  @override
  void initState() {
    super.initState();
    _homeBloc = Injector.resolve<HomeBloc>();
  }

  void _listenToHomeBloc(BuildContext context, HomeState state) {
    if (state is DeleteOngoingTripSuccess) {
      Navigator.pushNamed(context, RouteConstant.home);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer(
        bloc: _homeBloc,
        listener: _listenToHomeBloc,
        builder: (context, _) {
          return Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              children: [
                Gap(LayoutConstants.dimen_90),
                _buildHeader(),
                Gap(LayoutConstants.dimen_30),
                _buildMap(),
                Gap(LayoutConstants.dimen_15),
                Text(
                  "${widget.detailEntity.locationTitle} ${widget.detailEntity.locationSubtitle}",
                  textAlign: TextAlign.center,
                  style: AppTextTheme.bodyText1.copyWith(
                    color: Colors.white,
                    fontSize: LayoutConstants.dimen_18,
                  ),
                ),
                Spacer(),
                PrimaryLinkButton(
                  title: HomeConstants.cancelTrip,
                  linkColor: Colors.blue,
                ),
                Gap(LayoutConstants.dimen_10),
                PrimaryButton(
                  title: HomeConstants.setAnotherDestination,
                  onTap: () {
                    _homeBloc.add(DeleteOngoingTripEvent());
                    Navigator.pushNamed(
                      context,
                      RouteConstant.searchPage,
                    );
                  },
                ),
                Spacer(),
              ],
            ),
          );
        });
  }

  Widget _buildHeader() {
    return Text(
      'Your Ongoing trip',
      style: const TextStyle(
        fontSize: LayoutConstants.dimen_28,
        fontWeight: FontWeight.w600,
        color: Colors.white,
      ),
    );
  }

  Widget _buildMap() {
    return Stack(
      children: [
        Container(
          height: 200,
          alignment: Alignment.topCenter,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.amber),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: CustomMap(
              initialPosition: widget.detailEntity.latLng,
              onLocationChange: (latLng) {},
              canInteract: false,
            ),
          ),
        ),
        _buildZoomIcon(),
      ],
    );
  }

  Widget _buildZoomIcon() {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
          context,
          RouteConstant.fullMapPage,
          arguments: FullMapPageArgs(
              latLng: LatLng(widget.detailEntity.lat, widget.detailEntity.long),
              showCurrentLatLng: true),
        );
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
          child: Icon(Icons.fullscreen),
        ),
      ),
    );
  }
}
