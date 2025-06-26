import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wake_arrival/common/constants/layout_constants.dart';
import 'package:wake_arrival/common/extension/string_extension.dart';
import 'package:wake_arrival/common/theme/app_color.dart';
import 'package:wake_arrival/common/widgets/primary_button.dart';
import 'package:wake_arrival/di/injector.dart';
import 'package:wake_arrival/models/home/data/entity/home_geofencing_detail_entity.dart';
import 'package:wake_arrival/models/home/presentation/home_constants.dart';
import 'package:wake_arrival/models/home/presentation/ongoing_trip_page.dart';
import 'package:wake_arrival/models/home/presentation/state/home_bloc.dart';
import 'package:wake_arrival/models/routes/routes_constant.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late HomeBloc _homeBloc;
  HomeGeofencingDetailEntity? detailEntity;
  ValueNotifier<bool> isHomeLoading = ValueNotifier(true);

  @override
  void initState() {
    super.initState();
    _homeBloc = Injector.resolve<HomeBloc>()..add(GetOngoingGeoFencingEvent());
  }

  void _listenToHomeBloc(BuildContext context, HomeState state) {
    if (state is GetOngoingGeoFencingSuccess) {
      isHomeLoading.value = false;
      detailEntity = state.data;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.primaryColor,
      body: BlocConsumer(
        listener: _listenToHomeBloc,
        bloc: _homeBloc,
        builder: (context, _) {
          return ValueListenableBuilder(
              valueListenable: isHomeLoading,
              builder: (context, _, __) {
                return isHomeLoading.value
                    ? CircularProgressIndicator.adaptive()
                    : detailEntity != null
                        ? OngoingTripPage(
                            detailEntity: detailEntity!,
                          )
                        : Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: LayoutConstants.dimen_16,
                              vertical: LayoutConstants.dimen_56,
                            ),
                            child: Column(
                              children: [
                                appBar(),
                                const Spacer(),
                                setDestinationButton(),
                                const SizedBox(
                                  height: LayoutConstants.dimen_22,
                                ),
                                viewPreviosDestionations(),
                                const Spacer(),
                              ],
                            ),
                          );
              });
        },
      ),
    );
  }

  Widget viewPreviosDestionations() {
    return Center(
        child: PrimaryButton(
      title: HomeConstants.viewPreviousDestination,
      onTap: () {},
    ));
  }

  Widget setDestinationButton() {
    return Center(
      child: PrimaryButton(
        title: HomeConstants.setDestination,
        onTap: () {
          Navigator.of(context).pushNamed(RouteConstant.searchPage);
        },
      ),
    );
  }

  Widget appBar() {
    return Row(
      children: [
        const SizedBox(
          width: LayoutConstants.dimen_8,
        ),
        Text(
          HomeConstants.home.capitalizeFirstLetter(),
          style: const TextStyle(
            fontSize: LayoutConstants.dimen_20,
            fontWeight: FontWeight.w700,
            color: AppColor.primaryTextColor,
          ),
        ),
      ],
    );
  }
}
