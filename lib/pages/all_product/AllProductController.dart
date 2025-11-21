import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../../api/ApiEndpoints.dart';
import '../../models/ItemModel.dart';

class AllProductController extends GetxController {
  RxList<ItemModel> products = <ItemModel>[].obs;

  var isLoading = false.obs;
  var isMoreLoading = false.obs;

  var start = 0;
  final int limit = 30;
  var hasMore = true.obs;

  // Filters
  int? categoryId;
  int? brandId;
  String? name;
  int? priceMin;
  int? priceMax;

  // Trending flag
  bool isTrending = false;

  // Banner ID
  int? bannerId;

  final ScrollController scrollController = ScrollController();

  @override
  void onInit() {
    scrollController.addListener(_onScroll);
    super.onInit();
  }

  void updateFilters({
    int? categoryId,
    int? brandId,
    String? name,
    int? priceMin,
    int? priceMax,
    bool trending = false,
    int? bannerId,
  }) {
    this.categoryId = categoryId;
    this.brandId = brandId;
    this.name = name;
    this.priceMin = priceMin;
    this.priceMax = priceMax;
    this.isTrending = trending;
    this.bannerId = bannerId;

    refreshProducts();
  }

  Future<void> refreshProducts() async {
    start = 0;
    hasMore.value = true;
    products.clear();
    await fetchProducts(refresh: true);
  }

  Future<void> fetchProducts({bool refresh = false}) async {
    if (!hasMore.value) return;
    if (isLoading.value || isMoreLoading.value) return;

    if (refresh) {
      isLoading.value = true;
    } else {
      isMoreLoading.value = true;
    }

    try {
      String url;

      if (bannerId != null) {
        // ⭐ Banner products API
        url = "${ApiEndpoints.getBannerProducts}?banner_id=$bannerId&start=$start&limit=$limit";
      } else if (isTrending) {
        url = "${ApiEndpoints.getTrendingProducts}?start=$start&limit=$limit";
      } else {
        url = "${ApiEndpoints.getAllProductCategory}?start=$start&limit=$limit";
        if (categoryId != null) url += "&category_id=$categoryId";
        if (brandId != null) url += "&brand_id=$brandId";
        if (name != null) url += "&name=$name";
        if (priceMin != null) url += "&price_min=$priceMin";
        if (priceMax != null) url += "&price_max=$priceMax";
      }

      final res = await http.get(Uri.parse(url));
      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        final items = (data['data'] as List?)
            ?.map((e) => ItemModel.fromJson(e))
            .toList() ??
            [];

        if (items.isEmpty) hasMore.value = false;
        else {
          products.addAll(items);
          start += limit;
        }
      } else {
        print("Failed to load products: $url");
      }
    } catch (e) {
      print("Error fetching products: $e");
    }

    isLoading.value = false;
    isMoreLoading.value = false;
  }

  void _onScroll() {
    if (scrollController.position.pixels >=
        scrollController.position.maxScrollExtent - 200) {
      fetchProducts();
    }
  }
}
