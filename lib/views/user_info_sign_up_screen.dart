import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shopri/controllers/api_controller.dart';
import 'package:shopri/views/components/auth_widgets.dart';
import 'package:shopri/views/components/custom_material_button.dart';

class UserInfoSignUpScreen extends StatefulWidget {
  const UserInfoSignUpScreen({Key? key, required this.phoneNumber}) : super(key: key);
  final String phoneNumber;

  @override
  _UserInfoSignUpScreenState createState() => _UserInfoSignUpScreenState();
}

class _UserInfoSignUpScreenState extends State<UserInfoSignUpScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  File? profileImage;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: size.height * 0.02),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.0),
                child: Text('Sign up', style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.w600)),
              ),
              SizedBox(height: size.height * 0.04),
              GestureDetector(
                onTap: () {
                  showModalBottomSheet(
                    context: context,
                    builder: (context) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SizedBox(height: size.height * 0.02),
                            CustomMaterialButton(
                              onPressed: () async {
                                final ImagePicker _picker = ImagePicker();
                                // Capture a photo
                                final XFile? photo = await _picker.pickImage(source: ImageSource.camera);
                                setState(() {
                                  profileImage = File(photo!.path);
                                });
                                Navigator.pop(context);
                              },
                              btnLabel: "Camera",
                            ),
                            SizedBox(height: size.height * 0.02),
                            CustomMaterialButton(
                              onPressed: () async {
                                final ImagePicker _picker = ImagePicker();
                                // Pick an image
                                final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
                                setState(() {
                                  profileImage = File(image!.path);
                                });
                                Navigator.pop(context);
                              },
                              btnLabel: "Gallery",
                            ),
                            SizedBox(height: size.height * 0.02),
                          ],
                        ),
                      );
                    },
                  );
                },
                child: Center(
                  child: Stack(
                    children: [
                      Container(
                        height: size.height * 0.18,
                        width: size.height * 0.18,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.grey.shade200,
                          image: profileImage == null ? null : DecorationImage(image: FileImage(profileImage!)),
                        ),
                      ),
                      profileImage == null ? Positioned(right: 10.0, bottom: 5.0, child: Icon(Icons.image, size: size.height * 0.06)) : const SizedBox.shrink(),
                    ],
                  ),
                ),
              ),
              SizedBox(height: size.height * 0.06),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: CustomTextFormFieldAuth(
                  controller: _usernameController,
                  keyboardType: TextInputType.name,
                  onchanged: (value) {},
                  prefixText: "Username",
                  paddingRight: 20.0,
                ),
              ),
              SizedBox(height: size.height * 0.02),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: CustomTextFormFieldAuth(
                  controller: _emailController,
                  keyboardType: TextInputType.name,
                  onchanged: (value) {},
                  prefixText: "Email",
                  paddingRight: 53.0,
                ),
              ),
              SizedBox(height: size.height * 0.04),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: CustomMaterialButton(
                  onPressed: () {
                    if (_usernameController.text.isNotEmpty && _emailController.text.isNotEmpty && profileImage != null) {
                      //* execute the sign up
                      Get.find<ApiController>().signUpUser(
                        File(profileImage!.path),
                        "",
                        _usernameController.text,
                        _emailController.text,
                        widget.phoneNumber,
                        context,
                      );
                    }
                  },
                  btnLabel: "Sign up",
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
