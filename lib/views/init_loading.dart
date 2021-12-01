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
    return buildInitLoading(context);
  }

  Widget buildInitLoading(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Center(
        child: SizedBox(
          width: 200.0,
          height: 100.0,
          child: Shimmer.fromColors(
            baseColor: Colors.red,
            highlightColor: Colors.yellow,
            child: Text('Shopri', textAlign: TextAlign.center, style: TextStyle(fontSize: size.height * 0.06, fontWeight: FontWeight.bold)),
          ),
        ),
      ),
    );
  }
}
