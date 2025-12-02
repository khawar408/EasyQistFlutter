import 'package:cached_network_image/cached_network_image.dart';
import 'package:easyqist/util/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:marquee/marquee.dart';
import 'package:shimmer/shimmer.dart';

import '../../models/ItemModel.dart';
import '../../util/Singleton.dart';
import '../all_product/AllProductScreen.dart';
import '../brands/brands_screen.dart';
import '../home_screen1/HomeScreen.dart';
import '../product_detail/product_detail_screen.dart';
import 'home_controller.dart';


class HomeScreen extends StatelessWidget {
  final HomeController controller = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent, // make transparent to show layers
      body: Stack(
        children: [
          // Gradient background
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.primary,
                  AppColors.primary,
                  Colors.white,
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),

          // Transparent background image
           Image.asset(
              'assets/icons/upper_transparent.png', // your existing background image
              fit: BoxFit.cover,
              width: double.infinity,
              height: 220,
            ),

          // Foreground content (same as your current code)
          SafeArea(
            child: Obx(() {
              if (controller.isLoading.value) {
                return _buildShimmerUI();
              } else {
                return ListView(
                  children: [
                    _buildLocationBanner(),
                    _buildHeader(),
                    _buildBanner(),
                    _buildVerificationRow(),
                    _buildCategories(),

                    // Section with background
                    Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('assets/icons/home_lower_background.png'), // your section background
                          fit: BoxFit.cover,
                        ),
                      ),
                      child: Column(
                        children: [
                          buildProductSection('Trending Products', controller.trendingProducts, isTrending: true),

                          buildProductSection('Mobile', controller.mobileProducts, categoryId: 25),

                          buildBannerImage("assets/icons/mobilebanner.png", height: 220, categoryId: 25),

                          buildProductSection('Refrigerator', controller.refProducts, categoryId: 19),

                          buildBannerImage("assets/icons/ref.png", height: 220, categoryId: 19),

                          buildProductSection('Air conditioner', controller.airProducts, categoryId: 21),

                          buildBannerImage("assets/icons/air.png", height: 220, categoryId: 21),

                          // _buildProductList(controller.latestMobiles),
                          // _buildSectionTitle('Air Conditioner'),
                          // _buildProductList(controller.airConditioners),
                        ],
                      ),
                    ),
                  ],
                );

              }
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildLocationBanner() {
    return Container(
      height: 25,
      child: Marquee(
        text: 'Currently the service is available only in Lahore   فی الحال یہ سروس صرف لاہور میں دستیاب ہے۔',
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 15,
        ),
        scrollAxis: Axis.horizontal,
        crossAxisAlignment: CrossAxisAlignment.start,
        blankSpace: 50.0,
        velocity: 50.0,
        startPadding: 10.0,
        pauseAfterRound: Duration(seconds: 1),
      ),
    );
  }

  Widget _buildCategories() {
    final ScrollController _scrollController = ScrollController();

    void _scrollNext() {
      const scrollAmount = 220.0;
      _scrollController.animateTo(
        _scrollController.offset + scrollAmount,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }

    return Obx(() {
      final cats = controller.categories;
      if (cats.isEmpty) return _shimmerBox(height: 180);

      return Container(
        color: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 8),
        height: 220, // increased to prevent overflow
        child: Stack(
          children: [
            // Scrollable grid (2 rows)
            Padding(
              padding: const EdgeInsets.only(right: 10), // space for arrow
              child: GridView.builder(
                controller: _scrollController,
                scrollDirection: Axis.horizontal,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, // two rows
                  mainAxisSpacing: 8, // ↓ was 16
                  crossAxisSpacing: 6, // ↓ was 10
                  childAspectRatio: 1.0, // slightly more square, less padding effect
                ),
                itemCount: cats.length,
                itemBuilder: (context, index) {
                  final c = cats[index];
                  return GestureDetector(
                    onTap: () {
                      Get.to(() => BrandsScreen(categoryId: c.id));
                    },
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // ---- image box ----
                        Container(
                          width: 75,
                          height: 55,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(14),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.shade100,
                                blurRadius: 2,
                                offset: const Offset(0, 1),
                              ),
                            ],
                          ),
                          padding: const EdgeInsets.all(6),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: CachedNetworkImage(
                              imageUrl: c.categoryImage ?? '',
                              fit: BoxFit.contain,
                              placeholder: (_, __) =>
                                  _shimmerBox(width: 55, height: 55),
                              errorWidget: (_, __, ___) => const Icon(Icons.broken_image),
                            ),
                          ),
                        ),

                        const SizedBox(height: 4),

                        // ---- name ----
                        SizedBox(
                          width: 75,
                          child: Text(
                            c.name ?? '',
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 9,
                              fontWeight: FontWeight.w500,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );

                },
              ),

            ),

            // Right scroll arrow with gradient overlay
            Positioned(
              right: 0,
              top: 0,
              bottom: 0,
              child: Center(
                child: Container(
                  width: 36,
                  height: 50, // adjust this to control the size of the half-circle
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(25),
                      bottomLeft: Radius.circular(25),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.shade300,
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: IconButton(
                    padding: EdgeInsets.zero,
                    icon: const Icon(Icons.arrow_forward_ios, size: 18),
                    onPressed: _scrollNext,
                    color: Colors.black,
                  ),
                ),
              ),
            ),

          ],
        ),
      );
    });
  }






  /// 🟢 Header Section (with logo, icons, and search bar)
  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.only(left: 16, right: 16, bottom: 8),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              /// App logo
              Row(
                children: [
                  Container(
                    width: 120,
                    height: 60,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/logo/logo.png'),
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ],
              ),

              /// Icons
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Obx(() {
                    final count = Singleton.getViewCartOrder.value?.orderProducts?.length ?? 0;
                    return Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Icon(
                          Icons.shopping_bag_outlined,
                          color: Colors.white,
                          size: 26,
                        ),
                        if (count > 0)
                          Positioned(
                            right: -6,
                            top: -6,
                            child: Container(
                              padding: const EdgeInsets.all(2),
                              decoration: BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: Colors.white, width: 1),
                              ),
                              constraints: const BoxConstraints(
                                minWidth: 16,
                                minHeight: 16,
                              ),
                              child: Text(
                                '$count',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                      ],
                    );
                  }),
                ],
              ),

            ],
          ),
          const SizedBox(height: 5),

          /// Search bar
          TextField(
            textInputAction: TextInputAction.done, // Shows "Done" on the keyboard
            onSubmitted: (value) {
              final searchText = value.trim();
              if (searchText.isNotEmpty) {
                // Navigate to AllProductScreen with search query
                Get.to(() => AllProductScreen(name: searchText));
              }
            },
            decoration: InputDecoration(
              hintText: "Find the product you’re looking for",
              prefixIcon: const Icon(Icons.search, color: Colors.grey),
              filled: true,
              fillColor: Colors.white,
              contentPadding:
              const EdgeInsets.symmetric(vertical: 0, horizontal: 12),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: BorderSide.none,
              ),
            ),
          ),

        ],
      ),
    );
  }

  /// 🔶 Banner section
  Widget _buildBanner() {
    return Obx(() {
      final banners = controller.banners;
      if (banners.isEmpty) return _shimmerBox(height: 180);

      return AnimatedSwitcher(
        duration: const Duration(milliseconds: 500),
        child: SizedBox(
          height: 220,
          key: ValueKey(banners.length),
          child: PageView.builder(
            key: PageStorageKey("banner_page_view"),
            controller: controller.pageController,
            itemCount: banners.length,
            onPageChanged: (i) => controller.setBannerIndex(i),
            itemBuilder: (_, i) {
              final b = banners[i];
              final img = b.mobileBanner ?? b.bannerImage ?? '';
              return GestureDetector(
                onTap: () {
                  if (b.id != null) {
                    Get.to(() => AllProductScreen(
                      bannerId: b.id,
                    ));
                  }
                },
                child: CachedNetworkImage(
                  imageUrl: img,
                  fit: BoxFit.fill,
                  placeholder: (_, __) => _shimmerBox(height: 180),
                  errorWidget: (_, __, ___) =>
                      Container(color: Colors.grey.shade200),
                ),
              );
            },
          ),
        ),
      );
    });
  }


  Widget _buildVerificationRow() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade300,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // 1️⃣ Easy Verification
          _buildVerificationItem(
            'assets/icons/easy_verfication.png',
            'Easy Verification Process',
          ),

          // 2️⃣ No Bank Account
          _buildVerificationItem(
            'assets/icons/no_bank_card.png',
            'No Bank Account / Card Required',
          ),

          // 3️⃣ No Documentation
          _buildVerificationItem(
            'assets/icons/no_document.png',
            'No Documentation Charges',
          ),
        ],
      ),
    );
  }

  Widget _buildVerificationItem(String icon, String text) {
    return Expanded(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            icon,
            width: 16,
            height: 16,
            fit: BoxFit.contain,
          ),
          const SizedBox(width: 5),
          Flexible(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 10,
                color: Color(0xFF333333), // similar to header_text_color
                fontWeight: FontWeight.w500,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  /// Section title row
  Widget _buildSectionTitle(String title, VoidCallback onViewAllTap) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),

          GestureDetector(
            onTap: onViewAllTap,
            child: const Text(
              "View all",
              style: TextStyle(
                color: Colors.green,
                fontSize: 14,
                decoration: TextDecoration.underline,
              ),
            ),
          ),
        ],
      ),
    );
  }


  /// Product list (Latest Mobiles / AC)
  Widget _buildProductList(List<Map<String, String>> products) {
    return SizedBox(
      height: 250,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: products.length,
        itemBuilder: (context, index) {
          final p = products[index];
          return Container(
            width: 160,
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(12)),
                  child: CachedNetworkImage(
                    imageUrl: p["image"]!,
                    height: 140,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    placeholder: (context, url) =>
                        _shimmerBox(height: 140, width: double.infinity),
                    errorWidget: (context, url, error) =>
                    const Icon(Icons.error),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(p["name"]!,
                      style: const TextStyle(
                          fontSize: 14, fontWeight: FontWeight.w600)),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text("Rs ${p["price"]}",
                      style: const TextStyle(
                          color: Colors.green, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  /// Samsung promotion banner
  Widget buildBannerImage(
      String assetImage, {
        double height = 120,
        double radius = 0,
        int? categoryId,
      }) {
    return GestureDetector(
      onTap: () {
        Get.to(() => AllProductScreen(categoryId: categoryId));
      },
      child: Container(
        margin: const EdgeInsets.all(0),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(radius),
          child: Image.asset(
            assetImage,
            height: height,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }


  /// Shimmer placeholder UI (while loading)
  Widget _buildShimmerUI() {
    return ListView(
      children: [
        _shimmerBox(height: 120, width: double.infinity, radius: 0),
        const SizedBox(height: 16),
        _shimmerBox(height: 150, width: double.infinity),
        const SizedBox(height: 16),
        _shimmerList(),
        const SizedBox(height: 16),
        _shimmerBox(height: 150, width: double.infinity),
        const SizedBox(height: 16),
        _shimmerList(),
      ],
    );
  }

  Widget _shimmerBox({double? height, double? width, double radius = 12}) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(radius),
        ),
      ),
    );
  }

  Widget _shimmerList() {
    return SizedBox(
      height: 230,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 2,
        itemBuilder: (context, index) =>
            _shimmerBox(height: 230, width: 160),
      ),
    );
  }

  Widget buildProductSection(String title, RxList<ItemModel> products,
      {bool isTrending = false, int? categoryId}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 🔥 Pass the callback for View All
        _buildSectionTitle(
          title,
              () {
            if (isTrending) {
              Get.to(() => AllProductScreen(trending: true));
            } else {
              Get.to(() => AllProductScreen(categoryId: categoryId));
            }
          },
        ),

        Obx(() {
          final list = products;
          if (list.isEmpty) return _shimmerBox(height: 230);

          return SizedBox(
            height: 260,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: list.length,
              itemBuilder: (context, index) {
                final p = list[index];

                final img = (p.thumbnail?.isNotEmpty ?? false)
                    ? p.thumbnail!
                    : (p.productImage?.isNotEmpty ?? false)
                    ? p.productImage!.first.imageName ?? ''
                    : '';

                final bool hasAdvance =
                    p.advance != null && p.advance!.isNotEmpty && p.advance != '0';

                final String amountToShow = hasAdvance
                    ? 'Rs ${p.advance} Advance'
                    : 'Rs ${p.price ?? '0'}';

                return GestureDetector(
                  onTap: () {
                    if (isTrending) {
                      Get.to(() => ProductDetailScreen(productId: p.id!));
                    } else {
                      Get.to(() => ProductDetailScreen(productId: p.id!));
                    }
                  },
                  child: Container(
                    width: 160,
                    margin: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.shade300,
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius:
                          const BorderRadius.vertical(top: Radius.circular(12)),
                          child: CachedNetworkImage(
                            imageUrl: img,
                            height: 140,
                            width: double.infinity,
                            fit: BoxFit.contain,
                            placeholder: (_, __) =>
                                _shimmerBox(height: 140, width: double.infinity),
                            errorWidget: (_, __, ___) => Container(
                              height: 140,
                              color: Colors.grey.shade200,
                              child: const Icon(Icons.broken_image,
                                  size: 40, color: Colors.grey),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            p.name ?? '',
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8.0, vertical: 2),
                          child: Text(
                            amountToShow,
                            style: TextStyle(
                              color: AppColors.primary,
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        }),
      ],
    );
  }





}
