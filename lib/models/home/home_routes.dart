import 'package:flutter/material.dart';
import 'package:wake_arrival/models/home/presentation/full_map_page.dart';
import 'package:wake_arrival/models/home/presentation/home.dart';
import 'package:wake_arrival/models/routes/routes_constant.dart';

abstract class HomeRoutes {
  static Map<String, WidgetBuilder> all() => {
        RouteConstant.home: (context) => const Home(),
      };

  static Map<String, WidgetBuilder> getRoutesWithSettings(
    RouteSettings settings,
  ) =>
      {
        RouteConstant.fullMapPage: (context) {
          final args = settings.arguments as FullMapPageArgs;
          return FullMapPage(args: args);
        },
      };
}
