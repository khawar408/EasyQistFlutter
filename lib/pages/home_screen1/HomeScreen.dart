import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';
import 'package:animations/animations.dart';

import '../../models/ItemModel.dart';
import 'home_controller.dart';



class HomeScreen extends StatelessWidget {
  HomeScreen({Key? key}) : super(key: key);
  final HomeController ctrl = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: SafeArea(
        child: Obx(() {
          if (ctrl.isLoading.value && ctrl.banners.isEmpty) {
            return _buildShimmerLoading();
          }

          return _animatedList();
        }),
      ),
    );
  }

  // 🩵 Facebook-style shimmer loader
  Widget _buildShimmerLoading() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: 6,
      itemBuilder: (_, index) {
        return Shimmer.fromColors(
          baseColor: Colors.grey.shade300,
          highlightColor: Colors.grey.shade100,
          child: Container(
            margin: const EdgeInsets.only(bottom: 16),
            height: index == 0 ? 180 : 120,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        );
      },
    );
  }

  // 🪄 Animated content list
  Widget _animatedList() {
    return PageTransitionSwitcher(
      duration: const Duration(milliseconds: 700),
      transitionBuilder: (child, animation, secondaryAnimation) =>
          FadeThroughTransition(
            animation: animation,
            secondaryAnimation: secondaryAnimation,
            child: child,
          ),
      child: CustomScrollView(
        key: ValueKey('mainList'),
        slivers: [
          SliverToBoxAdapter(child: _buildHeader()),
          SliverToBoxAdapter(child: _buildBanner()),
          SliverToBoxAdapter(child: _buildCategories()),
          SliverToBoxAdapter(child: _animatedSection("Latest Mobiles", ctrl.mobiles)),
          SliverToBoxAdapter(child: _animatedSection("Trending", ctrl.trending)),
          SliverToBoxAdapter(child: _animatedSection("Air Conditioner", ctrl.airs)),
          const SliverToBoxAdapter(child: SizedBox(height: 80)),
        ],
      ),
    );
  }

  // Section with animated entry — uses TweenAnimationBuilder for each item (no vsync)
  Widget _animatedSection(String title, List<ItemModel> list) {
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionTitle(title),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 600),
            child: list.isEmpty
                ? _buildShimmerGrid()
                : GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              itemCount: list.length,
              gridDelegate:
              const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.78,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
              ),
              itemBuilder: (_, i) {
                final item = list[i];
                // safe implicit animation per grid item
                return TweenAnimationBuilder<double>(
                  tween: Tween(begin: 12.0, end: 0.0),
                  duration: Duration(milliseconds: 300 + (i * 20)),
                  builder: (context, value, child) {
                    return Transform.translate(
                      offset: Offset(0, value),
                      child: Opacity(opacity: (12 - value) / 12 > 0 ? 1.0 : 1.0, child: child),
                    );
                  },
                  child: _productCard(item),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Row(children: [
        Expanded(
          child: Container(
            height: 48,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 6)],
            ),
            child: Row(children: [
              const Icon(Icons.search, color: Colors.grey),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  "Find the products you're looking for",
                  style: TextStyle(color: Colors.grey.shade700),
                ),
              ),
            ]),
          ),
        ),
        const SizedBox(width: 12),
        CircleAvatar(
          backgroundColor: Colors.green,
          child: Icon(Icons.notifications, color: Colors.white),
        ),
      ]),
    );
  }

  Widget _buildBanner() {
    return Obx(() {
      final banners = ctrl.banners;
      if (banners.isEmpty) return _shimmerBox(height: 180);

      return AnimatedSwitcher(
        duration: const Duration(milliseconds: 500),
        child: SizedBox(
          height: 180,
          key: ValueKey(banners.length),
          child: PageView.builder(
            itemCount: banners.length,
            onPageChanged: (i) => ctrl.setBannerIndex(i),
            itemBuilder: (_, i) {
              final b = banners[i];
              final img = b.mobileBanner ?? b.bannerImage ?? '';
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: CachedNetworkImage(
                    imageUrl: img,
                    fit: BoxFit.cover,
                    placeholder: (_, __) => _shimmerBox(height: 180),
                  ),
                ),
              );
            },
          ),
        ),
      );
    });
  }

  Widget _buildCategories() {
    return Obx(() {
      final cats = ctrl.categories;
      if (cats.isEmpty) return _shimmerBox(height: 100);

      return FadeIn(
        delay: const Duration(milliseconds: 200),
        child: SizedBox(
          height: 110,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            scrollDirection: Axis.horizontal,
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemCount: cats.length,
            itemBuilder: (_, i) {
              final c = cats[i];
              return Column(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: CachedNetworkImage(
                      imageUrl: c.categoryImage ?? '',
                      width: 90,
                      height: 70,
                      fit: BoxFit.cover,
                      placeholder: (_, __) => _shimmerBox(width: 90, height: 70),
                    ),
                  ),
                  const SizedBox(height: 6),
                  SizedBox(
                    width: 90,
                    child: Text(c.name ?? '',
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis),
                  )
                ],
              );
            },
          ),
        ),
      );
    });
  }

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
      child: Text(title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
    );
  }

  Widget _productCard(ItemModel item) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 6)],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CachedNetworkImage(
              imageUrl: item.thumbnail ?? '',
              height: 120,
              width: double.infinity,
              fit: BoxFit.cover,
              placeholder: (_, __) => _shimmerBox(height: 120),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(item.name ?? '',
                  maxLines: 2, overflow: TextOverflow.ellipsis),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                "Rs ${double.parse(item.price!).toStringAsFixed(0)}",
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),

            ),
          ],
        ),
      ),
    );
  }

  Widget _shimmerBox({double? width, double? height}) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Container(
        width: width ?? double.infinity,
        height: height ?? 100,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  Widget _buildShimmerGrid() {
    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      itemCount: 4,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.78,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemBuilder: (_, __) => _shimmerBox(height: 200),
    );
  }
}

class FadeIn extends StatefulWidget {
  final Widget child;
  final Duration delay;
  const FadeIn({super.key, required this.child, this.delay = Duration.zero});

  @override
  State<FadeIn> createState() => _FadeInState();
}

class _FadeInState extends State<FadeIn> with SingleTickerProviderStateMixin {
  double _opacity = 0;
  double _offsetY = 15;

  @override
  void initState() {
    super.initState();
    Timer(widget.delay, () {
      setState(() {
        _opacity = 1;
        _offsetY = 0;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      duration: const Duration(milliseconds: 600),
      opacity: _opacity,
      curve: Curves.easeOut,
      child: AnimatedSlide(
        duration: const Duration(milliseconds: 600),
        offset: Offset(0, _offsetY / 100),
        curve: Curves.easeOut,
        child: widget.child,
      ),
    );
  }
}
