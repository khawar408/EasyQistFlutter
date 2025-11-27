import 'dart:convert';
import 'package:easyqist/api/ApiEndpoints.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../../models/ItemModel.dart';

class ProductDetailController extends GetxController {
  var isLoading = true.obs;
  var detail = Rxn<ItemModel>();

  // selections
  var selectedProductType = Rxn<ProductType>();

  // new filters
  var selectedDuration = "".obs;
  var selectedPercentage = 0.obs;

  // UI lists
  var displayDurations = <String>[].obs;
  var displayPercentages = <String>[].obs;

  var filteredInstallments = <InstallmentPlan>[].obs;

  // image slider
  var currentImageIndex = 0.obs;
  late PageController imgPageController;
  var autoScrollEnabled = true.obs;

  // ==============================
  // Load Product
  // ==============================
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

          // Default Type
          if (data.data!.productType.isNotEmpty) {
            selectedProductType.value = data.data!.productType.first;
            loadInstallments(data.data!.productType.first);
          }
        }
      }
    } catch (e) {
      print("Error: $e");
    } finally {
      isLoading.value = false;
    }
  }

  // ==============================
  // Load Installments
  // ==============================
  void loadInstallments(ProductType type) {
    final allPlans = type.productInstallment;

    // ---- Extract durations ----
    List<String> rawDurations = allPlans
        .map((p) => p.duration ?? "")
        .where((d) => d.isNotEmpty)
        .toSet()
        .toList();

    // Convert to display format
    displayDurations.value = rawDurations.map((d) {
      return d == "1" ? "Cash price" : "$d months";
    }).toList();

    // Auto-select first duration
    changeDuration(displayDurations.first, type);
  }

  // ==============================
  // When Duration is Selected
  // ==============================
  void changeDuration(String displayText, ProductType type) {
    selectedDuration.value =
    displayText == "Cash price" ? "1" : displayText.replaceAll(" months", "");

    final plans = type.productInstallment
        .where((p) => p.duration == selectedDuration.value)
        .toList();

    // ---- Extract percentages ----
    List<int> rawPercentages =
    plans.map((e) => e.downpaymentPercentage).toSet().toList();

    displayPercentages.value = rawPercentages
        .map((p) => p == 0 ? "Normal Plan" : "$p%")
        .toList();

    // Sort: Normal Plan → 10% → 20%
    displayPercentages.sort((a, b) {
      if (a == "Normal Plan") return -1;
      if (b == "Normal Plan") return 1;
      return int.parse(a.replaceAll("%", ""))
          .compareTo(int.parse(b.replaceAll("%", "")));
    });

    // Auto-select first percentage
    changePercentage(displayPercentages.first, type);
  }

  // ==============================
  // When Percentage is Selected
  // ==============================
  void changePercentage(String label, ProductType type) {
    selectedPercentage.value =
    label == "Normal Plan" ? 0 : int.parse(label.replaceAll("%", ""));

    filteredInstallments.value = type.productInstallment.where((p) {
      return p.duration == selectedDuration.value &&
          p.downpaymentPercentage == selectedPercentage.value;
    }).toList();
  }

  // ==============================
  // Change Product Type
  // ==============================
  void selectProductType(ProductType type) {
    selectedProductType.value = type;
    loadInstallments(type);
  }

  // ==============================
  // Image Auto Scroll
  // ==============================
  @override
  void onInit() {
    super.onInit();
    imgPageController = PageController();
    WidgetsBinding.instance.addPostFrameCallback((_) => _startAutoScroll());
  }

  void _startAutoScroll() async {
    while (true) {
      await Future.delayed(const Duration(seconds: 3));

      if (!autoScrollEnabled.value) continue;
      if (detail.value?.productImage.isEmpty ?? true) continue;

      final total = detail.value!.productImage.length;
      final next = (currentImageIndex.value + 1) % total;

      if (imgPageController.positions.isNotEmpty) {
        imgPageController.animateToPage(
          next,
          duration: const Duration(milliseconds: 600),
          curve: Curves.easeInOut,
        );
      }

      currentImageIndex.value = next;
    }
  }

  void onUserSwipeStart() => autoScrollEnabled.value = false;

  void onUserSwipeEnd() {
    Future.delayed(const Duration(seconds: 5), () {
      autoScrollEnabled.value = true;
    });
  }
}
