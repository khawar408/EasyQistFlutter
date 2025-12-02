import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';
import '../../models/user.dart';
import '../../models/vendor.dart';
import '../../storage/data_storage_repository.dart';
import '../../util/app_routes.dart';
import '../../util/singleton.dart';

class SplashController extends GetxController {
  final _repo = DataStorageRepository();

  var checkFirst = false.obs;
  var checkVFirst = false.obs;
  var isLogin = false.obs;
  var isVendorLogin = false.obs;

  @override
  void onInit() {
    super.onInit();
    // retrieveData();
    _startDelay();
  }

  // void retrieveData() {
  //   checkFirst.value = _repo.getCheckFirstTime();
  //   checkVFirst.value = _repo.getCheckVFirstTime();
  //   isLogin.value = _repo.getIsLogin();
  //   isVendorLogin.value = _repo.getIsVendorLogin();
  //
  //   log('✅ User loaded: ${isLogin.value}');
  //
  //   final user = _repo.getUser();
  //   if (user != null) {
  //     Singleton.user.value = user;
  //     Singleton.isLogin.value = true;
  //     log('✅ User loaded: ${user.toJson()}');
  //     log('✅ User loaded: ${Singleton.isLogin.value}');
  //   }
  //
  //   final vendor = _repo.getVendorUser();
  //   if (vendor != null) {
  //     Singleton.userVendor.value = vendor;
  //     Singleton.checkVendorLogin.value = true;
  //     log('✅ Vendor loaded: ${vendor.toJson()}');
  //   }
  //
  //   Singleton.notificationToken = _repo.getToken() ?? '';
  // }



  void _startDelay() async {
    await Future.delayed(const Duration(seconds: 4));
    await _handleNavigation();
  }

  Future<void> _handleNavigation() async {
    int versionCode = await _getVersionCode();

    // if (versionCode >= 13) {
    //   if (checkVFirst.value) {
    //     Singleton.setLogin(false);
    //     Singleton.user.value = User();
    //     Singleton.getViewCartOrder.value = null;
    //     clearUserData();
    //   }
    //   _navigateNext();
    // } else {
      _navigateNext();
      // _showUpdateDialog();
   // }
  }

  Future<int> _getVersionCode() async {
    try {
      final info = await PackageInfo.fromPlatform();
      return int.tryParse(info.buildNumber) ?? -1;
    } catch (e) {
      log('Version check failed: $e');
      return -1;
    }
  }

  void _navigateNext() {
    if (checkFirst.value) {
      Get.offAllNamed(AppRoutes.mainScreen);
    } else {
      Get.offAllNamed(AppRoutes.mainScreen);
    }
  }

  void _showUpdateDialog() {
    Get.dialog(
      AlertDialog(
        title: const Text('Update Available'),
        content: const Text('A new version of the app is available. Please update to continue.'),
        actions: [
          TextButton(
            onPressed: () {
              final pkg = 'https://play.google.com/store/apps/details?id=com.easy.qist';
              Get.back();
              Singleton.launchURL(pkg);
            },
            child: const Text('Update'),
          ),
          TextButton(
            onPressed: () {
              Get.back();
              _navigateNext();
            },
            child: const Text('Cancel'),
          ),
        ],
      ),
      barrierDismissible: false,
    );
  }
}
