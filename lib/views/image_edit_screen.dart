import 'dart:typed_data';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:get/get.dart';
import 'package:image_editor/image_editor.dart' hide ImageSource;
import 'package:image_picker/image_picker.dart';
import 'package:shopri/controllers/api_controller.dart';
import 'package:shopri/views/product_add_screen.dart';
import 'package:transition/transition.dart' as transition;
import 'package:path_provider/path_provider.dart';

class ImageEditScreen extends StatefulWidget {
  const ImageEditScreen({Key? key, required this.imageFile}) : super(key: key);
  final XFile? imageFile;

  @override
  _ImageEditScreenState createState() => _ImageEditScreenState();
}

class _ImageEditScreenState extends State<ImageEditScreen> {
  final GlobalKey<ExtendedImageEditorState> editorKey = GlobalKey();
  ImageProvider? provider;

  @override
  void initState() {
    provider = ExtendedFileImageProvider(File(widget.imageFile!.path), cacheRawData: true);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        shadowColor: Colors.transparent,
        elevation: 0.0,
        title: const Text('Edit', style: TextStyle(color: Colors.black)),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.check, color: Colors.black),
            onPressed: () async {
              await crop();
            },
          ),
        ],
      ),
      body: SizedBox(
        height: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            AspectRatio(aspectRatio: 1, child: buildImage(size)),
          ],
        ),
      ),
      bottomNavigationBar: _buildFunctions(),
    );
  }

  Widget buildImage(Size size) {
    return ExtendedImage(
      image: provider!,
      height: 400,
      width: 400,
      extendedImageEditorKey: editorKey,
      mode: ExtendedImageMode.editor,
      fit: BoxFit.contain,
      initEditorConfigHandler: (_) => EditorConfig(
        maxScale: 8.0,
        cropRectPadding: const EdgeInsets.all(20.0),
        hitTestSize: 20.0,
        cropAspectRatio: CropAspectRatios.custom,
      ),
    );
  }

  Widget _buildFunctions() {
    return BottomNavigationBar(
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(icon: Icon(Icons.flip), label: 'Flip'),
        BottomNavigationBarItem(icon: Icon(Icons.rotate_left), label: 'Rotate left'),
        BottomNavigationBarItem(icon: Icon(Icons.rotate_right), label: 'Rotate right'),
      ],
      onTap: (int index) {
        switch (index) {
          case 0:
            flip();
            break;
          case 1:
            rotate(false);
            break;
          case 2:
            rotate(true);
            break;
        }
      },
      currentIndex: 0,
      selectedItemColor: Theme.of(context).primaryColor,
      unselectedItemColor: Theme.of(context).primaryColor,
    );
  }

  Future<void> crop([bool test = false]) async {
    final ExtendedImageEditorState? state = editorKey.currentState;
    if (state == null) return;
    final Rect? rect = state.getCropRect();
    if (rect == null) return;
    final EditActionDetails action = state.editAction!;
    final double radian = action.rotateAngle;
    print('rotation: $radian');
    final bool flipHorizontal = action.flipY;
    final bool flipVertical = action.flipX;
    final Uint8List? img = state.rawImageData;
    if (img == null) return;
    final ImageEditorOption option = ImageEditorOption();
    option.addOption(ClipOption.fromRect(rect));
    option.addOption(FlipOption(horizontal: flipHorizontal, vertical: flipVertical));
    if (action.hasRotateAngle) option.addOption(RotateOption(radian.toInt()));
    option.outputFormat = const OutputFormat.png(30);
    final Uint8List? result = await ImageEditor.editImage(image: img, imageEditorOption: option);
    if (result == null) return;
    //* after crop compress the image and add it to the api controller product images list
    Uint8List compressedImage = await comporessList(result, 30);
    File file = await convertUintToFile(compressedImage);
    Get.find<ApiController>().addToProductImages(file);
    Navigator.pushReplacement(context, transition.Transition(child: const ProductAddScreen(), transitionEffect: transition.TransitionEffect.FADE));
  }

  void flip() => editorKey.currentState?.flip();
  void rotate(bool right) => editorKey.currentState?.rotate(right: right);
}

Future<Uint8List> comporessList(Uint8List list, int compressionRatio) async {
  var result = await FlutterImageCompress.compressWithList(list, quality: compressionRatio);
  return result;
}

Future<File> convertUintToFile(Uint8List list) async {
  final tempDir = await getTemporaryDirectory();
  File file = await File('${tempDir.path}/image.jpg').create();
  file.writeAsBytesSync(list);
  return file;
}
