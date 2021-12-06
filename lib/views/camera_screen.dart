import 'dart:io';
import 'package:camera/camera.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:shopri/controllers/my_camera_controller.dart';
import 'package:shopri/views/image_edit_screen.dart';
import 'package:transition/transition.dart' as transition;

class CameraScreen extends StatefulWidget {
  const CameraScreen({Key? key, required this.cameras}) : super(key: key);
  final List<CameraDescription>? cameras;

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> with TickerProviderStateMixin {
  late CameraController cameraController;
  XFile? pictureFile;

  @override
  void initState() {
    //for camera
    cameraController = CameraController(widget.cameras![0], ResolutionPreset.max);
    cameraController.initialize().then((value) {
      if (!mounted) {
        return;
      }
      setState(() {});
    });
    print(widget.cameras);
    super.initState();
  }

  @override
  void dispose() {
    cameraController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    // if (!cameraController.value.isInitialized) {
    //   return const SizedBox(
    //     child: Center(
    //       child: CircularProgressIndicator(),
    //     ),
    //   );
    // }

    return ClipRRect(
      child: Scaffold(
        backgroundColor: Colors.black,
        body: SafeArea(
          child: Stack(
            children: [
              SizedBox(
                height: size.height,
                width: size.width,
                child: CameraPreview(cameraController),
              ),
              pictureFile != null
                  ? Positioned(
                      top: 10.0,
                      right: 10.0,
                      child: Container(
                        height: size.height * 0.2,
                        width: size.width * 0.2,
                        decoration: BoxDecoration(
                          image: DecorationImage(image: FileImage(File(pictureFile!.path))),
                        ),
                      ),
                    )
                  : const SizedBox.shrink(),
              Positioned(
                right: 20.0,
                top: 20.0,
                child: Icon(
                  MdiIcons.flashOff,
                  color: Colors.white,
                  size: size.height * 0.04,
                ),
              ),
              Positioned(
                bottom: 10.0,
                left: 0.0,
                right: 0.0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    InkWell(
                      onTap: () {
                        cameraController = CameraController(widget.cameras![1], ResolutionPreset.max);
                        cameraController.initialize().then((value) {
                          if (!mounted) {
                            return;
                          }
                          setState(() {});
                        });
                      },
                      child: Icon(
                        MdiIcons.cameraFlip,
                        color: Colors.white,
                        size: size.height * 0.06,
                      ),
                    ),
                    GestureDetector(
                      onTap: () async {
                        pictureFile = await cameraController.takePicture();
                        setState(() {});
                        Navigator.pushReplacement(context, transition.Transition(child: ImageEditScreen(imageFile: pictureFile), transitionEffect: transition.TransitionEffect.FADE));
                      },
                      child: Container(
                        height: size.height * 0.18,
                        width: size.width * 0.18,
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                          border: Border.all(color: Colors.white, width: 5.0),
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () async {
                        XFile? pickedFile = await Get.find<MyCameraController>().pickImageFromGallery();
                        Navigator.pushReplacement(context, transition.Transition(child: ImageEditScreen(imageFile: pickedFile), transitionEffect: transition.TransitionEffect.FADE));
                      },
                      child: Icon(
                        MdiIcons.image,
                        color: Colors.white,
                        size: size.height * 0.06,
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
