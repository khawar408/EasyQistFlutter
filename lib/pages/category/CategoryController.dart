import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../api/ApiEndpoints.dart';
import '../../models/CategoryModel.dart';


class CategoryController extends GetxController {
  var isLoading = false.obs;
  var categories = <CategoryModel>[].obs;

  final String baseUrl = "https://your-domain.com/api"; // 🔁 Change to your API domain

  @override
  void onInit() {
    super.onInit();
    fetchCategories();
  }

  Future<void> fetchCategories() async {
    try {
      isLoading.value = true;
      final response = await http.get(Uri.parse(ApiEndpoints.getCategory));

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        final apiResponse = CategoryResponse.fromJson(jsonData);

        if (apiResponse.status == true && apiResponse.data != null) {
          categories.assignAll(apiResponse.data!);
        } else {
          Get.snackbar("Error", apiResponse.message ?? "Failed to load data");
        }
      } else {
        Get.snackbar("Error", "Server returned ${response.statusCode}");
      }
    } catch (e) {
      Get.snackbar("Error", "Something went wrong: $e");
    } finally {
      isLoading.value = false;
    }
  }
}
