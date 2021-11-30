import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:shopri/controllers/api_controller.dart';
import 'package:shopri/controllers/my_camera_controller.dart';
import 'package:shopri/controllers/category_controller.dart';
import 'package:shopri/controllers/query_controller.dart';
import 'package:shopri/views/init_loading.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(statusBarColor: Colors.white, statusBarIconBrightness: Brightness.dark));
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  Get.put<MyCameraController>(MyCameraController());
  Get.put<QueryController>(QueryController());
  Get.put<ApiController>(ApiController());
  Get.put<CategoryController>(CategoryController());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Shopri',
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
        primarySwatch: Colors.blue,
      ),
      home: const InitLoading(),
    );
  }
}
