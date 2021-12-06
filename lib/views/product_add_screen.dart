import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shopri/controllers/api_controller.dart';
import 'package:shopri/controllers/my_camera_controller.dart';
import 'package:shopri/views/camera_screen.dart';
import 'package:shopri/views/components/custom_textform_field.dart';
import 'package:flutter_dropdown/flutter_dropdown.dart';
import 'package:transition/transition.dart' as transition;

class ProductAddScreen extends StatefulWidget {
  const ProductAddScreen({Key? key}) : super(key: key);

  @override
  _ProductAddScreenState createState() => _ProductAddScreenState();
}

class _ProductAddScreenState extends State<ProductAddScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  String? category;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        shadowColor: Colors.transparent,
        elevation: 0.0,
        title: const Text("Add Product", style: TextStyle(color: Colors.black)),
        actions: [
          TextButton(
            onPressed: () {
              if (_nameController.text.isNotEmpty && _priceController.text.isNotEmpty && _descriptionController.text.isNotEmpty && category != null) {
                Get.find<ApiController>().addProduct(_nameController.text, _priceController.text, category, _descriptionController.text, context);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Please fill all information.", style: TextStyle(color: Colors.black)), backgroundColor: Colors.white));
              }
            },
            child: const Text('Post'),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // SizedBox(height: size.height * 0.04),
              buildImagesList(size),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.push(context, transition.Transition(child: CameraScreen(cameras: Get.find<MyCameraController>().cameras), transitionEffect: transition.TransitionEffect.FADE));
                      },
                      child: const Text('Add More'),
                    ),
                  ],
                ),
              ),
              CustomProductTextFormField(size: size, label: "Name", controller: _nameController),
              SizedBox(height: size.height * 0.02),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.0),
                child: Text("Category", style: TextStyle(fontSize: 16.0)),
              ),
              SizedBox(height: size.height * 0.008),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20.0),
                padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
                width: double.infinity,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: DropDown(
                  showUnderline: false,
                  items: const ["Electronic", "Accessory", "Car"],
                  hint: const Text('Choose'),
                  icon: const Icon(Icons.expand_more, color: Colors.black),
                  onChanged: (p0) {
                    setState(() {
                      category = p0.toString();
                    });
                  },
                ),
              ),
              CustomProductTextFormField(size: size, label: "Price", controller: _priceController),
              CustomProductTextFormField(size: size, label: "Description", controller: _descriptionController, maxlines: 5),
              SizedBox(height: size.height * 0.04),
            ],
          ),
        ),
      ),
    );
  }

  buildImagesList(Size size) {
    return GetBuilder<ApiController>(
      builder: (controller) => Container(
        height: size.height * 0.2,
        decoration: const BoxDecoration(),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            children: [
              Expanded(
                child: ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  itemCount: controller.productImages.length,
                  itemBuilder: (context, index) => Stack(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 10.0),
                        margin: const EdgeInsets.all(10.0),
                        width: size.width * 0.2,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            // image: FileImage(File(controller.productImages[index]!.path)),
                            image: FileImage(controller.productImages[index]!),
                          ),
                        ),
                      ),
                      Positioned(
                        top: 10.0,
                        right: 10.0,
                        child: GestureDetector(
                          onTap: () {
                            Get.find<ApiController>().removeFromProductImages(index);
                          },
                          child: const Icon(Icons.delete, size: 18.0, color: Colors.red),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
