import 'dart:convert';

import 'package:easyqist/util/Singleton.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../api/ApiEndpoints.dart';
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

      final uri = Uri.parse("${ApiEndpoints.view_order_card}")
          .replace(queryParameters: {
        "user_id": Singleton.user.value!.id.toString(),
        "order_status": "0",
      });

      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final data = ApiResponseViewCart.fromJson(json.decode(response.body));

        if (data.status == true) {
          cart.value = data.data;
          calculateTotals();
        }
      } else {
        throw Exception("Failed: ${response.statusCode}");
      }
      // var response = await apiService.get("your/view-cart-api");
      //

    } catch (e) {
      print("Cart error: $e");
    } finally {
      isLoading(false);
    }
  }

  // QTY UPDATE
  void updateQty(int index, int newQty) {
    var item = cart.value!.orderProducts![index];
    final qty = Singleton.getViewCartOrder?.value?.orderProducts?[index].qty ?? 1;

    final advance = (double.tryParse(item.orderProductAdvanceAmount ?? '') ?? 0).toInt() ~/ qty;

    final totalAmount = (double.tryParse(item.orderProductAmount ?? '') ?? 0).toInt() ~/ qty;
    print("AddToCart Update Response: ${item.id}");
    addToCart(
      orderSessionId: "anson5555",
      orderStatus: 0,
      userId: Singleton.user!.value!.id!,
      productId: item.productId!,
      orderProductAmount: int.parse(totalAmount.toString()),
      orderProductAdvanceAmount:int.parse(advance.toString()),
      qty: newQty,
      orderProductStatus: 0,
      installmentId: int.parse(item.orderProductInstallmentId.toString()),
      installment:int.parse(item.orderProductInstallment.toString()),// installIndex == 0 ? 0 : 1,
      productTypeId: item.orderProductTypeId??0,
      categoryId: item.categoryId!,
      brandId: item.brandId!,
      orderId: Singleton.order.value,
      orderProductId: item.id!!,
      duration: int.parse(item.orderProductDuration.toString()),
    );
    // calculateTotals();
    // cart.refresh();
  }

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
        final data = ApiResponseViewCart.fromJson(json.decode(res.body));

        if (data.status == true) {
          cart.value = data.data;
          Singleton.getViewCartOrder.value = data.data;
          calculateTotals();
        }
      } else {
        Get.snackbar("Error", "Unable to update cart");
      }
    } catch (e) {
      print("Error addToCart(): $e");
    }
  }

  // TOTAL CALCULATION
  void calculateTotals() {
    totalAdvance(0.0);
    totalAmount(0.0);

    if (cart.value?.orderProducts == null) return;

    // for (var p in cart.value!.orderProducts!) {
      totalAdvance.value = double.parse(cart.value?.orderAdvanceAmount ?? "0");
      totalAmount.value += double.parse(cart.value?.orderPrice ?? "0");
   // }
  }

  // =============================
  // REMOVE PRODUCT API
  // =============================
  Future<void> removeItem(int index) async {
    var item = cart.value!.orderProducts![index];
    //
    try {
      final uri = Uri.parse("${ApiEndpoints.del_order_product}")
          .replace(queryParameters: {
        "id": item.id.toString(),
        "order_id": "${item.orderId}",
      });

      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final data = ApiResponseViewCart.fromJson(json.decode(response.body));
        print("Remove item error: ${data.toString()}");
        if (data.status == true&& data.data != null) {
          cart.value = data.data;
          Singleton.getViewCartOrder.value = data.data;
          calculateTotals();
        }

      }
    } catch (e) {
      print("Remove item error: $e");
    }
  }
}
