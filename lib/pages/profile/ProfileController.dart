import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../util/app_routes.dart';

class ProfileController extends GetxController {
  var userName = "Hassam Rana".obs;
  var userImage = "https://images.unsplash.com/photo-1603415526960-f7e0328e5f64?w=500".obs;
  var checkLogin = false.obs;
  var checkVendorLogin = false.obs;

  void updateName(String name) => userName.value = name;
  void updateImage(String url) => userImage.value = url;

  void onLoginClick() {
    // Navigate to login
    Get.offAllNamed(AppRoutes.login);
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
  void logout() {
    checkLogin.value = false;
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
}

