import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../util/colors.dart';
import '../product_detail/product_detail_screen.dart';
import 'AllProductController.dart';

class AllProductScreen extends StatelessWidget {
  final AllProductController controller = Get.put(AllProductController());

  final int? categoryId;
  final int? brandId;
  final int? bannerId;
  final String? name;
  final int? priceMin;
  final int? priceMax;
  final bool trending;

  AllProductScreen({
    super.key,
    this.categoryId,
    this.brandId,
    this.bannerId,
    this.name,
    this.priceMin,
    this.priceMax,
    this.trending = false,
  }) {
    controller.updateFilters(
      categoryId: categoryId,
      brandId: brandId,
      bannerId: bannerId,
      name: name,
      priceMin: priceMin,
      priceMax: priceMax,
      trending: trending,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColors.primary, AppColors.primary, Colors.white],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),

          /// TOP TRANSPARENT HEADER IMAGE
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Image.asset(
              'assets/icons/upper_transparent.png',
              fit: BoxFit.cover,
              width: double.infinity,
              height: 220,
            ),
          ),

          SafeArea(
            child: Column(
              children: [
                AppBar(
                  title: Text(
                    trending ? "Trending Products" : "All Products",
                    style: TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  centerTitle: true,
                  leading: IconButton(
                    icon: Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () => Get.back(),
                  ),
                ),

                Expanded(
                  child: Container(
                    color: Color(0xFFF5F5F5),
                    child: Obx(() {
                      if (controller.isLoading.value &&
                          controller.products.isEmpty) {
                        return Center(child: CircularProgressIndicator());
                      }

                      if (controller.products.isEmpty) {
                        return Center(child: Text("No products found"));
                      }

                      return RefreshIndicator(
                        onRefresh: controller.refreshProducts,
                        child: GridView.builder(
                          controller: controller.scrollController,
                          padding: EdgeInsets.all(10),
                          itemCount: controller.products.length + 1,
                          gridDelegate:
                          SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: .73,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10,
                          ),
                          itemBuilder: (context, index) {
                            if (index == controller.products.length) {
                              return Obx(() => controller.isMoreLoading.value
                                  ? Center(child: CircularProgressIndicator())
                                  : SizedBox.shrink());
                            }

                            final p = controller.products[index];

                            final img = (p.thumbnail?.isNotEmpty ?? false)
                                ? p.thumbnail!
                                : (p.productImage?.isNotEmpty ?? false)
                                ? p.productImage!.first.imageName ?? ''
                                : '';

                            final hasAdvance = p.advance != null &&
                                p.advance!.isNotEmpty &&
                                p.advance != '0';

                            final amountToShow = hasAdvance
                                ? 'Rs ${p.advance} Advance'
                                : 'Rs ${p.price}';

                            return GestureDetector(
                              onTap: () {
                                if (p.id != null) {
                                  Get.to(() => ProductDetailScreen(
                                    productId: p.id!,
                                  ));
                                }
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.shade300,
                                      blurRadius: 4,
                                      offset: Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.vertical(
                                          top: Radius.circular(12)),
                                      child: CachedNetworkImage(
                                        imageUrl: img,
                                        height: 140,
                                        width: double.infinity,
                                        fit: BoxFit.contain,
                                        errorWidget: (_, __, ___) =>
                                            Icon(Icons.broken_image, size: 40),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Text(
                                        p.name ?? '',
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 8.0),
                                      child: Text(
                                        amountToShow,
                                        style: TextStyle(
                                          color: AppColors.primary,
                                          fontWeight: FontWeight.bold,
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
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
