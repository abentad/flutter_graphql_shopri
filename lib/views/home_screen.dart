import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:shopri/controllers/api_controller.dart';
import 'package:shopri/utils/profile_image_loader.dart';
import 'package:shopri/views/components/home_screen/home_screen_bottom_nav_bar.dart';
import 'package:shopri/views/components/home_screen/home_screen_drawer.dart';
import 'package:shopri/views/components/product_card.dart';
import 'package:shopri/views/components/refresh_widget.dart';
import 'package:shopri/views/components/scroll_to_hide_widget.dart';
import 'package:shopri/views/components/widgets.dart';
import 'package:shopri/views/product_detail_screen.dart';
import 'package:transition/transition.dart' as transition;
import 'package:lottie/lottie.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key, required this.userInfo}) : super(key: key);
  final Map<String, dynamic>? userInfo;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  DateTime timeBackPressed = DateTime.now();
  late ScrollController scrollController;
  late int pageToLoad;
  bool isLoading = false;
  String? loadInfo;

  @override
  void initState() {
    print("User: " + widget.userInfo!['username'].toString().capitalize!);
    scrollController = ScrollController();
    scrollController.addListener(() async {
      if (scrollController.position.pixels == scrollController.position.maxScrollExtent) {
        if (!isLoading) {
          fetchData(isInit: false);
        }
      }
    });
    pageToLoad = 1;
    fetchData(isInit: true);
    super.initState();
  }

  Future<void> fetchData({required bool isInit}) async {
    if (isInit) {
      setState(() {
        pageToLoad = 1;
      });
    }
    // print("fetch data called");
    setState(() {
      isLoading = true;
    });
    // print("loading...");
    // print(isLoading);
    loadInfo = await Get.find<ApiController>().getProducts(pageToLoad);
    setState(() {});
    // print("loadInfo: $loadInfo");
    if (loadInfo == 'done') {
      setState(() {
        pageToLoad++;
        isLoading = false;
      });
    } else if (loadInfo == 'fail') {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: const Text('Something went wrong', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.grey.shade300,
      ));
    }
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: () async {
        final difference = DateTime.now().difference(timeBackPressed);
        final isExitWarning = difference >= const Duration(seconds: 2);
        timeBackPressed = DateTime.now();
        if (isExitWarning) {
          const message = "Press back again to exit";
          Fluttertoast.showToast(msg: message, toastLength: Toast.LENGTH_SHORT, fontSize: 16.0);
          return false;
        } else {
          Fluttertoast.cancel();
          return true;
        }
      },
      child: Scaffold(
        drawer: const HomeScreenDrawer(),
        body: SafeArea(
          child: Stack(
            children: [
              NotificationListener<OverscrollIndicatorNotification>(
                onNotification: (notification) {
                  notification.disallowGlow();
                  return false;
                },
                child: RefreshWidget(
                  onrefresh: () => fetchData(isInit: true),
                  child: CustomScrollView(
                    controller: scrollController,
                    slivers: [
                      SliverPersistentHeader(
                        floating: true,
                        delegate: SliverAppBarDelegate(
                          minHeight: size.height * 0.07,
                          maxHeight: size.height * 0.07,
                          child: Container(
                            decoration: const BoxDecoration(
                              color: Colors.white,
                            ),
                            child: Column(
                              children: [
                                SizedBox(
                                  height: size.height * 0.07,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                                    decoration: BoxDecoration(color: Colors.white, boxShadow: [BoxShadow(color: Colors.grey.shade200, offset: const Offset(2, 2), blurRadius: 10.0)]),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        const Icon(Icons.star_outline),
                                        const FlutterLogo(),
                                        InkWell(
                                          onTap: () {
                                            Get.find<ApiController>().signOutUser(context);
                                          },
                                          borderRadius: BorderRadius.circular(50.0),
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.circular(50.0),
                                            child: Image(image: NetworkImage(getProfileImageUrl(widget.userInfo!['profile_image'])), height: 35.0, width: 35.0),
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
                      ),
                      SliverToBoxAdapter(child: Container(height: size.height * 0.02)),
                      GetBuilder<ApiController>(
                        builder: (controller) => SliverStaggeredGrid.countBuilder(
                          staggeredTileBuilder: (index) => const StaggeredTile.fit(1),
                          crossAxisCount: 2,
                          mainAxisSpacing: 20.0,
                          crossAxisSpacing: 0.0,
                          itemCount: controller.products.length,
                          itemBuilder: (context, index) {
                            final product = controller.products[index];
                            print("FirstImageHeight: ${product['height']}");
                            print("FirstImageWidth: ${product['width']}");
                            print("FirstImageblurHash: ${product['blurHash']}");
                            print("deviceHeight: ${size.height}");
                            print("deviceWidth: ${size.width}");
                            print("calculatedHeight: ${double.parse(product['height'].toString()) / size.height * 100}");
                            print("calculatedWidth: ${double.parse(product['width'].toString()) / size.width * 100}");
                            return Material(
                              color: Colors.transparent,
                              child: ProductCard(
                                ontap: () {
                                  Navigator.push(context, transition.Transition(child: ProductDetailScreen(product: product), transitionEffect: transition.TransitionEffect.FADE));
                                },
                                name: product['name'],
                                price: product['price'],
                                image: product['image'],
                                imageHeight: product['height'],
                                imageWidth: product['width'],
                                blurHash: product['blurHash'],
                                index: index,
                                size: size,
                                hasShadows: true,
                              ),
                            );
                          },
                        ),
                      ),
                      loadInfo != "over"
                          ? isLoading
                              ? SliverToBoxAdapter(child: SizedBox(child: Center(child: Lottie.asset('assets/loading.json', height: size.height * 0.1, width: size.width * 0.1))))
                              // : const SliverToBoxAdapter(child: SizedBox.shrink())
                              // : SliverToBoxAdapter(child: SizedBox(child: Center(child: Lottie.asset('assets/loading.json', height: size.height * 0.1, width: size.width * 0.1))))
                              : const SliverToBoxAdapter(child: SizedBox.shrink())
                          : const SliverToBoxAdapter(child: Center(child: Text("No more data")))
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: ScrollToHideWidget(controller: scrollController, widgetHeight: 60.0, child: const BuildBottomNavBar()),
        floatingActionButton: ScrollToScaleWidget(controller: scrollController, duration: const Duration(milliseconds: 300), child: const BuildFloatingActoinButton()),
      ),
    );
  }
}
