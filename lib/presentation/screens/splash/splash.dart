import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:todotasks/presentation/resources/constants_manager.dart';
import 'package:todotasks/presentation/resources/routes_manager.dart';

import '../../resources/assets_manager.dart';

// SPLASH SCREEN
class Splash extends StatelessWidget {
  const Splash({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // DURATION THEN GO ROUTING
    Future.delayed(const Duration(seconds: ConstatsManager.splashDuration))
        .then(
      (value) => Navigator.of(context).pushReplacementNamed(Routes.boardRoute),
    );
    return Scaffold(
      body: Center(
          child: Lottie.asset(
        AssetsManaging.splash,
      )),
    );
  }
}
