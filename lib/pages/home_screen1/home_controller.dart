import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../api/ApiEndpoints.dart';
import '../../models/BannerModel.dart';
import '../../models/CategoryModel.dart';
import '../../models/ItemModel.dart';

enum HomeNavigation {
  categoriesViewAll,
  trendViewAll,
  category1,
  category2,
  category3,
  search,
  addToCart,
  whatsapp,
  mobile,
  refri,
  air,
  requestProduct,
  requestClose,
}

class HomeController extends GetxController {
  // ------------------------
  // Observable State
  // ------------------------
  final isLoading = false.obs;
  final banners = <BannerModel>[].obs;
  final categories = <CategoryModel>[].obs;
  final trending = <ItemModel>[].obs;
  final mobiles = <ItemModel>[].obs;
  final airs = <ItemModel>[].obs;

  // Navigation event trigger
  final activityToStart = Rxn<HomeNavigation>();

  // Observable fields (mirroring ObservableField<String> from Android)
  final categoryImage1 = ''.obs;
  final categoryName1 = ''.obs;
  final categoryImage2 = ''.obs;
  final categoryName2 = ''.obs;
  final categoryImage3 = ''.obs;
  final categoryName3 = ''.obs;

  final addToCart = false.obs;

  final name = 'Guest User'.obs;
  final address = ''.obs;
  final mobileImage =
      'http://16.170.92.243:5000/banner/banner_image_1713285383952.jpeg'.obs;
  final refImage =
      'http://16.170.92.243:5000/banner/banner_image_1713285383952.jpeg'.obs;
  final airImage =
      'http://16.170.92.243:5000/banner/banner_image_1713285383952.jpeg'.obs;

  var bannerIndex = 0.obs; // Add this

  // Optional: update banner index when page changes
  void setBannerIndex(int index) {
    bannerIndex.value = index;
  }

  // ------------------------
  // Lifecycle
  // ------------------------
  @override
  void onInit() {
    super.onInit();
    fetchHomeData();
  }

  // ------------------------
  // Fetch All Home Data
  // ------------------------
  Future<void> fetchHomeData() async {
    isLoading.value = true;
    await Future.wait([
      fetchBanners(),
      fetchCategories(),
      fetchTrendingProducts(),
    fetchMobiles(),
    fetchAirConditioners()
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

  // ✅ Fetch Trending Products
  Future<void> fetchTrendingProducts() async {
    await _fetchProducts(ApiEndpoints.getTrendingProducts, trending);
  }

  // ✅ Fetch Mobiles
  Future<void> fetchMobiles() async {
    await _fetchProducts(ApiEndpoints.getAllProducts, mobiles);
  }

  // ✅ Fetch Air Conditioners
  Future<void> fetchAirConditioners() async {
    await _fetchProducts(ApiEndpoints.getAllProductCategory, airs);
  }

  // 🔥 Generic Fetch Method (reusable for all types)
  Future<void> _fetchProducts(String endpoint, RxList<ItemModel> targetList) async {
    try {
      final fullUrl = endpoint.startsWith('http')
          ? Uri.parse(endpoint)
          : Uri.parse("${ApiEndpoints.baseUrl}$endpoint?start=0&limit=5");

      print("🔗 Fetching: $fullUrl");

      final res = await http.get(fullUrl);

      if (res.statusCode == 200) {
        final jsonData = jsonDecode(res.body);

        if (jsonData is Map<String, dynamic> && jsonData.containsKey('status')) {
          final productResponse = ProductResponse.fromJson(jsonData);

          if (productResponse.status == true && productResponse.data != null) {
            targetList.assignAll(productResponse.data!);
            print("✅ Loaded ${productResponse.data!.length} products from $fullUrl");
          } else {
            print("⚠️ Invalid data from $fullUrl: ${jsonData['data']}");
          }
        } else {
          print("⚠️ Non-JSON data returned from $fullUrl");
        }
      } else {
        print("❌ Request failed for $fullUrl: ${res.statusCode}");
      }
    } catch (e) {
      print("🔥 Error fetching $endpoint: $e");
    }
  }



  // ------------------------
  // Navigation (like HomeNavigation enum in Kotlin)
  // ------------------------
  void clickOnTrending() => activityToStart.value = HomeNavigation.trendViewAll;
  void clickOnCategories() =>
      activityToStart.value = HomeNavigation.categoriesViewAll;
  void clickOnCategory1() => activityToStart.value = HomeNavigation.category1;
  void clickOnCategory2() => activityToStart.value = HomeNavigation.category2;
  void clickOnCategory3() => activityToStart.value = HomeNavigation.category3;
  void clickOnSearch() => activityToStart.value = HomeNavigation.search;
  void clickOnAddToCart() => activityToStart.value = HomeNavigation.addToCart;
  void clickOnWhatsapp() => activityToStart.value = HomeNavigation.whatsapp;
  void clickOnMobile() => activityToStart.value = HomeNavigation.mobile;
  void clickOnRef() => activityToStart.value = HomeNavigation.refri;
  void clickOnAir() => activityToStart.value = HomeNavigation.air;
  void clickOnRequestProduct() =>
      activityToStart.value = HomeNavigation.requestProduct;
}
