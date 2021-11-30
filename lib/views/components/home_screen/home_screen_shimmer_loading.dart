import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:shimmer/shimmer.dart';

class HomeScreenShimmerLoading extends StatelessWidget {
  const HomeScreenShimmerLoading({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Shimmer.fromColors(
              baseColor: Colors.grey.shade400,
              highlightColor: Colors.grey.shade300,
              child: Container(
                height: size.height * 0.2,
                decoration: const BoxDecoration(color: Colors.white),
              ),
            ),
          ),
          SliverStaggeredGrid.countBuilder(
            staggeredTileBuilder: (index) => const StaggeredTile.fit(1),
            crossAxisCount: 2,
            mainAxisSpacing: 20.0,
            crossAxisSpacing: 10.0,
            itemCount: 6,
            itemBuilder: (context, index) {
              return Shimmer.fromColors(
                baseColor: Colors.grey.shade400,
                highlightColor: Colors.grey.shade300,
                period: const Duration(seconds: 2),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  height: size.height * 0.15,
                  width: double.infinity,
                  decoration: BoxDecoration(color: Colors.grey.shade200),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
