import 'package:easyqist/util/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../models/ItemModel.dart';
import 'product_detail_controller.dart';

class ProductDetailScreen extends StatelessWidget {
  final int productId;

  ProductDetailScreen({super.key, required this.productId});

  final controller = Get.put(ProductDetailController());

  @override
  Widget build(BuildContext context) {
    controller.loadProduct(productId);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        final item = controller.detail.value;
        if (item == null) {
          return const Center(child: Text("Product not found"));
        }

        final selectedType = controller.selectedProductType.value;
        final selectedPlan = controller.selectedInstallment.value;

        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              // =====================================
              // PRODUCT IMAGE
              // =====================================
              Container(
                height: 280,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  image: item.thumbnail != null
                      ? DecorationImage(
                    image: NetworkImage(item.thumbnail!),
                    fit: BoxFit.cover,
                  )
                      : null,
                ),
              ),

              const SizedBox(height: 16),

              // =====================================
              // PRODUCT NAME
              // =====================================
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  item.name ?? "",
                  style:
                  const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
              ),

              const SizedBox(height: 20),

              // =====================================
              // PRODUCT TYPE SELECTOR
              // =====================================
              _buildProductTypes(item),

              const SizedBox(height: 20),

              // =====================================
              // INSTALLMENT SELECTOR
              // =====================================
              if (selectedType != null) _buildInstallmentOptions(selectedType),

              const SizedBox(height: 28),

              // =====================================
              // INSTALLMENT SUMMARY BOX
              // =====================================
              if (selectedPlan != null) _buildSummary(selectedPlan),

              const SizedBox(height: 40),
            ],
          ),
        );
      }),
    );
  }

  // **********************************************************************************************
  // PRODUCT TYPES (Buttons)
  // **********************************************************************************************

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
            children: item.productType.map((type) {
              return Obx(() {
                final selected = controller.selectedProductType.value == type;

                return GestureDetector(
                  onTap: () => controller.selectProductType(type),
                  child: Container(
                    padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    decoration: BoxDecoration(
                      color: selected ?AppColors.primary : Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: selected ? AppColors.primary : Colors.grey.shade400,
                      ),
                    ),
                    child: Text(
                      type.title ?? "",
                      style: TextStyle(
                        color: selected ? Colors.white : Colors.black,
                      ),
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

  // **********************************************************************************************
  // INSTALLMENT PLANS
  // **********************************************************************************************

  Widget _buildInstallmentOptions(ProductType type) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Installment Plans",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
          const SizedBox(height: 12),

          Wrap(
            spacing: 10,
            children: type.productInstallment.map((plan) {
              return Obx(() {
                final selected = controller.selectedInstallment.value == plan;

                return GestureDetector(
                  onTap: () => controller.selectInstallment(plan),
                  child: Container(
                    padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                    decoration: BoxDecoration(
                      color: selected ? AppColors.primary : Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: selected ? AppColors.primary : Colors.grey.shade400,
                      ),
                    ),
                    child: Text(
                      "${plan.duration} ${plan.durationType}",
                      style: TextStyle(
                        color: selected ? Colors.white : Colors.black,
                      ),
                    ),
                  ),
                );
              });
            }).toList(),
          )
        ],
      ),
    );
  }

  // **********************************************************************************************
  // SUMMARY BOX
  // **********************************************************************************************

  Widget _buildSummary(InstallmentPlan p) {
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
          _row("Down Payment", "Rs ${p.advance ?? '0'}"),
          _row("Monthly Payment", "Rs ${p.amount ?? '0'}"),
          _row("Total Amount", "Rs ${p.totalAmount ?? '0'}"),
          const SizedBox(height: 10),
          Text(
            "${p.duration} ${p.durationType}",
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          )
        ],
      ),
    );
  }

  Widget _row(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
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
