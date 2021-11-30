import 'package:shopri/constants/api_path.dart';

String getProfileImageUrl(String imageName) {
  return "$kbaseUrl/profile/$imageName";
  //http://localhost:4000/profile/c7a91e49-a1e1-403f-aecd-cd1649765cf9.png
}
