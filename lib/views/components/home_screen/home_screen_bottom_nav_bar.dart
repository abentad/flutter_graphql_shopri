import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shopri/controllers/my_camera_controller.dart';
import 'package:shopri/views/camera_screen.dart';
import 'package:transition/transition.dart' as transition;

class BuildBottomNavBar extends StatefulWidget {
  const BuildBottomNavBar({Key? key}) : super(key: key);

  @override
  _BuildBottomNavBarState createState() => _BuildBottomNavBarState();
}

class _BuildBottomNavBarState extends State<BuildBottomNavBar> {
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    // final size = MediaQuery.of(context).size;

    return BottomAppBar(
      shape: const CircularNotchedRectangle(),
      notchMargin: 10,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        height: 60,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            BottomNavIcon(
              ontap: () {
                setState(() {
                  currentIndex = 0;
                });
              },
              iconData: Icons.home_outlined,
              currentIndex: currentIndex,
              index: 0,
            ),
            BottomNavIcon(
              ontap: () {
                setState(() {
                  currentIndex = 1;
                });
              },
              iconData: Icons.search,
              currentIndex: currentIndex,
              index: 1,
            ),
            BottomNavIcon(
              ontap: () {
                setState(() {
                  currentIndex = 2;
                });
              },
              iconData: Icons.notifications_outlined,
              currentIndex: currentIndex,
              index: 2,
            ),
            BottomNavIcon(
              ontap: () {
                setState(() {
                  currentIndex = 3;
                });
              },
              iconData: Icons.mail_outline,
              currentIndex: currentIndex,
              index: 3,
            ),
          ],
        ),
      ),
    );
  }
}

class BottomNavIcon extends StatelessWidget {
  const BottomNavIcon({Key? key, required this.ontap, required this.currentIndex, required this.index, required this.iconData}) : super(key: key);

  final Function() ontap;
  final int currentIndex;
  final int index;
  final IconData iconData;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(50.0),
      splashColor: Colors.grey.shade100.withOpacity(0.4),
      highlightColor: Colors.grey.shade100.withOpacity(0.4),
      onTap: ontap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 30.0),
        decoration: const BoxDecoration(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              iconData,
              color: currentIndex == index ? Colors.black : Colors.grey,
              // size: currentIndex == index ? 26.0 : 22.0,
              size: 28,
            ),
          ],
        ),
      ),
    );
  }
}

class BuildFloatingActoinButton extends StatelessWidget {
  const BuildFloatingActoinButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      backgroundColor: Colors.black,
      onPressed: () {
        // Navigator.of(context).push(HomeScreenCustomAnimatedRoute(enterWidget: CameraScreen(cameras: Get.find<MyCameraController>().cameras)));
        Navigator.push(context, transition.Transition(child: CameraScreen(cameras: Get.find<MyCameraController>().cameras), transitionEffect: transition.TransitionEffect.FADE));
      },
      child: const Icon(CupertinoIcons.add, color: Colors.white, size: 30),
    );
  }
}
