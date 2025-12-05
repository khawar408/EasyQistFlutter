import 'package:get/get.dart';

import '../../models/ApiResponseViewCart.dart';


class CartController extends GetxController {
  var isLoading = true.obs;
  var cart = Rxn<ViewCartOrder>(); // Holds cart object
  var totalAdvance = 0.0.obs;
  var totalAmount = 0.0.obs;

  // final ApiService apiService = Get.find();

  @override
  void onInit() {
    fetchCart();
    super.onInit();
  }

  // FETCH CART API
  Future<void> fetchCart() async {
    try {
      isLoading(true);

      // var response = await apiService.get("your/view-cart-api");
      //
      // final data = ApiResponseViewCart.fromJson(response);
      //
      // if (data.status == true) {
      //   cart.value = data.data;
      //   calculateTotals();
      // }
    } catch (e) {
      print("Cart error: $e");
    } finally {
      isLoading(false);
    }
  }

  // QTY UPDATE
  void updateQty(int index, int newQty) {
   // cart.value!.orderProducts![index].qty = newQty;
    calculateTotals();
    cart.refresh();
  }

  // TOTAL CALCULATION
  void calculateTotals() {
    totalAdvance(0.0);
    totalAmount(0.0);

    if (cart.value?.orderProducts == null) return;

    for (var p in cart.value!.orderProducts!) {
      totalAdvance.value += double.parse(p.orderProductAdvanceAmount ?? "0");
      totalAmount.value += double.parse(p.orderProductAmount ?? "0");
    }
  }

  // =============================
  // REMOVE PRODUCT API
  // =============================
  Future<void> removeItem(int index) async {
    var item = cart.value!.orderProducts![index];

    try {
      final response = await apiService.get(
        "api/del_order_product?id=${item.id}&order_id=${item.orderId}",
      );

      final data = ApiResponseViewCart.fromJson(response);

      if (data.status == true) {
        cart.value = data.data; // updated cart list
        calculateTotals();
      }
    } catch (e) {
      print("Remove item error: $e");
    }
  }
}
