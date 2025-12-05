import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'cart_controller.dart';


class CartPage extends StatelessWidget {
  final controller = Get.put(CartController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("My Cart"),
        backgroundColor: Colors.green,
      ),

      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.cart.value == null ||
            controller.cart.value!.orderProducts!.isEmpty) {
          return const Center(child: Text("No products in cart"));
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
                          child: Image.network(
                            item.product.thumbnail ?? "",
                            height: 80,
                            width: 80,
                            fit: BoxFit.cover,
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
                                  IconButton(
                                    icon: const Icon(Icons.remove_circle, color: Colors.red),
                                    onPressed: () {
                                      controller.removeItem(index);
                                    },
                                  ),

                                  const SizedBox(width: 8),

                                  IconButton(
                                    icon: const Icon(Icons.remove),
                                    onPressed: () {
                                      if (item.qty! > 1) {
                                        controller.updateQty(index, item.qty! - 1);
                                      }
                                    },
                                  ),

                                  Text("${item.qty}", style: const TextStyle(fontSize: 18)),

                                  IconButton(
                                    icon: const Icon(Icons.add),
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
                    backgroundColor: Colors.green,
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
