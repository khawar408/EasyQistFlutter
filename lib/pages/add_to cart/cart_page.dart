import 'package:cached_network_image/cached_network_image.dart';
import 'package:easyqist/util/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../all_product/AllProductScreen.dart';
import '../product_detail/product_detail_screen.dart';
import 'cart_controller.dart';


class CartPage extends StatelessWidget {
  final controller = Get.put(CartController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("My Cart"),
          backgroundColor: AppColors.primary,
      ),

      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.cart.value == null ||
            controller.cart.value!.orderProducts!.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Empty Cart Image
                SizedBox(
                  height: 180,
                  child: Image.asset(
                    "assets/icons/empty_cart.png", // change path if needed
                    fit: BoxFit.contain,
                  ),
                ),

                const SizedBox(height: 20),

                const Text(
                  "No products in cart",
                  style: TextStyle(
                    fontSize: 18,
                    color: AppColors.textColor
                  ),
                ),

                const SizedBox(height: 20),

                // Search Products Button
                ElevatedButton(
                  onPressed: () {
                    // TODO: navigate to search screen
                    Get.to(() => AllProductScreen());
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    "Search Products",
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ],
            ),
          );
        }


        return Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: controller.cart.value!.orderProducts!.length,
                itemBuilder: (context, index) {
                  final item =
                  controller.cart.value!.orderProducts![index];

                  return Container(
                    margin: const EdgeInsets.all(12),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 4,
                        )
                      ],
                    ),
                    child: Row(
                      children: [
                        // Thumbnail
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: CachedNetworkImage(
                            imageUrl: item.product.thumbnail ?? "",
                            height: 80,
                            width: 80,
                            fit: BoxFit.cover,
                            placeholder: (context, url) => Container(
                              height: 80,
                              width: 80,
                              color: Colors.grey.shade300,
                              child: const Center(
                                child: CircularProgressIndicator(strokeWidth: 2),
                              ),
                            ),
                            errorWidget: (context, url, error) => Container(
                              height: 80,
                              width: 80,
                              color: Colors.grey.shade300,
                              child: const Icon(Icons.error, color: Colors.red),
                            ),
                          ),
                        ),


                        const SizedBox(width: 12),

                        // INFO
                        Expanded(
                          child: Column(
                            crossAxisAlignment:
                            CrossAxisAlignment.start,
                            children: [
                              Text(
                                item.product.name ?? "",
                                style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold),
                              ),

                              const SizedBox(height: 6),

                              Text(
                                "Total Price: Rs. ${item.orderProductAmount}",
                                style: const TextStyle(
                                    color: Colors.green),
                              ),

                              Text(
                                "Advance: Rs. ${item.orderProductAdvanceAmount}",
                                style: const TextStyle(
                                    color: Colors.grey),
                              ),

                              Text(
                                "Installments: ${item.orderProductDuration}",
                                style: const TextStyle(
                                    color: Colors.grey),
                              ),

                              const SizedBox(height: 6),

                              // QTY
                              Row(
                                children: [
                                  const SizedBox(width: 90),
                                  IconButton(
                                    icon: const Icon(Icons.remove_circle, color: Colors.red),
                                    onPressed: () {
                                      if( item.qty!>1){
                                        controller.updateQty(index, item.qty! - 1);

                                      }else {
                                        controller.removeItem(index);
                                      }
                                    },
                                  ),

                                  Text("${item.qty}", style: const TextStyle(fontSize: 18)),

                                  IconButton(
                                    icon: const Icon(Icons.add_circle, color: Colors.green),
                                    onPressed: () {
                                      controller.updateQty(index, item.qty! + 1);
                                    },
                                  ),
                                ],
                              )

                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),

            // Bottom totals
            _bottomTotals(),
          ],
        );
      }),
    );
  }

  Widget _bottomTotals() {
    return Obx(() {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(color: Colors.black12, blurRadius: 4),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment:
              MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Total Advance",
                  style: TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Text(
                  "Rs. ${controller.totalAdvance.value}",
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ],
            ),

            Row(
              mainAxisAlignment:
              MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Total Amount",
                  style: TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Text(
                  "Rs. ${controller.totalAmount.value}",
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ],
            ),

            const SizedBox(height: 10),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    padding: const EdgeInsets.all(14)),
                onPressed: () {},
                child: const Text(
                  "Proceed to Checkout",
                  style: TextStyle(fontSize: 16),
                ),
              ),
            )
          ],
        ),
      );
    });
  }
}
