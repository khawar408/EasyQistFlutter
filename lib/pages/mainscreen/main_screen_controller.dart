import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

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
}
