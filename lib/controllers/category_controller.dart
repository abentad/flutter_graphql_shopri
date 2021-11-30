import 'package:get/get.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class CategoryController extends GetxController {
  final List<Map<String, dynamic>> _homeScreenCategories = [
    {"name": "Electronic", "icon": MdiIcons.laptop},
    {"name": "Car", "icon": MdiIcons.car},
    {"name": "Accessory", "icon": MdiIcons.battery},
    {"name": "Shoe", "icon": MdiIcons.shoePrint},
    {},
  ];

  List<Map<String, dynamic>> get homeScreenCategories => _homeScreenCategories;
}
