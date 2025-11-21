import 'package:cached_network_image/cached_network_image.dart';
import 'package:easyqist/util/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../brands/brands_screen.dart';
import 'CategoryController.dart';

class CategoriesScreen extends StatelessWidget {
  final CategoryController controller = Get.put(CategoryController());

  CategoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
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

          // Top background image (behind status bar)
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Image.asset(
              'assets/icons/upper_transparent.png',
              fit: BoxFit.cover,
              width: double.infinity,
              height: 250, // adjust height as needed
            ),
          ),

          // Foreground content
          SafeArea(
            child: Column(
              children: [
                AppBar(
                  title: const Text(
                    "Categories",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  centerTitle: true,
                ),
                Expanded(
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Color(0xFFF5F5F5), // white background for the grid
                      // borderRadius: BorderRadius.only(
                      //   topLeft: Radius.circular(24),
                      //   topRight: Radius.circular(24),
                      // ),
                    ),
                    child: Obx(() {
                      if (controller.isLoading.value) {
                        return const Center(
                            child: CircularProgressIndicator());
                      }

                      if (controller.categories.isEmpty) {
                        return const Center(child: Text("No categories found"));
                      }

                      return Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: GridView.builder(
                          itemCount: controller.categories.length,
                          gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisSpacing: 12,
                            crossAxisSpacing: 12,
                            childAspectRatio: 1,
                          ),
                          itemBuilder: (context, index) {
                            final category = controller.categories[index];
                            return CategoryTile(
                              name: category.name!,
                              image: category.categoryImage!,categoryId: category.id!,
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

class CategoryTile extends StatelessWidget {
  final String name;
  final String image;
  final int categoryId; // add this

  const CategoryTile({
    super.key,
    required this.name,
    required this.image,
    required this.categoryId, // add this
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        // Navigate to BrandsScreen with categoryId
        Get.to(() => BrandsScreen(categoryId: categoryId));
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 4,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: CachedNetworkImage(
                  imageUrl: image,
                  fit: BoxFit.contain,
                  placeholder: (context, url) =>
                  const Center(child: CircularProgressIndicator()),
                  errorWidget: (context, url, error) => const Icon(
                    Icons.image_not_supported,
                    color: Colors.grey,
                    size: 40,
                  ),
                ),
              ),
            ),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
              decoration: BoxDecoration(
                color: const Color(0xFFE0E0E0),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(12),
                  bottomRight: Radius.circular(12),
                ),
              ),
              child: Text(
                name,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                  color: Colors.black87,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

