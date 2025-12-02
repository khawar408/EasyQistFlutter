import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/ApiResponseViewCart.dart';
import '../models/user.dart';
import '../models/vendor.dart';


class Singleton {
  static Rx<User?> user = Rx<User?>(null);
  static Rx<Vendor?> userVendor = Rx<Vendor?>(null);
  static RxBool checkVendorLogin = false.obs;
  static RxBool isLogin = false.obs;
  static String notificationToken = '';

  static void setLogin(bool value) {
    isLogin.value = value;
  }

  // 🔥 Equivalent to Kotlin: var order = -1
  static RxInt order = (-1).obs;

  // 🔥 Equivalent to Kotlin: MutableLiveData<ViewCartOrder>()
  static Rx<ViewCartOrder?> getViewCartOrder = Rx<ViewCartOrder?>(null);

  static Future<void> launchURL(String url) async {
    final uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      Get.snackbar('Error', 'Could not open the link');
    }
  }
}
