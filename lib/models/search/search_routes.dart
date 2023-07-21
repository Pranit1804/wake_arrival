import 'package:flutter/material.dart';
import 'package:wake_arrival/models/routes/routes_constant.dart';
import 'package:wake_arrival/models/search/presentation/search.dart';

abstract class SearchRoutes {
  static Map<String, WidgetBuilder> all() => {
        RouteConstant.search: (context) => const SearchPage(),
      };
}
