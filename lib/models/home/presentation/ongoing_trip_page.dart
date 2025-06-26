// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:latlong2/latlong.dart';
import 'package:wake_arrival/common/constants/layout_constants.dart';
import 'package:wake_arrival/common/theme/app_text_theme.dart';

import 'package:wake_arrival/common/widgets/custom_map.dart';
import 'package:wake_arrival/common/widgets/primary_button.dart';
import 'package:wake_arrival/di/injector.dart';
import 'package:wake_arrival/models/home/data/entity/home_geofencing_detail_entity.dart';
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
                Text(
                  'Your Ongoing trip',
                  style: const TextStyle(
                    fontSize: LayoutConstants.dimen_28,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                Gap(LayoutConstants.dimen_30),
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
                      initialPosition: LatLng(
                          widget.detailEntity.lat, widget.detailEntity.long),
                      onLocationChange: (latLng) {},
                      canInteract: false,
                    ),
                  ),
                ),
                Gap(LayoutConstants.dimen_30),
                Text(
                  "${widget.detailEntity.locationTitle} ${widget.detailEntity.locationSubtitle}",
                  style: AppTextTheme.bodyText1,
                ),
                PrimaryButton(
                  title: HomeConstants.cancelTrip,
                  onTap: () {
                    _homeBloc.add(DeleteOngoingTripEvent());
                  },
                ),
                Gap(LayoutConstants.dimen_30),
                PrimaryButton(
                  title: HomeConstants.setAnotherDestination,
                  onTap: () {
                    _homeBloc.add(DeleteOngoingTripEvent());
                    Navigator.pushNamed(
                        context, RouteConstant.searchLandingPage);
                  },
                ),
              ],
            ),
          );
        });
  }
}
