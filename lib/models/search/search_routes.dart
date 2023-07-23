import 'package:flutter/material.dart';
import 'package:wake_arrival/models/routes/routes_constant.dart';
import 'package:wake_arrival/models/search/presentation/pages/search_landing_page.dart';
import 'package:wake_arrival/models/search/presentation/pages/search_page.dart';

abstract class SearchRoutes {
  static Map<String, WidgetBuilder> all() => {
        RouteConstant.searchLandingPage: (context) => const SearchLandingPage(),
        RouteConstant.searchPage: (context) => const SearchPage(),
      };
}
