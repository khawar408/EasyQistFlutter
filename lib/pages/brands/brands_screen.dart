import 'package:cached_network_image/cached_network_image.dart';
import 'package:easyqist/util/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'brands_controller.dart';
import '../all_product/AllProductScreen.dart';

class BrandsScreen extends StatelessWidget {
  final BrandsController controller = Get.put(BrandsController());
  final int? categoryId;
  BrandsScreen({super.key, this.categoryId});

  @override
  Widget build(BuildContext context) {
    controller.fetchBrands(categoryId: categoryId);

    return Scaffold(
      backgroundColor: Colors.transparent,
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

          // Top background image
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

          // Foreground content
          SafeArea(
            child: Column(
              children: [
                AppBar(
                  title: const Text(
                    "Brands",
                    style: TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  centerTitle: true,
                  leading: categoryId != null
                      ? IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () => Get.back(),
                  )
                      : null,
                ),

                Expanded(
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Color(0xFFF5F5F5),
                    ),
                    child: Obx(() {
                      if (controller.isLoading.value) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      if (controller.brands.isEmpty) {
                        return const Center(child: Text("No brands found"));
                      }

                      return Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: GridView.builder(
                          itemCount: controller.brands.length,
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisSpacing: 12,
                            crossAxisSpacing: 12,
                            childAspectRatio: 1.0,
                          ),
                          itemBuilder: (context, index) {
                            final brand = controller.brands[index];
                            return GestureDetector(
                              onTap: () {
                                // Open AllProductScreen with brandId and optional categoryId
                                Get.to(() => AllProductScreen(
                                  brandId: brand.id,
                                  categoryId: categoryId,
                                ));
                              },
                              child: BrandTile(
                                image: brand.brandImage ?? '',
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

class BrandTile extends StatelessWidget {
  final String image;

  const BrandTile({super.key, required this.image});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
            offset: const Offset(2, 2),
          ),
        ],
      ),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: CachedNetworkImage(
            imageUrl: image,
            fit: BoxFit.contain,
            height: 90,
            width: 90,
            placeholder: (context, url) =>
            const Center(child: CircularProgressIndicator()),
            errorWidget: (context, url, error) =>
                Icon(Icons.broken_image, size: 50, color: Colors.grey.shade400),
          ),
        ),
      ),
    );
  }
}
