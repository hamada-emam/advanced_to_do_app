import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todotasks/presentation/resources/string_manager.dart';

import '../bloc/task_bloc/task_cubit.dart';
import '../presentation/resources/routes_manager.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

// ROOT POINT FOR ALL APP
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // ROOT
  @override
  Widget build(BuildContext context) {
    //HANDLING STATUS BAR
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle.dark.copyWith(
        statusBarColor: Colors.white,
        systemNavigationBarColor: Colors.white,
        systemNavigationBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.dark,
      ),
    );
    return BlocProvider<AppCubit>(
      create: (_) => AppCubit()
        ..createDataBase()
        ..getDataBase()
        ..initializeNotifications(), // create your BLoC here
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          fontFamily: StringManager.fontFamily,
          primarySwatch: Colors.green,
        ),
        onGenerateRoute: RouteGenerator.getRoute,
        initialRoute: Routes.splashRoute,
        navigatorKey: navigatorKey,
      ),
    );
  }
}
