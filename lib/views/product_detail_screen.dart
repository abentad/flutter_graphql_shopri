import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_time_ago/get_time_ago.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:shopri/controllers/api_controller.dart';
import 'package:shopri/utils/call_number.dart';
import 'package:shopri/utils/price_format.dart';
import 'package:shopri/utils/product_image_loader.dart';
import 'package:shopri/utils/profile_image_loader.dart';
import 'package:shopri/views/product_image_detail_screen.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:transition/transition.dart' as transition;

class ProductDetailScreen extends StatefulWidget {
  const ProductDetailScreen({Key? key, required this.product}) : super(key: key);
  final Map<String, dynamic> product;

  @override
  _ProductDetailScreenState createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  Map<String, dynamic>? productInfo;
  int activeIndex = 0;

  @override
  void initState() {
    productInfo = widget.product;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: GetBuilder<ApiController>(
        builder: (controller) => SafeArea(
          child: Stack(
            children: [
              NotificationListener<OverscrollIndicatorNotification>(
                onNotification: (notification) {
                  notification.disallowGlow();
                  return false;
                },
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      //Carousel image
                      Stack(
                        children: [
                          Container(
                            width: double.infinity,
                            height: 300.0,
                            decoration: BoxDecoration(color: Colors.grey.shade100),
                            child: CarouselSlider.builder(
                              itemCount: productInfo!['images'].length,
                              itemBuilder: (context, index, realIndex) {
                                return GestureDetector(
                                  onTap: () {
                                    print('Tapped on page $realIndex');
                                    Navigator.push(
                                      context,
                                      transition.Transition(
                                        child: ProductImageDetail(productImageName: productInfo!['images'][index]['url']),
                                        transitionEffect: transition.TransitionEffect.FADE,
                                        curve: Curves.decelerate,
                                      ),
                                    );
                                  },
                                  child: CachedNetworkImage(
                                    imageUrl: getProductImage(productInfo!['images'][index]['url']),
                                    fit: BoxFit.contain,
                                  ),
                                );
                              },
                              options: CarouselOptions(
                                enableInfiniteScroll: false,
                                height: 300.0,
                                aspectRatio: 16 / 9,
                                viewportFraction: 0.8,
                                initialPage: 0,
                                reverse: false,
                                // autoPlay: true,
                                autoPlayInterval: const Duration(seconds: 3),
                                autoPlayAnimationDuration: const Duration(milliseconds: 800),
                                autoPlayCurve: Curves.fastOutSlowIn,
                                enlargeCenterPage: true,
                                onPageChanged: (index, reason) {
                                  setState(() {
                                    activeIndex = index;
                                  });
                                },
                                scrollDirection: Axis.horizontal,
                              ),
                            ),
                          ),
                          Positioned(
                            left: 0.0,
                            right: 0.0,
                            top: 5.0,
                            child: Center(
                              child: AnimatedSmoothIndicator(
                                activeIndex: activeIndex,
                                count: productInfo!['images'].length,
                                effect: SlideEffect(
                                  activeDotColor: Colors.greenAccent,
                                  dotColor: Colors.grey,
                                  spacing: 8.0,
                                  radius: 4.0,
                                  dotWidth: productInfo!['images'].length > 1 ? size.width / productInfo!['images'].length : 0.0,
                                  dotHeight: 5.0,
                                  strokeWidth: 1.5,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: size.height * 0.02),
                      Padding(
                        padding: const EdgeInsets.only(left: 20.0, top: 10.0, right: 20.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '${productInfo!['name'].toString().capitalize}',
                              style: const TextStyle(fontSize: 26.0, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              '${formatPrice(productInfo!['price'])} Birr',
                              style: const TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold, color: Colors.teal),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: size.height * 0.01),
                      //
                      Padding(
                        padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Posted ${GetTimeAgo.parse(DateTime.parse(productInfo!['datePosted'].toString()))}",
                              style: const TextStyle(fontSize: 14.0, color: Colors.grey, fontWeight: FontWeight.w600),
                            ),
                            Row(
                              children: [
                                const Icon(MdiIcons.eye, color: Colors.grey),
                                SizedBox(width: size.width * 0.02),
                                Text(productInfo!['views'].toString(), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0)),
                              ],
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: size.height * 0.02),

                      Padding(
                        padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              padding: const EdgeInsets.only(left: 15.0, top: 10.0, bottom: 10.0, right: 15.0),
                              decoration: BoxDecoration(
                                // color: Colors.grey.shade100,
                                borderRadius: BorderRadius.circular(10.0),
                                border: Border.all(color: Colors.teal),
                              ),
                              child: Text(
                                productInfo!['category'].toString(),
                                style: const TextStyle(fontSize: 14.0, color: Colors.black, fontWeight: FontWeight.w600),
                              ),
                            ),
                            Row(
                              children: [
                                Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                    borderRadius: BorderRadius.circular(10.0),
                                    onTap: () async {
                                      //TODO: integrate the share button functionality
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 5.0),
                                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(10.0), color: const Color(0xfff2f2f2)),
                                      child: const Center(
                                        child: Icon(MdiIcons.share, size: 32.0),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(width: size.width * 0.02),
                                Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                    borderRadius: BorderRadius.circular(10.0),
                                    onTap: () async {
                                      showDialog(
                                        context: context,
                                        builder: (context) => AlertDialog(
                                          title: const Text("Report"),
                                          content: TextFormField(
                                            autofocus: true,
                                            maxLines: 5,
                                            decoration: InputDecoration(
                                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0), borderSide: BorderSide(color: Colors.grey.shade300)),
                                              focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0), borderSide: BorderSide(color: Colors.grey.shade300)),
                                              enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0), borderSide: BorderSide(color: Colors.grey.shade300)),
                                            ),
                                          ),
                                          actions: [
                                            TextButton(
                                              onPressed: () => Navigator.pop(context),
                                              child: const Text('Cancel'),
                                            ),
                                            TextButton(
                                              onPressed: () {},
                                              child: const Text('Submit'),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 5.0),
                                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(10.0), color: const Color(0xfff2f2f2)),
                                      child: const Center(
                                        child: Icon(MdiIcons.flag, size: 32.0),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: size.height * 0.02),
                      const Padding(
                        padding: EdgeInsets.only(left: 20.0, right: 20.0),
                        child: Text(
                          'Description',
                          style: TextStyle(fontSize: 16.0, color: Colors.black, fontWeight: FontWeight.w600),
                        ),
                      ),
                      SizedBox(height: size.height * 0.02),
                      Padding(
                        padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                        child: Text(
                          productInfo!['description'].toString(),
                          style: const TextStyle(fontSize: 16.0),
                        ),
                      ),
                      SizedBox(height: size.height * 0.4)
                    ],
                  ),
                ),
              ),
              Positioned(
                bottom: 10.0,
                left: 0.0,
                right: 0.0,
                child: Column(
                  children: [
                    //advertiser tab
                    Material(
                      color: Colors.transparent,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(10.0),
                          onTap: () async {
                            //TODO: integrate the account info
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade100,
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            child: Row(
                              children: [
                                SizedBox(
                                  height: size.height * 0.035,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(5.0),
                                    child: CachedNetworkImage(
                                      imageUrl: getProfileImageUrl(productInfo!['poster']['profile_image']),
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                ),
                                SizedBox(width: size.width * 0.04),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      productInfo!['poster']['username'].toString().capitalize!,
                                      style: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.w600),
                                    ),
                                    SizedBox(height: size.height * 0.005),
                                    Text(productInfo!['poster']['phoneNumber'].toString()),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    // SizedBox(height: size.height * 0.02),
                    Container(
                      height: size.height * 0.02,
                      decoration: const BoxDecoration(color: Colors.white),
                    ),

                    Get.find<ApiController>().loggedInUserInfo!['id'].toString() != productInfo!['poster']['id']
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              SizedBox(width: size.width * 0.02),
                              MaterialButton(
                                onPressed: () {
                                  callNumber(productInfo!['poster']['phoneNumber'].toString());
                                },
                                color: Colors.white,
                                splashColor: Colors.grey.shade200,
                                elevation: 0.0,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0), side: const BorderSide(color: Colors.teal, width: 1.0)),
                                height: 50.0,
                                child: const Icon(Icons.phone, color: Colors.black),
                              ),
                              SizedBox(width: size.width * 0.02),
                              Expanded(
                                child: MaterialButton(
                                  onPressed: () {},
                                  color: Colors.teal,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
                                  height: 50.0,
                                  child: Text('Message ${productInfo!['poster']['username'].toString().capitalize}', style: const TextStyle(color: Colors.white)),
                                ),
                              ),
                              SizedBox(width: size.width * 0.02),
                            ],
                          )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              SizedBox(width: size.width * 0.02),
                              Expanded(
                                child: MaterialButton(
                                  onPressed: () {},
                                  color: Colors.orange,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
                                  height: 50.0,
                                  child: const Text('Set Sold', style: TextStyle(color: Colors.white)),
                                ),
                              ),
                              SizedBox(width: size.width * 0.02),
                            ],
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
