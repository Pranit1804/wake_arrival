import 'package:flutter/material.dart';
import 'package:wake_arrival/common/constants/layout_constants.dart';
import 'package:wake_arrival/common/extension/string_extension.dart';
import 'package:wake_arrival/common/theme/app_color.dart';
import 'package:wake_arrival/common/widgets/primary_button.dart';
import 'package:wake_arrival/models/home/presentation/home_constants.dart';
import 'package:wake_arrival/models/routes/routes_constant.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.primaryColor,
      body: Padding(
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
      ),
    );
  }

  Widget viewPreviosDestionations() {
    return const Center(
        child: PrimaryButton(
      title: HomeConstants.viewPreviousDestination,
    ));
  }

  Widget setDestinationButton() {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pushNamed(RouteConstant.searchLandingPage);
      },
      child: const Center(
        child: PrimaryButton(
          title: HomeConstants.setDestination,
        ),
      ),
    );
  }

  Widget appBar() {
    return Row(
      children: [
        const Icon(
          Icons.arrow_back_ios,
          color: AppColor.primaryTextColor,
          size: LayoutConstants.dimen_18,
        ),
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
