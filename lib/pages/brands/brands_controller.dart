import 'dart:convert';
import 'package:easyqist/api/ApiEndpoints.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../models/brand_model.dart';


class BrandsController extends GetxController {
  var brands = <BrandResponse>[].obs;
  var isLoading = false.obs;



  Future<void> fetchBrands({int? categoryId}) async {
    try {
      isLoading(true);
      final uri = Uri.parse(ApiEndpoints.getAllBrand)
          .replace(queryParameters: {
        if (categoryId != null) "category_id": categoryId.toString(),
      });

      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        final apiResponse = ApiBrandResponse.fromJson(jsonData);
        if (apiResponse.status == true && apiResponse.data != null) {
          brands.assignAll(apiResponse.data!);
        } else {
          brands.clear();
        }
      } else {
        brands.clear();
      }
    } catch (e) {
      print("Error fetching brands: $e");
      brands.clear();
    } finally {
      isLoading(false);
    }
  }

  @override
  void onInit() {
    super.onInit();
   // fetchBrands();
  }
}
