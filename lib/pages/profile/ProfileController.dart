import 'dart:developer';

import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../storage/data_storage_repository.dart';
import '../../util/Singleton.dart';
import '../../util/app_routes.dart';

class ProfileController extends GetxController {
  final _repo = DataStorageRepository();
  var userName = "Hassam Rana".obs;
  var userImage = "https://images.unsplash.com/photo-1603415526960-f7e0328e5f64?w=500".obs;
  var checkLogin = false.obs;
  var checkVendorLogin = false.obs;

  void updateName(String name) => userName.value = name;
  void updateImage(String url) => userImage.value = url;

  void onLoginClick() {
    // Navigate to login
    Get.toNamed(AppRoutes.login);
  }

  void onTrackOrder() => print("Track Order Clicked");
  void onVendor() => print("Vendor Clicked");
  void onVendorRequest() => print("Vendor Request Product Clicked");
  void onVendorRequestList() => print("Vendor Request Product List Clicked");
  void onHelpSupport() => print("Help & Support Clicked");
  void onMap() => print("Open Map Clicked");
  void onAboutUs() => print("About Us Clicked");
  void onPrivacy() => print("Privacy & Policy Clicked");
  void onTerms() => print("Terms & Conditions Clicked");
  void onEditProfile() => print("Edit Profile Clicked");
  Future<void> logout() async {
    Singleton.isLogin.value = false;
    Singleton.user.value=null;
    final storage = DataStorageRepository();
    await storage.clearUserData();
    print("User Logged Out");
  }

  Future<void> openWhatsApp(String contactNumber) async {
    final uri = Uri.parse("https://wa.me/$contactNumber");
    await _launchUrl(uri);
  }

  /// Open Facebook
  Future<void> openFacebook() async {
    final uri = Uri.parse("https://www.facebook.com/profile.php?id=61565595124134");
    await _launchUrl(uri);
  }

  /// Open Instagram
  Future<void> openInstagram() async {
    final uri = Uri.parse("https://www.instagram.com/easyqist?igsh=MXhpeno3MHFuc3Vocw==");
    await _launchUrl(uri);
  }

  /// Open TikTok
  Future<void> openTikTok() async {
    final uri = Uri.parse("https://www.tiktok.com/@easyqist.com");
    await _launchUrl(uri);
  }

  /// Open YouTube
  Future<void> openYouTube() async {
    final uri = Uri.parse("https://youtube.com/@easyqist?si=mG20u07I9ojyKFtK");
    await _launchUrl(uri);
  }

  /// Generic launcher function
  Future<void> _launchUrl(Uri uri) async {
    try {
      if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
        Get.snackbar("Error", "Could not open the link");
      }
    } catch (e) {
      Get.snackbar("Error", "Something went wrong: $e");
    }
  }

  @override
  void onInit() {
    super.onInit();
    // Initialize login & user from Singleton/DataStorage
    checkLogin.value = Singleton.isLogin.value;
    if (Singleton.user.value != null) {
      userName.value = Singleton.user.value!.name ?? "User";
      //userImage.value = Singleton.user.value!.profileImage ?? userImage.value;
    }

    // Listen to singleton login changes
    ever(Singleton.isLogin, (val) {

      checkLogin.value = val;
      if (val && Singleton.user.value != null) {
        userName.value = Singleton.user.value!.name ?? "User";
        //userImage.value = Singleton.user.value!.profileImage ?? userImage.value;
      }
    });
    retrieveData();
  }


  void retrieveData() {

    final user = _repo.getUser();
    if (user != null) {
      Singleton.user.value = user;
      Singleton.isLogin.value = _repo.getIsLogin();
    }

    final vendor = _repo.getVendorUser();
    if (vendor != null) {
      Singleton.userVendor.value = vendor;
      Singleton.checkVendorLogin.value = true;
      log('✅ Vendor loaded: ${vendor.toJson()}');
    }

    Singleton.notificationToken = _repo.getToken() ?? '';
  }
}

