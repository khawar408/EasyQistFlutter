import 'dart:convert';

import 'package:easyqist/api/ApiEndpoints.dart';
import 'package:easyqist/util/Singleton.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

import '../../models/ApiResponseViewCart.dart';

class MainScreenController extends GetxController {
  var currentIndex = 0.obs;

  void changePage(int index) {
    currentIndex.value = index;
  }

  void openWhatsApp(String contactNumber) async {
    final Uri uri = Uri.parse("whatsapp://send?phone=$contactNumber");
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      Get.snackbar('Error', 'WhatsApp is not installed');
    }
  }

  Future<ApiResponseViewCart> viewOrderCard(int userId, int orderStatus) async {
    final uri = Uri.parse("${ApiEndpoints.view_order_card}")
        .replace(queryParameters: {
      "user_id": userId.toString(),
      "order_status": orderStatus.toString(),
    });

    final response = await http.get(uri);

    if (response.statusCode == 200) {
      return ApiResponseViewCart.fromJson(json.decode(response.body));
    } else {
      throw Exception("Failed: ${response.statusCode}");
    }
  }

  Future<void> fetchCart() async {
    try {


        // get user from shared prefs or memory

      final response = await viewOrderCard(Singleton.user.value!.id!, 0);

      if (response.status == true && response.data != null) {
        Singleton.order.value = response.data?.id ?? -1;
        Singleton.getViewCartOrder.value = response.data;
      }
    } catch (e) {
      print("Cart Error: $e");
    } finally {
    }
  }

}
