import 'package:flutter/material.dart';

import 'package:todotasks/presentation/screens/board/board.dart';
import 'package:todotasks/presentation/screens/detailes/details.dart';
import 'package:todotasks/presentation/screens/new_task/add_task.dart';
import 'package:todotasks/presentation/screens/schedule/schedule.dart';
import 'package:todotasks/presentation/screens/splash/splash.dart';

import '../screens/search/search.dart';

// routes reposetory
class Routes {
  static const String splashRoute = "/";
  static const String boardRoute = "/board";
  static const String addTaskRoute = "/add_task";
  static const String scheduleRoute = "/schedule";
  static const String detailsRoute = "/datails";
  static const String search = "/search";
}

// generator of routes
class RouteGenerator {
  static Route<dynamic>? getRoute(RouteSettings settings) {
    switch (settings.name) {
      case Routes.splashRoute:
        return MaterialPageRoute(builder: (_) => const Splash());
      case Routes.boardRoute:
        return MaterialPageRoute(builder: (_) => const Board());
      case Routes.addTaskRoute:
        return MaterialPageRoute(builder: (_) => const AddTaskPage());
      case Routes.detailsRoute:
        return MaterialPageRoute(builder: (_) => Details());
      case Routes.scheduleRoute:
        return MaterialPageRoute(builder: (_) => const Schedule());
      case Routes.search:
        return MaterialPageRoute(builder: (_) => SearchScreen());
      default:
        return MaterialPageRoute(builder: (_) => const Splash());
    }
  }
}
