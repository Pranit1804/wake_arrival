import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wake_arrival/common/theme/app_color.dart';
import 'package:wake_arrival/common/widgets/user_greeting_header.dart';
import 'package:wake_arrival/common/widgets/empty_alarm_state.dart';
import 'package:wake_arrival/common/widgets/active_alarm_card.dart';
import 'package:wake_arrival/common/widgets/custom_bottom_nav.dart';
import 'package:wake_arrival/models/home/presentation/state/home_cubit.dart';
import 'package:wake_arrival/models/home/presentation/state/home_state.dart';
import 'package:wake_arrival/models/home/presentation/pages/alarm_details_page.dart';
import 'package:wake_arrival/models/routes/routes_constant.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _currentNavIndex = 0;
  late HomeCubit _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = HomeCubit();
    _cubit.loadActiveAlarm();
  }

  @override
  void dispose() {
    _cubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      bloc: _cubit,
      builder: (context, state) {
        return Scaffold(
          extendBodyBehindAppBar: true,
          body: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColor.backgroundGradientStart,
                  AppColor.backgroundGradientEnd,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: SafeArea(
              bottom: false,
              child: Column(
                children: [
                  const UserGreetingHeader(),
                  Expanded(
                    child: state.hasActiveAlarm
                        ? _buildActiveAlarmView(state)
                        : _buildEmptyStateView(),
                  ),
                ],
              ),
            ),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: _navigateToSearch,
            backgroundColor: AppColor.accentPink,
            child: const Icon(Icons.add, size: 28),
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
          bottomNavigationBar: CustomBottomNav(
            currentIndex: _currentNavIndex,
            onTap: _onNavTap,
          ),
        );
      },
    );
  }

  Widget _buildEmptyStateView() {
    return EmptyAlarmState(
      onGetStarted: _navigateToSearch,
    );
  }

  Widget _buildActiveAlarmView(HomeState state) {
    final alarm = state.activeAlarm!;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Text(
              'Active alarm',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppColor.primaryTextColor,
              ),
            ),
          ),
          ActiveAlarmCard(
            destinationName: alarm.destinationName,
            address: alarm.address,
            distance: state.distance,
            duration: state.duration,
            onEdit: () {},
            onDelete: () async {
              final deleted = await _cubit.deleteActiveAlarm();
              if (deleted && mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Alarm deleted successfully'),
                    backgroundColor: Colors.green,
                  ),
                );
              }
            },
            onCardTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AlarmDetailsPage(
                    alarm: alarm,
                    currentLocation: state.currentLocation,
                    distance: state.distance,
                    duration: state.duration,
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 100),
        ],
      ),
    );
  }

  void _navigateToSearch() {
    Navigator.of(context).pushNamed(RouteConstant.searchPage);
  }

  void _onNavTap(int index) {
    setState(() {
      _currentNavIndex = index;
    });

    switch (index) {
      case 0:
        break;
      case 1:
        _navigateToSearch();
        break;
    }
  }
}
