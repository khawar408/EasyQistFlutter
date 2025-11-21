import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../api/ApiEndpoints.dart';
import '../../models/BannerModel.dart';
import '../../models/CategoryModel.dart';
import '../../models/ItemModel.dart';

class HomeController extends GetxController {
  var isLoading = true.obs;

  var trendingProducts = <ItemModel>[].obs;
  final banners = <BannerModel>[].obs;
  final categories = <CategoryModel>[].obs;
  var mobileProducts = <ItemModel>[].obs;
  var refProducts = <ItemModel>[].obs;
  var airProducts = <ItemModel>[].obs;

  final bannerIndex = 0.obs;
  final pageController = PageController();

  Timer? _timer;

  void setBannerIndex(int index) {
    bannerIndex.value = index;
  }

  void _startAutoScroll() {
    _timer = Timer.periodic(const Duration(seconds: 4), (_) {
      // Ensure banners loaded
      if (banners.isEmpty) return;

      // Ensure the PageController is attached to PageView
      if (!pageController.hasClients) return;

      int nextPage = bannerIndex.value + 1;
      if (nextPage >= banners.length) nextPage = 0;

      pageController.animateToPage(
        nextPage,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );

      setBannerIndex(nextPage);
    });
  }


  @override
  void onClose() {
    _timer?.cancel();
    pageController.dispose();
    super.onClose();
  }
  @override
  void onInit() {
    super.onInit();
    fetchHomeData();
    _startAutoScroll();
  }

  Future<void> fetchHomeData() async {
    await Future.delayed(const Duration(seconds: 2)); // simulate API delay
    isLoading.value = true;
    await Future.wait([
      fetchBanners(),
      fetchCategories(),
      fetchTrendingProducts(),
      fetchProductsByCategoryId(categoryId: 25,targetList:mobileProducts),
      fetchProductsByCategoryId(categoryId: 19,targetList:refProducts),
      fetchProductsByCategoryId(categoryId: 21,targetList:airProducts)
      // fetchMobiles(),
      // fetchAirConditioners()
    ]);
    isLoading.value = false;
  }

  // ------------------------
  // Fetch Banners
  // ------------------------
  Future<void> fetchBanners() async {
    try {
      final res = await http.get(Uri.parse(ApiEndpoints.getBanner));
      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        final list = (data is List) ? data : (data['data'] ?? []);
        banners.value = List<Map<String, dynamic>>.from(list)
            .map((e) => BannerModel.fromJson(e))
            .toList();
      }
    } catch (e) {
      print('Error fetching banners: $e');
    }
  }

  // ------------------------
  // Fetch Categories
  // ------------------------
  Future<void> fetchCategories() async {
    try {
      final res = await http.get(Uri.parse(ApiEndpoints.getCategory));
      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        final list = (data is List) ? data : (data['data'] ?? []);
        categories.value = List<Map<String, dynamic>>.from(list)
            .map((e) => CategoryModel.fromJson(e))
            .toList();
      }
    } catch (e) {
      print('Error fetching categories: $e');
    }
  }

  // ------------------------
  // Fetch Trending
  // ------------------------

  Future<void> fetchTrendingProducts() async {
    try {
      final url =
          "${ApiEndpoints.getTrendingProducts}?start=0&limit=10";
      final res = await http.get(Uri.parse(url));

      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        final productResponse = ProductResponse.fromJson(data);
        trendingProducts.value = productResponse.data ?? [];
      }
    } catch (e) {
      print('Error fetching trending products: $e');
    }
  }

  // ------------------------
// Fetch Products by Category
// ------------------------
  Future<void> fetchProductsByCategoryId({
    int? start,
    int? limit,
    int? categoryId,
    required RxList<ItemModel> targetList,
  }) async {
    try {
      final url =
          "${ApiEndpoints.getAllProductCategory}?start=${start ?? 0}&limit=${limit ?? 10}&category_id=${categoryId ?? 0}";

      final res = await http.get(Uri.parse(url));

      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        final productResponse = ProductResponse.fromJson(data);
        targetList.value = productResponse.data ?? [];
      } else {
        targetList.clear();
      }
    } catch (e) {
      print("Error fetching products for category $categoryId: $e");
      targetList.clear();
    }
  }

}
