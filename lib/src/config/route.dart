import 'package:flutter/material.dart';
import 'package:health/pages/covid.dart';
import 'package:health/pages/skincanc.dart';
import 'package:health/pages/tbpage.dart';
import 'package:health/src/pages/detail_page.dart';
import 'package:health/src/pages/home_page.dart';
import 'package:health/src/widgets/coustom_route.dart';
import 'package:health/pages/appointments.dart';

class Routes {
  static Map<String, WidgetBuilder> getRoute() {
    return <String, WidgetBuilder>{
      '/HomePage': (_) => HomePage(),
    };
  }

  static Route onGenerateRoute(RouteSettings settings) {
    final List<String> pathElements = settings.name.split('/');
    if (pathElements[0] != '' || pathElements.length == 1) {
      return null;
    }
    switch (pathElements[1]) {
      case "DetailPage":
        return CustomRoute<bool>(
            builder: (BuildContext context) => DetailPage(
                  model: settings.arguments,
                ));
      case "TBPage":
        return CustomRoute<bool>(builder: (BuildContext context) => TBPage());
      case "SkinPage":
        return CustomRoute<bool>(builder: (BuildContext context) => SkinPage());
      case "CovidPage":
        return CustomRoute<bool>(
            builder: (BuildContext context) => CovidPage());
      case "appointments":
        return CustomRoute<bool>(
          builder: (BuildContext context) => appointments()
        );
    }
  }
}
