import 'package:flutter/material.dart';
import 'package:wake_arrival/models/routes/routes_constant.dart';
import 'package:wake_arrival/models/search/presentation/pages/search_landing_page.dart';
import 'package:wake_arrival/models/search/presentation/pages/search_page.dart';

abstract class SearchRoutes {
  static Map<String, WidgetBuilder> all() => {
        RouteConstant.searchPage: (context) => const SearchPage(),
      };

  static Map<String, WidgetBuilder> getRoutesWithSettings(
    RouteSettings settings,
  ) =>
      {
        RouteConstant.searchLandingPage: (context) {
          final args = settings.arguments as SearchLandingPageArgs;
          return SearchLandingPage(args: args);
        },
      };
}
