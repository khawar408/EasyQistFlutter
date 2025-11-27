import 'package:cached_network_image/cached_network_image.dart';
import 'package:easyqist/util/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../models/ItemModel.dart';
import 'fullscreen_image_viewer.dart';
import 'product_detail_controller.dart';

class ProductDetailScreen extends StatelessWidget {
  final int productId;

  ProductDetailScreen({super.key, required this.productId});

  final controller = Get.put(ProductDetailController());

  @override
  Widget build(BuildContext context) {
    controller.loadProduct(productId);

    return Scaffold(
      backgroundColor:  Color(0xFFF5F5F5),

      // ADD TO CART BUTTON AT BOTTOM
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 8,
              offset: Offset(0, -2),
            )
          ],
        ),
        child: SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: () {

            },
            child: const Text(
              "Add to Cart",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        final item = controller.detail.value;
        final selectedType = controller.selectedProductType.value;

        if (item == null) {
          return const Center(child: Text("Product not found"));
        }

        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              // -----------------------------------------------------------
              // PRODUCT IMAGES
              // -----------------------------------------------------------
              _buildImageSlider(item),
              const SizedBox(height: 20),

              // -----------------------------------------------------------
              // PRODUCT NAME
              // -----------------------------------------------------------
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  item.name ?? "",
                  style:
                  const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
              ),

              // DESCRIPTION
              if ((item.description ?? "").isNotEmpty)
                Padding(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Text(
                    item.description ?? "",
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.black54,
                      height: 1.4,
                    ),
                  ),
                ),

              const SizedBox(height: 20),

              // -----------------------------------------------------------
              // PRODUCT TYPE SELECTOR
              // -----------------------------------------------------------
              _buildProductTypes(item),
              const SizedBox(height: 25),

              // -----------------------------------------------------------
              // INSTALLMENT OPTIONS
              // -----------------------------------------------------------
              if (selectedType != null)
                _buildInstallmentOptions(selectedType),

              const SizedBox(height: 40),
              // ===========================
              // DESCRIPTION AT THE END
              // ===========================
              if ((item.detailDescription ?? "").isNotEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                  child: Text(
                    item.detailDescription ?? "",
                    style: const TextStyle(
                      fontSize: 15,
                      height: 1.5,
                      color: Colors.black87,
                    ),
                  ),
                ),

              const SizedBox(height: 100), // space above Add to Cart button
            ],
          ),
        );
      }),
    );
  }

  // ================================================================================
  // IMAGE SLIDER
  // ================================================================================

  Widget _buildImageSlider(ItemModel item) {
    final images = item.productImage.map((e) => e.imageName ?? "").toList();

    return Column(
      children: [
        GestureDetector(
          onTap: () {
            Get.to(() => FullScreenImageViewer(
              images: images,
              initialIndex: controller.currentImageIndex.value,
            ));
          },
          onHorizontalDragStart: (_) => controller.onUserSwipeStart(),
          onHorizontalDragEnd: (_) => controller.onUserSwipeEnd(),
          child: SizedBox(
            height: 280,
            child: PageView.builder(
              controller: controller.imgPageController,
              itemCount: images.length,
              onPageChanged: (i) => controller.currentImageIndex.value = i,
              itemBuilder: (_, index) {
                final img = images[index];

                return Obx(() {
                  final isActive =
                      controller.currentImageIndex.value == index;

                  return AnimatedOpacity(
                    opacity: isActive ? 1.0 : 0.4,
                    duration: const Duration(milliseconds: 300),
                    child: AnimatedScale(
                      scale: isActive ? 1.0 : 0.92,
                      duration: const Duration(milliseconds: 300),
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: Colors.grey.shade200,
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Container(
                        margin: const EdgeInsets.only(top: 20),  // 👈 ADD TOP MARGIN HERE
                        child: CachedNetworkImage(
                          imageUrl: img,
                          fit: BoxFit.contain,
                          placeholder: (_, __) => Container(
                            color: Colors.grey.shade300,
                            child: const Center(
                              child: CircularProgressIndicator(strokeWidth: 2),
                            ),
                          ),
                          errorWidget: (_, __, ___) =>
                          const Icon(Icons.broken_image, size: 40),
                        ),
                      ),

                    ),
                      ),
                    ),
                  );
                });
              },
            ),
          ),
        ),

        const SizedBox(height: 12),

        // DOT INDICATOR
        Obx(() {
          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(images.length, (index) {
              bool active = controller.currentImageIndex.value == index;

              return AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                margin: const EdgeInsets.symmetric(horizontal: 4),
                width: active ? 14 : 8,
                height: 8,
                decoration: BoxDecoration(
                  color: active ? AppColors.primary : Colors.grey.shade400,
                  borderRadius: BorderRadius.circular(6),
                ),
              );
            }),
          );
        }),
      ],
    );
  }

  // ================================================================================
  // PRODUCT TYPE SELECTOR
  // ================================================================================

  Widget _buildProductTypes(ItemModel item) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Product Type",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
          const SizedBox(height: 12),

          Wrap(
            spacing: 10,
            runSpacing: 5, // vertical spacing set to zero
            children: item.productType.map((type) {
              return Obx(() {
                final isSelected = controller.selectedProductType.value == type;

                return GestureDetector(
                  onTap: () => controller.selectProductType(type),
                  child: Container(
                    padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    decoration: BoxDecoration(
                      color: isSelected ? AppColors.primary : Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: isSelected
                            ? AppColors.primary
                            : Colors.grey.shade400,
                      ),
                    ),
                    child: Text(
                      type.title ?? "",
                      style: TextStyle(
                          color: isSelected ? Colors.white : Colors.black),
                    ),
                  ),
                );
              });
            }).toList(),
          ),
        ],
      ),
    );
  }

  // ================================================================================
  // INSTALLMENT FILTERS
  // ================================================================================

  Widget _buildInstallmentOptions(ProductType type) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ----------------- Duration -----------------
          const Text("Installment Duration",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
          const SizedBox(height: 12),

          Obx(() {
            return Wrap(
              spacing: 10,
              runSpacing: 5,
              children: controller.displayDurations.map((label) {
                final selected = controller.selectedDuration.value ==
                    (label == "Cash price"
                        ? "1"
                        : label.replaceAll(" months", ""));

                return _option(label, selected, () {
                  controller.changeDuration(label, type);
                });
              }).toList(),
            );
          }),

          const SizedBox(height: 25),

          // ----------------- Percentage -----------------
          const Text("Down Payment",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
          const SizedBox(height: 12),

          Obx(() {
            return Wrap(
              spacing: 10,
              runSpacing: 5,
              children: controller.displayPercentages.map((label) {
                final selected = controller.selectedPercentage.value ==
                    (label == "Normal Plan"
                        ? 0
                        : int.parse(label.replaceAll("%", "")));

                return _option(label, selected, () {
                  controller.changePercentage(label, type);
                });
              }).toList(),
            );
          }),

          const SizedBox(height: 25),

          // ----------------- Summary -----------------
          Obx(() {
            if (controller.filteredInstallments.isEmpty) {
              return const SizedBox();
            }
            return _buildSummary(controller.filteredInstallments.first);
          }),
        ],
      ),
    );
  }

  Widget _option(String text, bool selected, Function onTap) {
    return GestureDetector(
      onTap: () => onTap(),
      child: Container(
        padding:
        const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
        decoration: BoxDecoration(
          color: selected ? AppColors.primary : Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: selected ? AppColors.primary : Colors.grey.shade400,
          ),
        ),
        child: Text(
          text,
          style:
          TextStyle(color: selected ? Colors.white : Colors.black),
        ),
      ),
    );
  }

  // ================================================================================
  // SUMMARY BOX
  // ================================================================================

  Widget _buildSummary(InstallmentPlan p) {
    // Cash price detection → duration = "1"
    final bool isCashPrice = (p.duration?.toString() == "1");

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.green.shade50,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.green.shade300),
      ),
      child: Column(
        children: [
          _row(
            isCashPrice ? "Cash Price" : "Down Payment",
            "Rs ${p.advance ?? '0'}",
          ),

          if (!isCashPrice)
            _row("Monthly Payment", "Rs ${p.amount ?? '0'}"),

          if (!isCashPrice)
          _row("Total Amount", "Rs ${p.totalAmount ?? '0'}"),

          const SizedBox(height: 10),
          // Text(
          //   "${p.duration} ${p.durationType}",
          //   style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          // )
        ],
      ),
    );
  }


  Widget _row(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title,
              style:
              const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
          Text(value,
              style:
              const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}
