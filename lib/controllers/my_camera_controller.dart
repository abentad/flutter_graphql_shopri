import 'package:camera/camera.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class MyCameraController extends GetxController {
  late List<CameraDescription>? _cameras;
  List<CameraDescription>? get cameras => _cameras;
  final ImagePicker _picker = ImagePicker();

  MyCameraController() {
    loadCameras();
  }

  void loadCameras() async {
    _cameras = await availableCameras();
    print("cameras: $_cameras");
    update();
  }

  Future<XFile?> pickImageFromGallery() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    return image;
  }
}
