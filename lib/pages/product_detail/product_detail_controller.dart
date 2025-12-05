import 'dart:convert';
import 'dart:ffi';
import 'package:easyqist/api/ApiEndpoints.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../../models/ApiResponseViewCart.dart';
import '../../models/ItemModel.dart';
import '../../util/Singleton.dart';

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
// ===============================
// ADD TO CART LOGIC
// ===============================
  bool isBool = false;
  int index = 0;
  Future<void> addToCartButtonClick() async {
    if (detail.value == null || selectedProductType.value == null || filteredInstallments.isEmpty) {
      Get.snackbar("Error", "Please select plan options first");
      return;
    }

    final item = detail.value!;
    final type = selectedProductType.value!;
    final plan = filteredInstallments.first;

   

    print("data ${plan.duration}");
    // check if already added previously using API
    await checkProductInCart(productId: item.id!, typeId: type.id!).then((exists) {
      if (exists == true) {
        if(isBool){
          addToCart(
            orderSessionId: "anson5555",
            orderStatus: 0,
            userId: Singleton.user!.value!.id!,
            productId: item.id!,
            orderProductAmount: int.parse(plan.totalAmount!),
            orderProductAdvanceAmount:int.parse(plan.advance.toString()),
            qty: Singleton.getViewCartOrder.value!.orderProducts![index].qty! + 1,
            orderProductStatus: 0,
            installmentId: int.parse(plan.id.toString()),
            installment:int.parse(plan.duration.toString()),// installIndex == 0 ? 0 : 1,
            productTypeId: type.id!,
            categoryId: item.categoryId!,
            brandId: item.brandId!,
            orderId: Singleton.order.value,
            orderProductId: existingOrderProductId,
            duration: int.parse(plan.duration.toString()),
          );
        }else{
          addToCart(
            orderSessionId: "anson5555",
            orderStatus: 0,
            userId: Singleton.user!.value!.id!,
            productId: item.id!,
            orderProductAmount: int.parse(plan.totalAmount!),
            orderProductAdvanceAmount:int.parse(plan.advance.toString()),
            qty:  1,
            orderProductStatus: 0,
            installmentId: int.parse(plan.id.toString()),
            installment:int.parse(plan.duration.toString()),// installIndex == 0 ? 0 : 1,
            productTypeId: type.id!,
            categoryId: item.categoryId!,
            brandId: item.brandId!,
            orderId: Singleton.order.value,
            orderProductId: existingOrderProductId,
            duration: int.parse(plan.duration.toString()),
          );
        }


      } else {
        addToCartNewProduct(
          productId: item.id!,
          typeId: type.id!,
          plan: plan,
        );
      }
    });
  }

/* ------------------------------------------
    API CALL 1 : ADD NEW PRODUCT TO CART
-------------------------------------------*/
  Future<void> addToCartNewProduct({
    required int productId,
    required int typeId,
    required InstallmentPlan plan,
  }) async {
    try {
      final url = Uri.parse(ApiEndpoints.add_to_cart);

      final body = {
        "order_session_id": "anson5555", // your session id
        "order_status": "0",
        "user_id": Singleton.user.value?.id.toString(),
        "product_id": productId.toString(),
        "order_product_amount": plan.totalAmount.toString(),
        "order_product_advance_amount": plan.advance.toString(),
        "qty": "1",
        "order_product_status": "0",
        "order_product_installment_id": plan.id.toString(),
        "order_product_installment": plan.duration.toString(),
        "order_product_type_id": typeId.toString(),
        "category_id": detail.value!.categoryId.toString(),
        "brand_id": detail.value!.brandId.toString(),
        "order_product_duration": plan.duration.toString(),
      };

      final res = await http.post(url, body: body);
      print("NewCart Response: ${res.body}");

      if (res.statusCode == 200) {
        Get.snackbar("Success", "Added to cart");
        final response = ApiResponseViewCart.fromJson(json.decode(res.body));

        if (response.status == true && response.data != null) {
          Singleton.order.value = response.data?.id ?? -1;
          Singleton.getViewCartOrder.value = response.data;
        }
      // Singleton.cartCount.value++;
      } else {
        Get.snackbar("Failed", "Unable to add product");
      }
    } catch (e) {
      print("Error addToCartNewProduct: $e");
    }
  }


/* ------------------------------------------
    API CALL 2 : UPDATE CART PRODUCT QTY
-------------------------------------------*/
  Future<void> addToCart({
    required String orderSessionId,
    required int orderStatus,
    required int userId,
    required int productId,
    required int orderProductAmount,
    required int orderProductAdvanceAmount,
    required int qty,
    required int orderProductStatus,
    required int installmentId,
    required int installment,
    required int productTypeId,
    required int categoryId,
    required int brandId,
    required int orderId,
    required int orderProductId,
    required int duration,
  }) async {
    try {
      final url = Uri.parse(ApiEndpoints.add_to_cart);

      final body = {
        "order_session_id": orderSessionId,
        "order_status": orderStatus.toString(),
        "user_id": userId.toString(),
        "product_id": productId.toString(),
        "order_product_amount": orderProductAmount.toString(),
        "order_product_advance_amount": orderProductAdvanceAmount.toString(),
        "qty": qty.toString(),
        "order_product_status": orderProductStatus.toString(),
        "order_product_installment_id": installmentId.toString(),
        "order_product_installment": installment.toString(),
        "order_product_type_id": productTypeId.toString(),
        "category_id": categoryId.toString(),
        "brand_id": brandId.toString(),
        "order_id": orderId.toString(),
        "order_product_id": orderProductId.toString(),
        "order_product_duration": duration.toString(),
      };

      final res = await http.post(url, body: body);

      print("AddToCart Update Response: ${res.body}");

      if (res.statusCode == 200) {
        Get.snackbar("Updated", "Cart quantity updated");
        final response = ApiResponseViewCart.fromJson(json.decode(res.body));

        if (response.status == true && response.data != null) {
          Singleton.order.value = response.data?.id ?? -1;
          Singleton.getViewCartOrder.value = response.data;
        }
      } else {
        Get.snackbar("Error", "Unable to update cart");
      }
    } catch (e) {
      print("Error addToCart(): $e");
    }
  }



//////////////////////////////////////////////////////
// CHECK IF PRODUCT ALREADY EXISTS IN CART
//////////////////////////////////////////////////////

  int existingOrderId = 0;
  int existingOrderProductId = 0;
  int existingQty = 0;

  Future<bool> checkProductInCart({
    required int productId,
    required int typeId,
  }) async {
    try {
      // final url = Uri.parse(ApiEndpoints.add_to_cart);
      //
      // final body = {
      //   "user_id": Singleton.user.value.toString(),
      //   "product_id": productId.toString(),
      //   "product_type_id": typeId.toString(),
      // };
      //
      // final res = await http.post(url, body: body);
      //
      // if (res.statusCode == 200) {
      //   final jsonData = jsonDecode(res.body);
      //
      //   if (jsonData["exists"] == true) {
      //     existingOrderId = jsonData["order_id"];
      //     existingOrderProductId = jsonData["order_product_id"];
      //     existingQty = jsonData["qty"];
      //     return true;
      //   }
      // }

      if(Singleton.order.value!=-1) {
        final orderProducts = Singleton.getViewCartOrder.value?.orderProducts;

        if (orderProducts != null) {
          for (var data in orderProducts) {
            if (data.productId == productId) {
              isBool = true;
              break;
            } else {
              isBool = false;
            }
            index++;
          }
        }
        existingOrderId = Singleton.order.value;
        existingOrderProductId =  Singleton.getViewCartOrder.value!.orderProducts![index].id!;
        return true;
      }
    } catch (e) {
      print("Error checkProductInCart: $e");
    }

    return false;
  }


}
