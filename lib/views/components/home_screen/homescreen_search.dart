import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shopri/controllers/api_controller.dart';
import 'package:shopri/utils/profile_image_loader.dart';

class HomeScreenSearchBar extends StatelessWidget {
  const HomeScreenSearchBar({Key? key, required this.size, required this.onProfileTap}) : super(key: key);

  final Size size;
  final Function() onProfileTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextFormField(
              cursorColor: Colors.black,
              style: const TextStyle(fontSize: 18.0, color: Colors.black),
              textInputAction: TextInputAction.search,
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 30.0),
                prefixIcon: const Icon(Icons.search),
                hintText: 'search',
                hintStyle: const TextStyle(color: Colors.grey, fontSize: 16.0),
                enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0), borderSide: const BorderSide(color: Colors.transparent, width: 1.0)),
                focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0), borderSide: const BorderSide(color: Colors.transparent, width: 1.0)),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0), borderSide: const BorderSide(color: Colors.transparent, width: 1.0)),
              ),
            ),
          ),
          SizedBox(width: size.width * 0.06),
          InkWell(
            onTap: onProfileTap,
            borderRadius: BorderRadius.circular(50.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(50.0),
              child: Image(
                image: NetworkImage(getProfileImageUrl(Get.find<ApiController>().loggedInUserInfo!['profile_image'])),
                height: 35.0,
                width: 35.0,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
