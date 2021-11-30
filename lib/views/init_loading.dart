import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import 'package:shopri/controllers/api_controller.dart';
import 'package:shopri/views/auth_choice.dart';
import 'package:transition/transition.dart' as transition;

class InitLoading extends StatefulWidget {
  const InitLoading({Key? key}) : super(key: key);

  @override
  State<InitLoading> createState() => _InitLoadingState();
}

class _InitLoadingState extends State<InitLoading> {
  @override
  void initState() {
    super.initState();
    //TODO: if there is token sign in with token if not go to sign in page
    checkUserAvailability();
  }

  void checkUserAvailability() async {
    bool isUserLoggedIn = await Get.find<ApiController>().checkIfUserIsLoggedIn();
    Get.find<ApiController>().setClient();
    if (isUserLoggedIn) {
      Get.find<ApiController>().signInWithToken(context);
    } else {
      Navigator.pushReplacement(context, transition.Transition(child: const AuthChoice(), transitionEffect: transition.TransitionEffect.FADE));
    }
  }

  @override
  Widget build(BuildContext context) {
    return buildInitLoading();
  }

  Widget buildInitLoading() {
    return Scaffold(
      body: Center(
        child: SizedBox(
          width: 200.0,
          height: 100.0,
          child: Shimmer.fromColors(
            baseColor: Colors.red,
            highlightColor: Colors.yellow,
            child: const Text(
              'Shopri',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 40.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
