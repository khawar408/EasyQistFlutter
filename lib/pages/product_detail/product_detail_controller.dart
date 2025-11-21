import 'dart:convert';

import 'package:easyqist/api/ApiEndpoints.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../../models/ItemModel.dart';

class ProductDetailController extends GetxController {
  // final ProductRepository repository;

  // ProductDetailController(this.repository);

  var isLoading = true.obs;
  var detail = Rxn<ItemModel>();

  // selected values
  var selectedProductType = Rxn<ProductType>();
  var selectedInstallment = Rxn<InstallmentPlan>();

  Future<void> loadProduct(int id) async {
    try {
      isLoading.value = true;

      final url = Uri.parse("${ApiEndpoints.getProductDetail}?product_id=$id");

      final response = await http.get(url);

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);

        final data = SingleProductResponse.fromJson(jsonData);

        if (data.status == true && data.data != null) {
          detail.value = data.data;

          // Default type
          if (data.data!.productType.isNotEmpty) {
            selectedProductType.value = data.data!.productType.first;

            // Default installment
            if (data.data!.productType.first.productInstallment.isNotEmpty) {
              selectedInstallment.value =
                  data.data!.productType.first.productInstallment.first;
            }
          }
        }
      } else {
        print("Error: ${response.statusCode}");
      }
    } catch (e) {
      print("HTTP Error: $e");
    } finally {
      isLoading.value = false;
    }
  }

  // ==============================
  // When user selects product type
  // ==============================
  void selectProductType(ProductType type) {
    selectedProductType.value = type;

    // Reset installment for this type
    if (type.productInstallment.isNotEmpty) {
      selectedInstallment.value = type.productInstallment.first;
    }
  }

  // ==============================
  // When user selects installment plan
  // ==============================
  void selectInstallment(InstallmentPlan plan) {
    selectedInstallment.value = plan;
  }
}
