import 'package:cached_network_image/cached_network_image.dart';
import 'package:easyqist/util/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'ProfileController.dart';

class ProfileScreen extends StatelessWidget {
  final ProfileController controller = Get.put(ProfileController());

  ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
          children: [
            /// Background gradient
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.primary,
                    AppColors.primary,
                    Colors.white,
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),

            /// Top transparent pattern
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Image.asset(
                'assets/icons/upper_transparent.png',
                fit: BoxFit.cover,
                width: double.infinity,
                height: 220,
              ),
            ),

            SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              AppBar(
                title: const Text(
                  "Profile",
                  style: TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 20),
                ),
                backgroundColor: Colors.transparent,
                elevation: 0,
                centerTitle: true,
              ),
            //  Expanded(child:
              Container(
                decoration: const BoxDecoration(
                  color: Color(0xFFF5F5F5), // light grey background
                ),
                child: Column(
                  children: [
                    /// PROFILE HEADER
                    Obx(() => GestureDetector(
                      onTap: controller.checkLogin.value
                          ? null
                          : () => controller.onLoginClick(),
                      child: Container(
                        margin: const EdgeInsets.all(16),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: const [
                            BoxShadow(
                                color: Colors.black12,
                                blurRadius: 4,
                                offset: Offset(2, 2))
                          ],
                        ),
                        child: Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(50),
                              child: CachedNetworkImage(
                                imageUrl: controller.userImage.value,
                                height: 70,
                                width: 70,
                                fit: BoxFit.cover,
                                placeholder: (c, s) =>
                                const CircularProgressIndicator(strokeWidth: 2),
                                errorWidget: (c, s, e) => Icon(Icons.person,
                                    size: 50, color: Colors.grey.shade400),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Text(
                                controller.checkLogin.value
                                    ? controller.userName.value
                                    : "Hi there!!\nLogin/Signup",
                                style: const TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.w600),
                              ),
                            ),
                            if (controller.checkLogin.value)
                              IconButton(
                                icon: const Icon(Icons.edit, color: AppColors.primary),
                                onPressed: controller.onEditProfile,
                              )
                          ],
                        ),
                      ),
                    )),

                    const SizedBox(height: 10),

                    /// MENU ITEMS
                    Obx(() => Column(
                      children: [
                        if (controller.checkLogin.value)
                          buildMenuCard("Track Order & History", onTap: controller.onTrackOrder),

                        if (!controller.checkVendorLogin.value)
                          buildMenuCard("Vendor", onTap: controller.onVendor),

                        if (controller.checkVendorLogin.value)
                          buildMenuCard("Vendor Request Product", onTap: controller.onVendorRequest),

                        if (controller.checkVendorLogin.value)
                          buildMenuCard("Vendor Request Product List", onTap: controller.onVendorRequestList),

                        buildMenuCard("Help & Support", onTap: controller.onHelpSupport),
                        buildMenuCard("Shop Locations", onTap: controller.onMap),
                        buildMenuCard("About Us", onTap: controller.onAboutUs),
                        buildMenuCard("Privacy & Policy", onTap: controller.onPrivacy),
                        buildMenuCard("Terms & Conditions", onTap: controller.onTerms),

                        if (controller.checkLogin.value)
                          buildMenuCard("Logout", iconColor: Colors.red, onTap: controller.logout),
                      ],
                    )),


                    const SizedBox(height: 20),

                    /// SOCIAL MEDIA
                    buildSocialCard(),
                  ],
                ),
              )
              //)

            ],
          ),
        ),
      ),
          ])
    );
  }

  Widget buildMenuCard(String title, {Function()? onTap, Color iconColor = AppColors.primary}) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(2, 2))
        ],
      ),
      child: ListTile(
        title: Text(title, style: const TextStyle(fontSize: 15)),
        trailing: Icon(Icons.arrow_forward_ios, size: 16, color: iconColor),
        onTap: onTap,
      ),
    );
  }

  Widget buildSocialCard() {
    return Container(
      padding: const EdgeInsets.all(18),
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(2, 2))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Check us out on:", style: TextStyle(fontWeight: FontWeight.w600)),
          const SizedBox(height: 14),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              GestureDetector(
                  onTap: controller.openTikTok, child: Image.asset("assets/icons/tiktok.png", height: 30)),
              GestureDetector(
                  onTap: controller.openInstagram, child: Image.asset("assets/icons/instagram.png", height: 30)),
              GestureDetector(
                  onTap: controller.openFacebook, child: Image.asset("assets/icons/facebook.png", height: 30)),
              GestureDetector(
                  onTap: controller.openYouTube, child: Image.asset("assets/icons/youtube.png", height: 30)),
            ],
          ),
        ],
      ),
    );
  }
}
