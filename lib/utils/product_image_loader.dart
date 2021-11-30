import 'package:shopri/constants/api_path.dart';

String getProductImage(String imageName) {
  return "$kbaseUrl/product/$imageName";
  // http://localhost:4000/product/95b9452f-0b97-4508-873d-4f9bcb0da06b.jpg
}
